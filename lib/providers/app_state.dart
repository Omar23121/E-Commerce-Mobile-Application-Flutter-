import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import '../models/user_profile.dart';
import '../models/review.dart';
import '../models/order.dart';
import '../models/payment_card.dart';
import '../models/address.dart';

class AppState extends ChangeNotifier {

  // ================= PRODUCTS =================

  List<Product> products = [];

  void loadProducts() {
    products = [
      Product("Sneakers", "Comfortable running shoes", 79.99, "assets/images/sneakers.jpg"),
      Product("Leather Jacket", "Stylish and durable", 199.99, "assets/images/jacket.jpg"),
      Product("Smart Watch", "Track fitness and more", 149.99, "assets/images/watch.jpg"),
      Product("Wireless Headphones", "Noise cancelling", 89.99, "assets/images/headphones.jpg"),
      Product("Backpack", "Lightweight travel bag", 59.99, "assets/images/backpack.jpg"),
      Product("Sunglasses", "UV protective stylish eyewear", 29.99, "assets/images/sunglasses.jpg"),
    ];
  }

  // ================= USER =================

  UserProfile? user;

  String? get _userKey => user?.username;

  Future<void> loadProfile(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('user_$username');

    if (jsonStr != null) {
      user = UserProfile.fromJson(jsonDecode(jsonStr));
      notifyListeners();
    }
  }

  Future<void> saveProfile(String username, String password) async {
    user = UserProfile(username, password);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'user_$username',
      jsonEncode(user!.toJson()),
    );

    notifyListeners();
  }

  Future<bool> validateLogin(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('user_$username');

    if (jsonStr == null) return false;

    final storedUser =
    UserProfile.fromJson(jsonDecode(jsonStr));

    if (storedUser.password != password) return false;

    user = storedUser;

    await loadUserData();

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    user = null;
    orders.clear();
    savedCards.clear();
    savedAddresses.clear();
    cart.clear(); // 🔥 clear cart too
    notifyListeners();
  }

  // ================= CART =================

  Map<Product, int> cart = {};

  void addToCart(Product p) {
    cart.update(p, (qty) => qty + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  void removeFromCart(Product p) {
    if (!cart.containsKey(p)) return;

    if (cart[p]! > 1) {
      cart[p] = cart[p]! - 1;
    } else {
      cart.remove(p);
    }

    notifyListeners();
  }

  void clearCart() {
    cart.clear();
    notifyListeners();
  }

  double get total =>
      cart.entries.fold(0, (sum, e) => sum + e.key.price * e.value);

  int get cartItemCount =>
      cart.values.fold(0, (sum, qty) => sum + qty);

  // 🔥 THESE WERE MISSING — UI NEEDS THEM
  bool isInCart(Product p) => cart.containsKey(p);

  int quantityOf(Product p) => cart[p] ?? 0;

  // ================= REVIEWS =================

  Map<String, List<Review>> reviews = {};

  void addReview(String productName, Review review) {
    reviews.putIfAbsent(productName, () => []);
    reviews[productName]!.add(review);
    notifyListeners();
  }

  // ================= ORDERS =================

  List<Order> orders = [];
  Order? activeOrder;

  Future<void> loadOrders() async {
    if (_userKey == null) return;

    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('orders_${_userKey!}');

    if (jsonStr != null) {
      final decoded = jsonDecode(jsonStr) as List;
      orders = decoded.map((e) => Order.fromJson(e)).toList();
      if (orders.isNotEmpty) activeOrder = orders.last;
    }
  }

  Future<void> saveOrders() async {
    if (_userKey == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'orders_${_userKey!}',
      jsonEncode(
        orders.map((o) => o.toJson()).toList(),
      ),
    );
  }

  Future<void> createOrderFromCart() async {
    if (cart.isEmpty || _userKey == null) return;

    final newOrder = Order(
      'ORD-${DateTime.now().millisecondsSinceEpoch}',
      total,
      DateTime.now().add(const Duration(days: 3)),
      DateTime.now(),
    );

    orders.add(newOrder);
    activeOrder = newOrder;

    await saveOrders();
    clearCart();
    notifyListeners();
  }

  // ✅ NEW: DELETE ORDER (for Order History delete button)
  Future<void> deleteOrder(Order order) async {
    orders.removeWhere((o) => o.id == order.id);

    // if you deleted the active order, update activeOrder
    if (activeOrder?.id == order.id) {
      activeOrder = orders.isNotEmpty ? orders.last : null;
    }

    await saveOrders();
    notifyListeners();
  }

  // ================= PAYMENT CARDS =================

  List<PaymentCard> savedCards = [];

  Future<void> loadCards() async {
    if (_userKey == null) return;

    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('cards_${_userKey!}');

    if (jsonStr != null) {
      final decoded = jsonDecode(jsonStr) as List;
      savedCards =
          decoded.map((e) => PaymentCard.fromJson(e)).toList();
    }
  }

  Future<void> saveCards() async {
    if (_userKey == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'cards_${_userKey!}',
      jsonEncode(
        savedCards.map((c) => c.toJson()).toList(),
      ),
    );
  }

  Future<void> addCard(PaymentCard card) async {
    savedCards.add(card);
    await saveCards();
    notifyListeners();
  }

  Future<void> removeCard(PaymentCard card) async {
    savedCards.remove(card);
    await saveCards();
    notifyListeners();
  }

  // ================= ADDRESSES =================

  List<Address> savedAddresses = [];

  Future<void> loadAddresses() async {
    if (_userKey == null) return;

    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('addresses_${_userKey!}');

    if (jsonStr != null) {
      final decoded = jsonDecode(jsonStr) as List;
      savedAddresses =
          decoded.map((e) => Address.fromJson(e)).toList();
    }
  }

  Future<void> saveAddresses() async {
    if (_userKey == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'addresses_${_userKey!}',
      jsonEncode(
        savedAddresses.map((a) => a.toJson()).toList(),
      ),
    );
  }

  Future<void> addAddress(Address address) async {
    savedAddresses.add(address);
    await saveAddresses();
    notifyListeners();
  }

  Future<void> removeAddress(Address address) async {
    savedAddresses.remove(address);
    await saveAddresses();
    notifyListeners();
  }

  // ================= LOAD USER DATA =================

  Future<void> loadUserData() async {
    await loadOrders();
    await loadCards();
    await loadAddresses();
  }

  // ================= CONSTRUCTOR =================

  AppState() {
    loadProducts();
  }
}