from dotenv import load_dotenv
from langchain.prompts import ChatPromptTemplate
from langchain.schema.output_parser import StrOutputParser
from langchain.schema.runnable import RunnableBranch
from langchain_google_genai import ChatGoogleGenerativeAI
import os
import json
from sentence_transformers import SentenceTransformer
import faiss
import numpy as np
import pickle
import random

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
        ("system", "You are an AI assistant that will help me classify the prompt."),
        ("human",
         "Classify the prompt as just searching for books (Label it as BookSearch) or want to buy a book (Label it as BuyBook): {prompt}."),
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

def book_recommender(user, user_orders):
    """
    Recommends books to a user based on their search history, wishlist, and past orders.

    Args:
        user (dict): The user data containing searchPrompts, wishlist, and boughtBooks.
        user_orders (list): The list of orders containing purchased items.

    Returns:
        list: A list of recommended books.
    """
    # Extract user data
    user_search_prompts = user.get("searchPrompts", [])
    user_wishlist = set(user.get("wishlist", []))

    # Collect all book IDs from the user's past orders
    user_bought_books = set()
    for order in user_orders:
        for item in order.get("items", []):
            user_bought_books.add(item["bookId"])

    # If the user has no search history, wishlist, or past purchases, suggest random high-rated books
    if not user_search_prompts and not user_wishlist and not user_bought_books:
        top_rated_books = [book for book in books if book["rating"] >= 4.0]
        return random.sample(top_rated_books, min(5, len(top_rated_books)))  # Pick 5 random high-rated books

    # Encode user search prompts
    search_vectors = [embedding_model.encode(prompt) for prompt in user_search_prompts]
    search_vectors_np = np.array(search_vectors, dtype="float32")

    # Perform FAISS search
    if faiss_index is None:
        raise ValueError("FAISS index is not initialized.")

    D, I = faiss_index.search(search_vectors_np, k=5)  # Retrieve top 5 recommendations per search

    # Collect recommended book IDs
    recommended_book_ids = set()
    for indices in I:
        for idx in indices:
            recommended_book_ids.add(book_ids[idx])

    # Filter out books already bought by the user
    recommended_book_ids -= user_bought_books

    # Retrieve wishlist books and prioritize them
    wishlist_books = [book for book in books if book["bookid"] in user_wishlist]

    # Retrieve other recommended books
    other_books = [book for book in books if book["id"] in recommended_book_ids]

    # Combine wishlist books (high priority) and other recommendations
    recommended_books = wishlist_books + other_books

    # Sort recommendations (e.g., by rating or price if needed)
    recommended_books = sorted(recommended_books, key=lambda x: (-x["rating"], x["price"]))

    return recommended_books

# dummy_books = [
#     {
#         "id": "book1",
#         "bookid": 1,
#         "imageurl": "https://example.com/book1.jpg",
#         "name": "The AI Revolution",
#         "author": "John Smith",
#         "genre": "Science Fiction",
#         "price": 29.99,
#         "stock": 50,
#         "description": "A thrilling exploration of the future of artificial intelligence.",
#         "rating": 4.5
#     },
#     {
#         "id": "book2",
#         "bookid": 2,
#         "imageurl": "https://example.com/book2.jpg",
#         "name": "Machine Learning Basics",
#         "author": "Jane Doe",
#         "genre": "Educational",
#         "price": 39.99,
#         "stock": 30,
#         "description": "An introductory guide to the fundamentals of machine learning.",
#         "rating": 4.5
#     },
#     {
#         "id": "book3",
#         "bookid": 3,
#         "imageurl": "https://example.com/book3.jpg",
#         "name": "Deep Learning Advanced",
#         "author": "Alice Johnson",
#         "genre": "Educational",
#         "price": 49.99,
#         "stock": 20,
#         "description": "An advanced textbook on deep learning techniques and applications.",
#         "rating": 4.5
#     },
#     {
#         "id": "book4",
#         "bookid": 4,
#         "imageurl": "https://example.com/book4.jpg",
#         "name": "AI for Everyone",
#         "author": "Michael Brown",
#         "genre": "Educational",
#         "price": 24.99,
#         "stock": 40,
#         "description": "A comprehensive guide to understanding artificial intelligence for non-experts.",
#         "rating": 4.5
#     },
#     {
#         "id": "book5",
#         "bookid": 5,
#         "imageurl": "https://example.com/book5.jpg",
#         "name": "Cooking with AI",
#         "author": "Chef AI",
#         "genre": "Cooking",
#         "price": 34.99,
#         "stock": 25,
#         "description": "Discover how artificial intelligence can revolutionize your kitchen.",
#         "rating": 4.5
#     },
#     {
#         "id": "book6",
#         "bookid": 6,
#         "imageurl": "https://example.com/book6.jpg",
#         "name": "The Art of Cooking",
#         "author": "Gordon Ramsay",
#         "genre": "Cooking",
#         "price": 44.99,
#         "stock": 15,
#         "description": "Master the art of cooking with tips and recipes from a world-renowned chef.",
#         "rating": 4.5
#     },
#     {
#         "id": "book7",
#         "bookid": 7,
#         "imageurl": "https://example.com/book7.jpg",
#         "name": "AI in Healthcare",
#         "author": "Dr. Sarah Lee",
#         "genre": "Educational",
#         "price": 39.99,
#         "stock": 35,
#         "description": "Explore the impact of artificial intelligence on the healthcare industry.",
#         "rating": 4.5
#     },
#     {
#         "id": "book8",
#         "bookid": 8,
#         "imageurl": "https://example.com/book8.jpg",
#         "name": "AI and Ethics",
#         "author": "Emily White",
#         "genre": "Educational",
#         "price": 29.99,
#         "stock": 45,
#         "description": "A deep dive into the ethical considerations surrounding artificial intelligence.",
#         "rating": 4.5
#     }
# ]

# dummy_users = [
#     {
#         "uid": "user1",
#         "username": "testuser",
#         "email": "test@example.com",
#         "phone": "1234567890",
#         "searchPrompts": ["python programming", "AI books"],
#         "wishlist": [1, 3],
#         "cartItems": [{"bookId": "book1", "quantity": 1}],
#         "orders": ["order1", "order2"],
#         "boughtBooks": [2, 3],
#         "balance": 100.0
#     },
#     {
#         "uid": "user2",
#         "username": "anotheruser",
#         "email": "another@example.com",
#         "phone": "0987654321",
#         "searchPrompts": ["machine learning", "data science"],
#         "wishlist": [2],
#         "cartItems": [{"bookId": "book2", "quantity": 2}],
#         "orders": ["order3"],
#         "boughtBooks": [1],
#         "balance": 150.0
#     }
# ]

# dummy_orders = [
#     {
#         "orderId": "order1",
#         "userId": "user1",
#         "items": [{"bookId": "book1", "quantity": 1}],
#         "total": 29.99,
#         "status": "completed",
#         "name": "Test User",
#         "phonenumber": "1234567890",
#         "address": "123 Test St"
#     },
#     {
#         "orderId": "order2",
#         "userId": "user1",
#         "items": [{"bookId": "book3", "quantity": 1}],
#         "total": 49.99,
#         "status": "completed",
#         "name": "Test User",
#         "phonenumber": "1234567890",
#         "address": "123 Test St"
#     },
# ]

# # Example usage
# user = dummy_users[0]  # Get the first user from dummy_users
# user_orders = dummy_orders  # Pass the list of orders
# recommended_books = book_recommender(user, user_orders)
# print(recommended_books)