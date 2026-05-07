from pymongo import MongoClient
from datetime import datetime
import os

# MongoDB Connection
MONGODB_URI = os.getenv("MONGODB_URI", "mongodb+srv://mufaddalabbaskanchwala99_db_user:Y87BEVtviIx5ZPGj@cluster0.bprreem.mongodb.net/?appName=Cluster0")

try:
    client = MongoClient(MONGODB_URI, serverSelectionTimeoutMS=5000)
    # Test connection
    client.admin.command('ping')
    db = client["veridian"]
    print("✓ MongoDB connected successfully")
except Exception as e:
    print(f"✗ MongoDB connection failed: {e}")
    db = None
    client = None

# Collections
if db:
    users = db["users"]
    products = db["products"]
    cart = db["cart"]
    orders = db["orders"]
    order_items = db["order_items"]
    
    # Create indexes for better performance
    try:
        users.create_index("email", unique=True)
        users.create_index("username", unique=True)
        products.create_index("name")
        cart.create_index([("user_id", 1), ("product_id", 1)])
        orders.create_index("user_id")
        order_items.create_index("order_id")
        print("✓ Indexes created")
    except Exception as e:
        print(f"Warning: Could not create indexes: {e}")
else:
    users = None
    products = None
    cart = None
    orders = None
    order_items = None