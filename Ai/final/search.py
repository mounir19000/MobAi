import os
import pickle
import json
import numpy as np
import faiss
from dotenv import load_dotenv
from sentence_transformers import SentenceTransformer
from langchain.prompts import ChatPromptTemplate
from langchain.schema.output_parser import StrOutputParser
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.schema.runnable import RunnableBranch


# Load environment variables
load_dotenv()

# Load books from JSON
def load_books(json_file="books.json"):
    """Loads book data from a JSON file."""
    try:
        with open(json_file, "r", encoding="utf-8") as file:
            books = json.load(file)
        return books
    except Exception as e:
        print(f"Error loading books: {e}")
        return []

model = ChatGoogleGenerativeAI(
    model=os.getenv("GENAI_MODEL", "gemini-1.5-flash"),
    max_tokens=int(os.getenv("GENAI_MAX_TOKENS", 1024)),
    timeout=int(os.getenv("GENAI_TIMEOUT", 60)),
    max_retries=int(os.getenv("GENAI_MAX_RETRIES", 5)),
)

classification_template = ChatPromptTemplate.from_messages(
    [
        ("system", "You are an AI assistant that will help me classify the prompt. and you will print the prompt you get before every step."),
        ("human",
         "Classify the prompt as just searching for books (Label it as BookSearch) or want to buy a book (Label it as BuyBook): {prompt}."
         "if the user gives you a prompt with just some words without any context, consider it a searching prompt."),
    ]
)

# Initialize SentenceTransformer
embedding_model = SentenceTransformer("all-MiniLM-L6-v2")

# FAISS-related setup
book_ids = []
book_vectors = []
faiss_index = None

# Load books
books = load_books()

# FAISS Initialization
def initialize_faiss():
    global book_ids, book_vectors, faiss_index
    max_chunk_size = 1000
    overlap = 200

    def chunk_text(text, max_size, overlap_size):
        chunks = []
        for i in range(0, len(text), max_size - overlap_size):
            chunks.append(text[i: i + max_size])
        return chunks

    for book in books:
        text = f"Book name: {book['name']}, Book author: {book['author']}, Book genre: {book['genre']}, Book rating : {book['rating']}, Book description: {book['description']}"
        chunks = chunk_text(text, max_chunk_size, overlap)

        for chunk in chunks:
            book_ids.append(book["id"])
            book_vectors.append(embedding_model.encode(chunk))

    book_vectors_np = np.array(book_vectors, dtype="float32")

    if book_vectors_np.shape[0] > 0:
        dimension = book_vectors_np.shape[1]
        faiss_index = faiss.IndexFlatL2(dimension)
        faiss_index.add(book_vectors_np)
    else:
        raise ValueError("No book embeddings found to initialize FAISS index.")

# Save FAISS index
def save_faiss():
    faiss.write_index(faiss_index, "faiss_index.bin")
    with open("metadata.pkl", "wb") as f:
        pickle.dump({"book_ids": book_ids}, f)

# Load FAISS index
def load_faiss():
    global faiss_index, book_ids
    faiss_index = faiss.read_index("faiss_index.bin")
    with open("metadata.pkl", "rb") as f:
        metadata = pickle.load(f)
        book_ids = metadata["book_ids"]

# Initialize FAISS (load if exists, otherwise build)
if os.path.exists("faiss_index.bin") and os.path.exists("metadata.pkl"):
    load_faiss()
else:
    initialize_faiss()
    save_faiss()

def filter_results_with_llm(query, results):
    """
    Uses LLM to filter out irrelevant book recommendations while maintaining the result structure.
    """
    filtering_prompt = ChatPromptTemplate.from_messages(
        [
            ("system", "You are an AI assistant that helps refine book recommendations. You will receive a user query and a list of recommended books. Remove books that are irrelevant to the query while keeping the original JSON structure and giving it as it is in a string with no decorators.  Ensure the response is valid JSON. If the new list is empty send it empty."),
            ("human", "User Query: {query}\n\nRecommended Books:\n{results}\n\nReturn the filtered book list in the same JSON format.")
        ]
    )
    
    filtering_chain = filtering_prompt | model | StrOutputParser()
    
    filtered_books = filtering_chain.invoke({"query": query, "results": json.dumps(results)})
    
    try:
        filtered_results = json.loads(filtered_books)
        return {"results": filtered_results, "isBuying": False}  # Ensure structure consistency
    except json.JSONDecodeError:
        print("Error parsing filtered books.")
        return {"results": results, "isBuying": False}  # Fallback in case of parsing issues
    

# Book Search
def search_books(query):
    query_vector = embedding_model.encode(query).reshape(1, -1)
    distances, indices = faiss_index.search(query_vector, 20)
    
    results = []
    for i, idx in enumerate(indices[0]):
        if idx < len(book_ids):
            book = next((b for b in books if b["id"] == book_ids[idx]), None)
            if book:
                results.append({
                    "book_id": book["id"],
                    "name": book["name"],
                    "author": book["author"],
                    "genre": book["genre"],
                    # "distance": float(distances[0][i])
                })
    
    # Filter results using LLM while preserving structure
    return filter_results_with_llm(query, results)

# Book Purchase
def process_purchase(query):
    query_vector = embedding_model.encode(query).reshape(1, -1)
    distances, indices = faiss_index.search(query_vector, 1)
    
    results = []
    for i, idx in enumerate(indices[0]):
        if idx < len(book_ids):
            book_id = book_ids[idx]
            book = next((b for b in books if b["id"] == book_id), None)
            if book:
                results.append({
                    "book_id": book["id"],
                    "name": book["name"],
                    "author": book["author"],
                    "genre": book["genre"],
                    "distance": float(distances[0][i])
                })
    finalResult = {
        "results": results,
        "isBuying": False
    }
    return finalResult
branches = RunnableBranch(
    (
        lambda x: "BookSearch" in x,  # x is the classification output (a string)
        lambda _: search_books(_)  # Pass only the string to search_books
    ),
    (
        lambda x: "BuyBook" in x,
        lambda _: process_purchase(_)  # Pass only the string to process_purchase
    ),
    lambda _: "Invalid request. Please specify a valid book-related query."  # Default case
)

classification_chain = classification_template | model | StrOutputParser()

chain = classification_chain | branches

# response = chain.invoke({"prompt": "I want to find a good book about americans"})
# print(response)