# Flutter E-Commerce Mobile App

A full-featured e-commerce mobile application built using Flutter. Developed as part of a university-level software engineering course, this project simulates a real-world shopping platform with authentication, cart management, checkout validation, order tracking, and persistent user data storage.

---

## Overview

This project demonstrates how to build a scalable, multi-screen mobile shopping application using Flutter and Provider for state management.

The application simulates a real-world online shopping experience and includes:

- User authentication
- Product browsing
- Cart management
- Address selection before checkout
- Payment handling
- Order tracking
- Persistent user data storage

The architecture was designed to reflect production-level organization and clean UI separation similar to commercial e-commerce apps.

---

## Features

### User Authentication
- Account registration and login
- Persistent user session
- Profile update functionality

### Product Catalog
- Grid-based product listing
- Detailed product pages
- Add-to-cart functionality
- Product review system

### Shopping Cart
- Add and remove items
- Quantity adjustment controls
- Real-time total calculation
- Cart badge counter

### Checkout Flow
- Required address selection before payment
- Dedicated address management screen
- Dedicated payment methods screen
- Order confirmation screen displaying:
  - Generated Order ID
  - Order placement time
  - Estimated delivery date

### Order Management
- Order history page
- Ability to delete previous orders
- Active order tracking with delivery progress indicator

### Profile Management
- Update username and password
- Manage saved addresses (separate screen)
- Manage saved payment methods (separate screen)
- Logout functionality

---

## State Management

This application uses Provider for centralized state management.

Managed states include:

- Products
- Cart
- User session
- Orders
- Saved addresses
- Saved payment methods
- Reviews

UI components reactively update whenever state changes.

---

## Data Persistence

The application uses SharedPreferences to persist user-specific data locally.

Stored data includes:

- User accounts
- Orders
- Saved addresses
- Saved payment methods

Data remains available across app sessions without requiring backend integration.

---

## Project Structure

lib/
│
├── models/
├── providers/
├── screens/
└── widgets/

The project follows separation of concerns to keep business logic outside UI components.

---

## Technologies Used

- Flutter
- Dart
- Provider (State Management)
- SharedPreferences (Local Storage)
- Material Design

---

## How to Run

1. Clone the repository
2. Run:

flutter clean  
flutter pub get  
flutter run  

Make sure you have Flutter SDK installed and an emulator or physical device connected.

---

## Future Improvements

- Firebase backend integration
- Secure authentication
- Real payment gateway integration
- Product search and filtering
- Dark mode support
- Cloud database integration
- Push notifications

---

## Authors

- Omar Almahmoud – Lead Development, Architecture, State Management
- Marjuk Abulkalam – Feature Implementation & UI Enhancements
