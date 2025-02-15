import json
import random
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
    model=os.getenv("GENAI_MODEL", "gemini-1.5-flash"),
    max_tokens=int(os.getenv("GENAI_MAX_TOKENS", 1024)),
    timeout=int(os.getenv("GENAI_TIMEOUT", 60)),
    max_retries=int(os.getenv("GENAI_MAX_RETRIES", 5)),
)

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
    
    response = llm.invoke(prompt_template)
    return response.content.split("\n") if hasattr(response, "content") else []


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
    response = llm.invoke(review_prompt)
    
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
        result = chain.invoke({"prompt": prompt})
        score = evaluate_results(result)
        results_summary.append({"prompt": prompt, "result": result, "score": score})
        print(f"Score: {score}\n")
    
    llm_review = review_results_with_llm(results_summary)
    print("LLM Review:\n", llm_review)
    
    return results_summary, llm_review


from search import chain  # Import the existing book search/recommendation system
results, llm_review = run_tests(chain)

with open("test_results.json", "w", encoding="utf-8") as f:
    json.dump({"results": results, "llm_review": llm_review.strip()}, f, indent=4)

print("Test results and LLM review saved to test_results.json")
