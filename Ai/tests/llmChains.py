from dotenv import load_dotenv
from langchain.prompts import ChatPromptTemplate
from langchain.schema.output_parser import StrOutputParser
from langchain.schema.runnable import RunnableBranch
from langchain_google_genai import ChatGoogleGenerativeAI
import os
from sentence_transformers import SentenceTransformer
import faiss
import numpy as np
import pickle

load_dotenv()
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

dummy_books = [
    {
        "id": "book1",
        "bookid": 1,
        "imageurl": "https://example.com/book1.jpg",
        "name": "The AI Revolution",
        "author": "John Smith",
        "genre": "Science Fiction",
        "price": 29.99,
        "stock": 50,
        "description": "A thrilling exploration of the future of artificial intelligence.",
        "rating": 4.5
    },
    {
        "id": "book2",
        "bookid": 2,
        "imageurl": "https://example.com/book2.jpg",
        "name": "Machine Learning Basics",
        "author": "Jane Doe",
        "genre": "Educational",
        "price": 39.99,
        "stock": 30,
        "description": "An introductory guide to the fundamentals of machine learning.",
        "rating": 4.5
    },
    {
        "id": "book3",
        "bookid": 3,
        "imageurl": "https://example.com/book3.jpg",
        "name": "Deep Learning Advanced",
        "author": "Alice Johnson",
        "genre": "Educational",
        "price": 49.99,
        "stock": 20,
        "description": "An advanced textbook on deep learning techniques and applications.",
        "rating": 4.5
    },
    {
        "id": "book4",
        "bookid": 4,
        "imageurl": "https://example.com/book4.jpg",
        "name": "AI for Everyone",
        "author": "Michael Brown",
        "genre": "Educational",
        "price": 24.99,
        "stock": 40,
        "description": "A comprehensive guide to understanding artificial intelligence for non-experts.",
        "rating": 4.5
    },
    {
        "id": "book5",
        "bookid": 5,
        "imageurl": "https://example.com/book5.jpg",
        "name": "Cooking with AI",
        "author": "Chef AI",
        "genre": "Cooking",
        "price": 34.99,
        "stock": 25,
        "description": "Discover how artificial intelligence can revolutionize your kitchen.",
        "rating": 4.5
    },
    {
        "id": "book6",
        "bookid": 6,
        "imageurl": "https://example.com/book6.jpg",
        "name": "The Art of Cooking",
        "author": "Gordon Ramsay",
        "genre": "Cooking",
        "price": 44.99,
        "stock": 15,
        "description": "Master the art of cooking with tips and recipes from a world-renowned chef.",
        "rating": 4.5
    },
    {
        "id": "book7",
        "bookid": 7,
        "imageurl": "https://example.com/book7.jpg",
        "name": "AI in Healthcare",
        "author": "Dr. Sarah Lee",
        "genre": "Educational",
        "price": 39.99,
        "stock": 35,
        "description": "Explore the impact of artificial intelligence on the healthcare industry.",
        "rating": 4.5
    },
    {
        "id": "book8",
        "bookid": 8,
        "imageurl": "https://example.com/book8.jpg",
        "name": "AI and Ethics",
        "author": "Emily White",
        "genre": "Educational",
        "price": 29.99,
        "stock": 45,
        "description": "A deep dive into the ethical considerations surrounding artificial intelligence.",
        "rating": 4.5
    }
]

dummy_users = [
    {
        "uid": "user1",
        "username": "testuser",
        "email": "test@example.com",
        "phone": "1234567890",
        "searchPrompts": ["python programming", "AI books"],
        "wishlist": [1, 3],
        "cartItems": [{"bookId": "book1", "quantity": 1}],
        "orders": ["order1", "order2"],
        "boughtBooks": [2, 3],
        "balance": 100.0
    },
    {
        "uid": "user2",
        "username": "anotheruser",
        "email": "another@example.com",
        "phone": "0987654321",
        "searchPrompts": ["machine learning", "data science"],
        "wishlist": [2],
        "cartItems": [{"bookId": "book2", "quantity": 2}],
        "orders": ["order3"],
        "boughtBooks": [1],
        "balance": 150.0
    }
]

dummy_orders = [
    {
        "orderId": "order1",
        "userId": "user1",
        "items": [{"bookId": "book1", "quantity": 1}],
        "total": 29.99,
        "status": "completed",
        "name": "Test User",
        "phonenumber": "1234567890",
        "address": "123 Test St"
    },
    {
        "orderId": "order2",
        "userId": "user1",
        "items": [{"bookId": "book3", "quantity": 1}],
        "total": 49.99,
        "status": "completed",
        "name": "Test User",
        "phonenumber": "1234567890",
        "address": "123 Test St"
    },
    {
        "orderId": "order3",
        "userId": "user2",
        "items": [{"bookId": "book2", "quantity": 2}],
        "total": 79.98,
        "status": "completed",
        "name": "Another User",
        "phonenumber": "0987654321",
        "address": "456 Another St"
    }
]


def initialize_faiss(dummy_books):
    global book_ids, book_vectors, faiss_index
    max_chunk_size = 1000
    overlap = 200

    def chunk_text(text, max_size, overlap_size):
        chunks = []
        for i in range(0, len(text), max_size - overlap_size):
            chunks.append(text[i: i + max_size])
        return chunks

    for book in dummy_books:
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

def save_faiss_data(index, book_ids, book_vectors, index_file="faiss_index.bin", metadata_file="metadata.pkl"):
    faiss.write_index(index, index_file)
    print(f"FAISS index saved to {index_file}")

    metadata = {"book_ids": book_ids, "book_vectors": book_vectors}
    with open(metadata_file, "wb") as f:
        pickle.dump(metadata, f)
    print(f"Metadata saved to {metadata_file}")

def load_faiss_data(index_file="faiss_index.bin", metadata_file="metadata.pkl"):
    global faiss_index, book_ids, book_vectors

    faiss_index = faiss.read_index(index_file)
    print(f"FAISS index loaded from {index_file}")

    with open(metadata_file, "rb") as f:
        metadata = pickle.load(f)
        book_ids = metadata["book_ids"]
        book_vectors = metadata["book_vectors"]
    print(f"Metadata loaded from {metadata_file}")

def search_books(query):
    global faiss_index, book_vectors, book_ids, dummy_books
    if not faiss_index or not book_vectors:
        return "FAISS index not initialized."

    query_vector = embedding_model.encode(query).reshape(1, -1)
    distances, indices = faiss_index.search(query_vector, 5)

    results = []
    for i, idx in enumerate(indices[0]):
        if idx < len(book_ids):
            book_id = book_ids[idx]
            book = next((b for b in dummy_books if b["id"] == book_id), None)
            if book:
                results.append({
                    "book_id": book["id"],
                    "name": book["name"],
                    "author": book["author"],
                    "genre": book["genre"],
                    "distance": distances[0][i]
                })
    finalResult = {
        "results": results,
        "isBuying": False
    }
    return finalResult

def process_purchase(query):
    global faiss_index, book_vectors, book_ids, dummy_books
    if not faiss_index or not book_vectors:
        return {"results": None, "isBuying": True}

    query_vector = embedding_model.encode(query).reshape(1, -1)
    distances, indices = faiss_index.search(query_vector, 1)  # Return only the closest match

    if indices[0][0] < len(book_ids):
        book_id = book_ids[indices[0][0]]
        book = next((b for b in dummy_books if b["id"] == book_id), None)
        if book:
            best_book = {
                "book_id": book["id"],
                "name": book["name"],
                "author": book["author"],
                "genre": book["genre"],
                "price": book["price"],
                "stock": book["stock"],
                "distance": distances[0][0]
            }
            return {"results": best_book, "isBuying": True}
    
    return {"results": None, "isBuying": True}

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


# # Initialize FAISS index
# initialize_faiss(dummy_books)
# save_faiss_data(faiss_index, book_ids, book_vectors)

load_faiss_data()

classification_chain = classification_template | model | StrOutputParser()

chain = classification_chain | branches

# result = chain.invoke({"prompt": "I want to read a book about artificial inteligence"})
result = chain.invoke({"prompt": "Buy me a good book about artificial inteligence"})

# Output the result
print(result)