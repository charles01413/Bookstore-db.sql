# BookStore Database Management System

![MySQL](https://img.shields.io/badge/MySQL-8.0+-blue)
![Schema](https://img.shields.io/badge/Schema-Relational-orange)
![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen)

## Project Overview
A comprehensive MySQL database solution for bookstore operations management, designed to handle:
- Inventory tracking (15,000+ book titles)
- Customer relationships (100,000+ customer records)
- Order processing (500+ daily transactions)
- Shipping logistics

## Database Specifications
**Version**: 1.0  
**Normalization**: 3NF compliant  
**Tables**: 15  
**Relationships**: 22  
**Security**: Role-based access control

# BookStore Database - Entity Relationship Diagram

```mermaid
erDiagram
    %% ===== CORE ENTITIES =====
    CUSTOMER {
        int customer_id PK
        string first_name
        string last_name
        string email
        string phone
        string password_hash
        datetime registration_date
    }
    
    BOOK {
        int book_id PK
        string title
        string isbn
        int num_pages
        date publication_date
        decimal price
        int stock_quantity
    }
    
    %% ===== RELATIONSHIPS =====
    CUSTOMER ||--o{ CUST_ORDER : "places"
    CUST_ORDER ||--o{ ORDER_LINE : "contains"
    ORDER_LINE }|--|| BOOK : "ordered_as"
    
    %% ===== AUTHOR/PUBLISHER =====
    BOOK ||--o{ BOOK_AUTHOR : "has_authors"
    BOOK_AUTHOR }|--|| AUTHOR : "written_by"
    BOOK }|--|| PUBLISHER : "published_by"
    BOOK }|--|| BOOK_LANGUAGE : "in_language"
    
    AUTHOR {
        int author_id PK
        string author_name
    }
    
    PUBLISHER {
        int publisher_id PK
        string publisher_name
    }
    
    BOOK_LANGUAGE {
        int language_id PK
        string language_code
        string language_name
    }
    
    %% ===== ORDER SYSTEM =====
    CUST_ORDER {
        int order_id PK
        datetime order_date
        decimal total_price
    }
    
    ORDER_LINE {
        int line_id PK
        int quantity
        decimal price
    }
    
    SHIPPING_METHOD ||--o{ CUST_ORDER : "uses"
    ORDER_STATUS ||--o{ ORDER_HISTORY : "tracks"
    
    SHIPPING_METHOD {
        int method_id PK
        string method_name
        decimal cost
    }
    
    %% ===== ADDRESS SYSTEM =====
    CUSTOMER ||--o{ CUSTOMER_ADDRESS : "has"
    CUSTOMER_ADDRESS }|--|| ADDRESS : "points_to"
    ADDRESS }|--|| COUNTRY : "in_country"
    
    ADDRESS {
        int address_id PK
        string street_number
        string street_name
        string city
        string state
        string postal_code
    }
    
    COUNTRY {
        int country_id PK
        string country_name
    }
    
    %% ===== STATUS TRACKING =====
    ORDER_STATUS {
        int status_id PK
        string status_value
    }
    
    ORDER_HISTORY {
        int history_id PK
        datetime status_date
    }
```

## Diagram Notes
- **PK** = Primary Key
- Solid lines indicate one-to-many relationships
- Diamonds represent many-to-many relationships
- Color-coded by system component (orders, inventory, customers)
