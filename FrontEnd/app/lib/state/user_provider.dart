import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../core/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthService _authService = AuthService();

  UserModel? get user => _user;

  /// Load user from SharedPreferences when the app starts
  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');

    if (userData != null) {
      _user = UserModel.fromJson(jsonDecode(userData));
    } else {
      _user = await _authService.getCurrentUser();
      if (_user != null) {
        await saveUserToLocal();
      }
    }

    notifyListeners();
  }

  /// Save user info to SharedPreferences
  Future<void> saveUserToLocal() async {
    if (_user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(_user!.toJson()));
    }
  }

  /// Set user and save data locally
  void setUser(UserModel newUser) {
    _user = newUser;
    saveUserToLocal();
    notifyListeners();
  }

  /// Update balance and save changes
  void updateBalance(double amount) {
    if (_user != null) {
      _user!.balance += amount;
      saveUserToLocal();
      notifyListeners();
    }
  }

  /// Add book to wishlist and save
  void addToWishlist(int bookId) {
    if (_user != null && !_user!.wishlist.contains(bookId)) {
      _user!.wishlist.add(bookId);
      saveUserToLocal();
      notifyListeners();
    }
  }

  /// Remove book from wishlist and save
  void removeFromWishlist(int bookId) {
    if (_user != null) {
      _user!.wishlist.remove(bookId);
      saveUserToLocal();
      notifyListeners();
    }
  }

  /// Add item to cart and save
  void addToCart(Map<String, dynamic> book) {
    if (_user != null) {
      _user!.cartItems.add(book);
      saveUserToLocal();
      notifyListeners();
    }
  }

  /// Remove item from cart and save
  void removeFromCart(int index) {
    if (_user != null) {
      _user!.cartItems.removeAt(index);
      saveUserToLocal();
      notifyListeners();
    }
  }

  /// Complete purchase and save
  void completePurchase() {
    if (_user != null) {
      _user!.boughtBooks.addAll(
          _user!.cartItems.map((book) => book['bookId'] as int).toList());
      _user!.cartItems.clear();
      saveUserToLocal();
      notifyListeners();
    }
  }

  /// Logout and clear data
  Future<void> logout() async {
    _user = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    notifyListeners();
  }
}
