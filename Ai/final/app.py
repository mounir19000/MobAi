from fastapi import FastAPI
from pydantic import BaseModel
from search import chain  # Importing the AI processing pipeline
from typing import List, Dict
from recommend import book_recommender

class User(BaseModel):
    uid: str
    searchPrompts: List[str]
    wishlist: List[int]
    boughtBooks: List[int]

class OrderItem(BaseModel):
    bookId: str
    quantity: int

class Order(BaseModel):
    orderId: str
    userId: str
    items: List[OrderItem]
    total: float
    status: str
    name: str
    phonenumber: str
    address: str

class RecommendRequest(BaseModel):
    user: User
    user_orders: List[Order]

# Initialize FastAPI app
app = FastAPI()

@app.post("/search")
async def handle_query(prompt: str):
    """Single endpoint for book search or purchase"""
    response = chain.invoke({"prompt": prompt})
    return response

@app.post("/recommend")
async def get_recommendations(request: RecommendRequest):
    """Returns book recommendations based on the user and their order history"""
    print(request)
    recommendations = book_recommender(request.user.dict(), [order.dict() for order in request.user_orders])
    return recommendations

# Run with: uvicorn app:app --reload
