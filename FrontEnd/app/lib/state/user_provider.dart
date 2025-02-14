import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../core/services/auth_service.dart'; // Assuming AuthService handles user fetching

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthService _authService = AuthService(); // Inject AuthService

  UserModel? get user => _user;

  Future<void> loadUser() async {
    _user = await _authService.getCurrentUser();
    notifyListeners();
  }

  void setUser(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }

  void updateBalance(double amount) {
    if (_user != null) {
      _user!.balance += amount;
      notifyListeners();
    }
  }

  void addToWishlist(int bookId) {
    if (_user != null && !_user!.wishlist.contains(bookId)) {
      _user!.wishlist.add(bookId);
      notifyListeners();
    }
  }

  void removeFromWishlist(int bookId) {
    if (_user != null) {
      _user!.wishlist.remove(bookId);
      notifyListeners();
    }
  }

  void addToCart(Map<String, dynamic> book) {
    if (_user != null) {
      _user!.cartItems.add(book);
      notifyListeners();
    }
  }

  void removeFromCart(int index) {
    if (_user != null) {
      _user!.cartItems.removeAt(index);
      notifyListeners();
    }
  }

  void completePurchase() {
    if (_user != null) {
      _user!.boughtBooks.addAll(
          _user!.cartItems.map((book) => book['bookId'] as int).toList());
      _user!.cartItems.clear();
      notifyListeners();
    }
  }
}
