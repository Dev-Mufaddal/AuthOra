-- ======================================
-- FLASK AUTH DATABASE SETUP
-- ======================================
-- Copy and paste this entire SQL code into MySQL Workbench
-- or run it with: mysql -u root -p < database.sql

-- Create the database
CREATE DATABASE IF NOT EXISTS flask_auth_db;

-- Use the database
USE flask_auth_db;

-- Create users table
-- This table stores all registered user information
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,          -- User ID (auto-incremented)
    username VARCHAR(50) NOT NULL UNIQUE,       -- Username (must be unique)
    email VARCHAR(100) NOT NULL UNIQUE,         -- Email (must be unique)
    password VARCHAR(255) NOT NULL,             -- Password (hashed for security)
    role VARCHAR(20) DEFAULT 'user',            -- User role: 'admin' or 'user'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Registration time
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  -- Last update time
);

-- Create an index on email for faster login queries
CREATE INDEX idx_email ON users(email);

-- Create an index on username for faster lookups
CREATE INDEX idx_username ON users(username);

-- ======================================
-- PRODUCTS TABLE
-- ======================================
-- Stores all product information
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,          -- Product ID
    name VARCHAR(255) NOT NULL,                 -- Product name
    description TEXT,                           -- Product description
    price DECIMAL(10, 2) NOT NULL,             -- Product price
    stock INT DEFAULT 0,                        -- Stock quantity
    image_url VARCHAR(500),                     -- Product image URL (optional)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ======================================
-- CART TABLE
-- ======================================
-- Stores items in user shopping carts (temporary)
CREATE TABLE IF NOT EXISTS cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,                       -- User who owns the cart
    product_id INT NOT NULL,                    -- Product in cart
    quantity INT DEFAULT 1,                     -- How many items
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- ======================================
-- ORDERS TABLE
-- ======================================
-- Stores completed orders
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,                       -- User who placed order
    total_price DECIMAL(10, 2) NOT NULL,       -- Total order price
    status VARCHAR(50) DEFAULT 'pending',      -- Order status: pending, completed, cancelled
    payment_id VARCHAR(255),                    -- Razorpay payment ID for tracking
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ======================================
-- ORDER ITEMS TABLE
-- ======================================
-- Individual items in each order
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,                      -- Which order
    product_id INT NOT NULL,                    -- Which product
    quantity INT NOT NULL,                      -- How many
    price DECIMAL(10, 2) NOT NULL,             -- Price at time of order
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);
DESCRIBE users;
