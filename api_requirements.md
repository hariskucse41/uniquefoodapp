# API Design for Dynamic App

## **1. Authentication (Existing)**
- **Login POST** `/api/Auth/login`
  - Body: `{ "email": "string", "password": "string" }`
  - Response: `{ "token": "jwt_token", "user": { "id": "uuid", "name": "string", "email": "string", "avatarUrl": "string" } }`
- **Register POST** `/api/Auth/register`
  - Body: `{ "fullName": "string", "email": "string", "password": "string" }`

## **2. User Profile**
- **Get Profile GET** `/api/User/profile`
  - Headers: `Authorization: Bearer {token}`
  - Response:
    ```json
    {
      "id": "uuid",
      "fullName": "John Doe",
      "email": "john@example.com",
      "avatarUrl": "https://...",
      "stats": {
        "ordersCount": 12,
        "favoritesCount": 4,
        "totalSpent": 142.50
      }
    }
    ```
- **Update Profile PUT** `/api/User/profile`
  - Body: `{ "fullName": "string", "avatarUrl": "string" }`

## **3. Home Page Data**
- **Hero Banners GET** `/api/Promotions/hero`
  - Response:
    ```json
    [
      {
        "id": 1,
        "title": "Get 30% Off",
        "subtitle": "On your first order!",
        "actionText": "Order Now",
        "backgroundColor": "#667EEA", // Hex color
        "imageUrl": "https://..."
      }
    ]
    ```
- **Categories GET** `/api/Categories`
  - Response:
    ```json
    [
      {
        "id": 1,
        "name": "Pizza",
        "iconName": "local_pizza", // Or image url
        "color": "#FF6B35"
      }
    ]
    ```
- **Special Offers GET** `/api/Promotions/special`
  - Response:
    ```json
    [
      {
        "id": 1,
        "title": "Family Combo",
        "subtitle": "Up to 4 people",
        "price": 29.99,
        "currency": "$",
        "color": "#E94560"
      }
    ]
    ```

## **4. Products (Menu & Lists)**
- **Get Products GET** `/api/Products`
  - Query Params:
    - `categoryId={id}` (Filter by cat)
    - `isPopular=true` (For Home Page Popular section)
    - `isRecommended=true` (For Home Page Recommended section)
    - `search={query}` (For Search bar)
  - Response:
    ```json
    [
      {
        "id": 101,
        "name": "Margherita Pizza",
        "description": "Classic Italian pizza...",
        "price": 12.99,
        "rating": 4.8,
        "prepTime": "25 min",
        "imageUrl": "https://...",
        "categoryId": 1
      }
    ]
    ```

## **5. Order Management**
- **Get Orders GET** `/api/Orders`
  - Query Params: `status={active|completed|cancelled}`
  - Response:
    ```json
    [
      {
        "id": "ORD-1024",
        "status": "Preparing", // Enums: Pending, Preparing, OutForDelivery, Delivered, Cancelled
        "totalAmount": 38.96,
        "orderDate": "2024-02-20T10:30:00Z",
        "items": [
          { "productName": "Margherita Pizza", "quantity": 1, "price": 12.99 }
        ]
      }
    ]
    ```
- **Create Order POST** `/api/Orders`
  - Body:
    ```json
    {
      "items": [
        { "productId": 101, "quantity": 2 }
      ],
      "paymentMethodId": "..."
    }
    ```
