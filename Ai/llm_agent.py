from dotenv import load_dotenv
from langchain import hub
from langchain.agents import (
    AgentExecutor,
    create_react_agent,
)
from langchain_core.tools import Tool
from langchain_google_genai import ChatGoogleGenerativeAI
import os

import faiss
import numpy as np
from sentence_transformers import SentenceTransformer

import faiss
import pickle

load_dotenv()
llm = ChatGoogleGenerativeAI(
    model=os.getenv("GENAI_MODEL", "gemini-1.5-flash"),
    max_tokens=int(os.getenv("GENAI_MAX_TOKENS", 1024)),
    timeout=int(os.getenv("GENAI_TIMEOUT", 60)),
    max_retries=int(os.getenv("GENAI_MAX_RETRIES", 5)),
)

# Initialize SentenceTransformer
embedding_model = SentenceTransformer("all-MiniLM-L6-v2")

# FAISS-related setup
book_ids = []
book_vectors = []
faiss_index = None

# Dummy data (keeping the original data structures)
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
    """
    Initialize FAISS index with book data using chunked text.
    """
    global book_ids, book_vectors, faiss_index
    max_chunk_size = 1000  # Maximum number of characters per chunk
    overlap = 200  # Number of overlapping characters between chunks

    def chunk_text(text, max_size, overlap_size):
        """Split text into smaller overlapping chunks."""
        chunks = []
        for i in range(0, len(text), max_size - overlap_size):
            chunks.append(text[i : i + max_size])
        return chunks

    # Preprocess book data to create embeddings
    for book in dummy_books:
        text = f"Book name: {book['name']}, Book author: {book['author']}, Book genre: {book['genre']}, Book rating : {book['rating']}, Book description: {book["description"]}"
        chunks = chunk_text(text, max_chunk_size, overlap)
        
        for chunk in chunks:
            book_ids.append(book["id"])  # Keep track of book IDs
            book_vectors.append(embedding_model.encode(chunk))  # Encode each chunk
    
    book_vectors_np = np.array(book_vectors, dtype="float32")

    # Create FAISS index
    if book_vectors_np.shape[0] > 0:  # Ensure embeddings exist
        dimension = book_vectors_np.shape[1]
        faiss_index = faiss.IndexFlatL2(dimension)
        faiss_index.add(book_vectors_np)
    else:
        raise ValueError("No book embeddings found to initialize FAISS index.")

def save_faiss_data(index, book_ids, book_vectors, index_file="faiss_index.bin", metadata_file="metadata.pkl"):
    """
    Save FAISS index and metadata to files.
    """
    # Save FAISS index to file
    faiss.write_index(index, index_file)
    print(f"FAISS index saved to {index_file}")
    
    # Save metadata (book_ids and vectors) as a pickle file
    metadata = {"book_ids": book_ids, "book_vectors": book_vectors}
    with open(metadata_file, "wb") as f:
        pickle.dump(metadata, f)
    print(f"Metadata saved to {metadata_file}")

def load_faiss_data(index_file="faiss_index.bin", metadata_file="metadata.pkl"):
    """
    Load FAISS index and metadata from files.
    """
    global faiss_index, book_ids, book_vectors
    
    # Load FAISS index
    faiss_index = faiss.read_index(index_file)
    print(f"FAISS index loaded from {index_file}")
    
    # Load metadata (book_ids and vectors)
    with open(metadata_file, "rb") as f:
        metadata = pickle.load(f)
        book_ids = metadata["book_ids"]
        book_vectors = metadata["book_vectors"]
    print(f"Metadata loaded from {metadata_file}")


def search_books(query):
    """
    Search for books based on the given query.
    """
    global faiss_index, book_vectors, book_ids, dummy_books
    if not faiss_index or not book_vectors:
        return "FAISS index not initialized."

    # Generate the embedding for the query
    query_vector = embedding_model.encode(query).reshape(1, -1)
    distances, indices = faiss_index.search(query_vector, 5)  # Top 5 results

    # Build response
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
    return results

def get_recommendations(user_id):
    pass

def process_purchase(user_id, book_id):
    pass

def get_current_time(*args, **kwargs):
    """Returns the current time in H:MM AM/PM format."""
    import datetime

    now = datetime.datetime.now()  # Get current time
    
    return "Current time is: " + now.strftime("%I:%M %p")

# Initialize FAISS index
initialize_faiss(dummy_books)
save_faiss_data(faiss_index, book_ids, book_vectors)

# load_faiss_data()

tools = [
    Tool(
        name="SearchBooks",
        func=search_books,
        description="Search for books based on title, author, or genre"
    ),
    Tool(
        name="GetRecommendations",
        func=get_recommendations,
        description="Get personalized book recommendations based on user history"
    ),
    Tool(
        name="ProcessPurchase",
        func=process_purchase,
        description="Process a book purchase and get user's default information"
    ),
    Tool(
        name="Time",  # Name of the tool
        func=get_current_time,  # Function that the tool will execute
        # Description of the tool
        description="Useful for when you need to know the current time",
    )
]

agent = create_react_agent(
    llm=llm,
    tools=tools,
    prompt=hub.pull("hwchase17/react"),
    stop_sequence=True,
)

agent_executor = AgentExecutor.from_agent_and_tools(
    agent=agent,
    tools=tools,
    verbose=True,
)

# Run the agent with a test query
response = agent_executor.invoke({"input": "I want to learn about artificial intelligence"})
print("response:", response)