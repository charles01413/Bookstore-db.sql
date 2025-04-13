# BookStore Database Project - MySQL Implementation


## Step 1: Creating the Database

CREATE DATABASE bookstore;
USE bookstore;


## Step 2: Designing and Creating Tables
    
-- Create book_language table
CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_code VARCHAR(8) NOT NULL,
    language_name VARCHAR(50) NOT NULL
);

-- Create publisher table
CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(100) NOT NULL
);

-- Create author table
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL
);

-- Create book table
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    num_pages INT,
    publication_date DATE,
    language_id INT,
    publisher_id INT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    FOREIGN KEY (language_id) REFERENCES book_language(language_id),
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)
);

-- Create book_author table (many-to-many relationship)
CREATE TABLE book_author (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- Create country table
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

-- Create address table
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street_number VARCHAR(10) NOT NULL,
    street_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20) NOT NULL,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

-- Create address_status table
CREATE TABLE address_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    address_status VARCHAR(20) NOT NULL
);

-- Create customer table
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    registration_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create customer_address table
CREATE TABLE customer_address (
    customer_id INT NOT NULL,
    address_id INT NOT NULL,
    status_id INT NOT NULL,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);

-- Create shipping_method table
CREATE TABLE shipping_method (
    method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100) NOT NULL,
    cost DECIMAL(10, 2) NOT NULL
);

-- Create order_status table
CREATE TABLE order_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_value VARCHAR(20) NOT NULL
);

-- Create cust_order table
CREATE TABLE cust_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    customer_id INT NOT NULL,
    shipping_method_id INT NOT NULL,
    dest_address_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(method_id),
    FOREIGN KEY (dest_address_id) REFERENCES address(address_id)
);

-- Create order_line table
CREATE TABLE order_line (
    line_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- Create order_history table
CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    status_id INT NOT NULL,
    status_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);


## Step 3: Setting Up User Groups and Roles

-- Create database users with appropriate privileges
CREATE USER 'bookstore_admin'@'localhost' IDENTIFIED BY 'admin_password';
GRANT ALL PRIVILEGES ON bookstore.* TO 'bookstore_admin'@'localhost';

CREATE USER 'bookstore_manager'@'localhost' IDENTIFIED BY 'manager_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON bookstore.* TO 'bookstore_manager'@'localhost';

CREATE USER 'bookstore_staff'@'localhost' IDENTIFIED BY 'staff_password';
GRANT SELECT, INSERT, UPDATE ON bookstore.book TO 'bookstore_staff'@'localhost';
GRANT SELECT, INSERT, UPDATE ON bookstore.author TO 'bookstore_staff'@'localhost';
GRANT SELECT, INSERT, UPDATE ON bookstore.book_author TO 'bookstore_staff'@'localhost';
GRANT SELECT, INSERT, UPDATE ON bookstore.customer TO 'bookstore_staff'@'localhost';
GRANT SELECT, INSERT, UPDATE ON bookstore.cust_order TO 'bookstore_staff'@'localhost';
GRANT SELECT, INSERT, UPDATE ON bookstore.order_line TO 'bookstore_staff'@'localhost';

CREATE USER 'bookstore_report'@'localhost' IDENTIFIED BY 'report_password';
GRANT SELECT ON bookstore.* TO 'bookstore_report'@'localhost';

FLUSH PRIVILEGES;


## Step 4: Sample Data Insertion

-- Insert sample data into book_language
INSERT INTO book_language (language_code, language_name) VALUES
('en', 'English'),
('es', 'Spanish'),
('fr', 'French'),
('de', 'German');

-- Insert sample data into publisher
INSERT INTO publisher (publisher_name) VALUES
('Penguin Random House'),
('HarperCollins'),
('Simon & Schuster'),
('Macmillan');

-- Insert sample data into author
INSERT INTO author (author_name) VALUES
('J.K. Rowling'),
('George R.R. Martin'),
('Stephen King'),
('Agatha Christie');

-- Insert sample data into book
INSERT INTO book (title, isbn, num_pages, publication_date, language_id, publisher_id, price, stock_quantity) VALUES
('Harry Potter and the Philosopher''s Stone', '9780747532743', 223, '1997-06-26', 1, 1, 12.99, 50),
('A Game of Thrones', '9780553103540', 694, '1996-08-01', 1, 2, 15.99, 30),
('The Shining', '9780307743657', 447, '1977-01-28', 1, 3, 9.99, 25),
('Murder on the Orient Express', '9780062073495', 256, '1934-01-01', 1, 4, 8.99, 40);

-- Insert sample data into book_author
INSERT INTO book_author (book_id, author_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- Insert sample data into country
INSERT INTO country (country_name) VALUES
('United States'),
('United Kingdom'),
('Canada'),
('Australia');

-- Insert sample data into address_status
INSERT INTO address_status (address_status) VALUES
('Current'),
('Previous'),
('Billing'),
('Shipping');

-- Insert sample data into address
INSERT INTO address (street_number, street_name, city, state, postal_code, country_id) VALUES
('123', 'Main St', 'New York', 'NY', '10001', 1),
('456', 'Oak Ave', 'London', NULL, 'SW1A 1AA', 2),
('789', 'Maple Rd', 'Toronto', 'ON', 'M5V 2H1', 3),
('101', 'Pine Blvd', 'Sydney', 'NSW', '2000', 4);

-- Insert sample data into customer
INSERT INTO customer (first_name, last_name, email, phone, password_hash) VALUES
('John', 'Doe', 'john.doe@example.com', '555-123-4567', SHA2('password123', 256)),
('Jane', 'Smith', 'jane.smith@example.com', '555-987-6543', SHA2('securepass', 256));

-- Insert sample data into customer_address
INSERT INTO customer_address (customer_id, address_id, status_id) VALUES
(1, 1, 1),
(1, 2, 3),
(2, 3, 1),
(2, 4, 4);

-- Insert sample data into shipping_method
INSERT INTO shipping_method (method_name, cost) VALUES
('Standard Shipping', 4.99),
('Express Shipping', 9.99),
('Overnight Shipping', 19.99);

-- Insert sample data into order_status
INSERT INTO order_status (status_value) VALUES
('Pending'),
('Processing'),
('Shipped'),
('Delivered'),
('Cancelled');

-- Insert sample data into cust_order
INSERT INTO cust_order (customer_id, shipping_method_id, dest_address_id) VALUES
(1, 1, 1),
(2, 2, 3);

-- Insert sample data into order_line
INSERT INTO order_line (order_id, book_id, price, quantity) VALUES
(1, 1, 12.99, 1),
(1, 3, 9.99, 2),
(2, 2, 15.99, 1),
(2, 4, 8.99, 1);

-- Insert sample data into order_history
INSERT INTO order_history (order_id, status_id) VALUES
(1, 1),
(1, 2),
(2, 1);


## Step 5: Test Queries

-- 1. Get all books with their authors:
SELECT b.title, a.author_name 
FROM book b
JOIN book_author ba ON b.book_id = ba.book_id
JOIN author a ON ba.author_id = a.author_id;


-- 2. Get customer orders with order details:
SELECT 
    c.first_name, c.last_name, 
    o.order_id, o.order_date,
    b.title, ol.quantity, ol.price,
    (ol.quantity * ol.price) AS line_total
FROM customer c
JOIN cust_order o ON c.customer_id = o.customer_id
JOIN order_line ol ON o.order_id = ol.order_id
JOIN book b ON ol.book_id = b.book_id;


-- 3. Get inventory report:
SELECT 
    b.title, 
    b.stock_quantity,
    b.price,
    (b.stock_quantity * b.price) AS inventory_value
FROM book b
ORDER BY inventory_value DESC;


-- 4. Get order status history:
SELECT 
    o.order_id, 
    c.first_name, c.last_name,
    os.status_value, 
    oh.status_date
FROM cust_order o
JOIN customer c ON o.customer_id = c.customer_id
JOIN order_history oh ON o.order_id = oh.order_id
JOIN order_status os ON oh.status_id = os.status_id
ORDER BY o.order_id, oh.status_date;
