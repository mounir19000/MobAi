import json
import random
import time
from langchain_google_genai import ChatGoogleGenerativeAI
from dotenv import load_dotenv
import os

def load_books(json_file="books.json"):
    """Loads book data from a JSON file."""
    try:
        with open(json_file, "r", encoding="utf-8") as file:
            books = json.load(file)
        return books
    except Exception as e:
        print(f"Error loading books: {e}")
        return []

# Load environment variables
load_dotenv()

# Initialize LLM for generating test prompts and reviewing results
llm = ChatGoogleGenerativeAI(
    model=os.getenv("GENAI_MODEL", "gemini-2.5-flash"),
    max_tokens=int(os.getenv("GENAI_MAX_TOKENS", 1024)),
    timeout=int(os.getenv("GENAI_TIMEOUT", 60)),
    max_retries=int(os.getenv("GENAI_MAX_RETRIES", 5)),
)

def invoke_with_retry(callable_fn, *args, max_retries=5, base_delay=60, **kwargs):
    """Invokes a callable with exponential backoff retry on rate limit errors."""
    for attempt in range(max_retries):
        try:
            return callable_fn(*args, **kwargs)
        except Exception as e:
            error_str = str(e)
            if "429" in error_str or "RESOURCE_EXHAUSTED" in error_str:
                # Try to extract retry delay from error message
                delay = base_delay * (attempt + 1)
                try:
                    import re
                    match = re.search(r'retry\s*(?:in|Delay["\s:]*)\s*["\']?(\d+)', error_str, re.IGNORECASE)
                    if match:
                        delay = int(match.group(1)) + 5  # Add 5s buffer
                except Exception:
                    pass
                print(f"  Rate limited (attempt {attempt + 1}/{max_retries}). Waiting {delay}s before retrying...")
                time.sleep(delay)
            else:
                raise  # Re-raise non-rate-limit errors
    raise RuntimeError(f"Failed after {max_retries} retries due to rate limiting.")

def generate_test_prompts():
    """Uses LLM to generate relevant test prompts based on the book database."""
    books = load_books()
    if not books:
        print("No books found in the database.")
        return []
    
    # Extract key book details
    book_titles = [book["name"] for book in books[:10]]  # Sample 10 books
    genres = list(set(book["genre"] for book in books if "genre" in book))[:5]  # Get unique genres
    authors = list(set(book["author"] for book in books if "author" in book))[:5]  # Get unique authors

    # Create a better prompt for LLM
    prompt_template = (
        f"The book database contains books with the following details:\n"
        f"- Sample book titles: {', '.join(book_titles)}\n"
        f"- Genres: {', '.join(genres)}\n"
        f"- Authors: {', '.join(authors)}\n\n"
        "Generate 4 test prompts that a user might use to search for books in this database. "
        "Make some specific (e.g., mentioning a genre, author, or theme) and others vague (e.g., 'something exciting'). "
        "Ensure they are diverse and relevant to the given database."
        "Generate only the prompts and nothing more."
    )
    
    response = invoke_with_retry(llm.invoke, prompt_template)
    prompts = [p.strip() for p in response.content.split("\n") if p.strip()] if hasattr(response, "content") else []
    return prompts


def evaluate_results(results):
    """Simple evaluation metric based on result count and relevance."""
    if not results or not results.get("results"):
        return "Poor (No results returned)"
    elif len(results["results"]) < 3:
        return "Fair (Few results returned)"
    else:
        return "Good (Multiple relevant results)"

def review_results_with_llm(results_summary):
    """Uses LLM to analyze and summarize the test results."""
    review_prompt = (
        "Analyze the following book search test results and provide a summary of their effectiveness.\n\n"
        f"{json.dumps(results_summary, indent=2)}"
    )
    response = invoke_with_retry(llm.invoke, review_prompt)
    
    # Extract text content from AIMessage
    return response.content if hasattr(response, "content") else str(response)

def run_tests(chain):
    """Runs generated prompts through the book search and recommendation system and evaluates the output."""
    test_prompts = generate_test_prompts()
    if not test_prompts:
        print("Failed to generate test prompts.")
        return
    
    results_summary = []
    
    for prompt in test_prompts:
        print(f"Testing prompt: {prompt}")
        time.sleep(10)  # Add sleep to avoid rate limits (increased from 5 to 10)
        try:
            result = invoke_with_retry(chain.invoke, {"prompt": prompt})
        except Exception as e:
            print(f"  Error processing prompt: {e}")
            result = {"results": [], "isBuying": False}
        score = evaluate_results(result)
        results_summary.append({"prompt": prompt, "result": result, "score": score})
        print(f"Score: {score}\n")
    
    time.sleep(10)  # Wait before the review call
    llm_review = "LLM review is commented."
    # llm_review = review_results_with_llm(results_summary)
    # print("LLM Review:\n", llm_review)
    
    return results_summary, llm_review


from search import chain  # Import the existing book search/recommendation system
results, llm_review = run_tests(chain)

with open("test_results.json", "w", encoding="utf-8") as f:
    json.dump({"results": results, "llm_review": llm_review.strip()}, f, indent=4)

print("Test results and LLM review saved to test_results.json")
