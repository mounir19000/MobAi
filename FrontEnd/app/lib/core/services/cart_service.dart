import 'package:cloud_firestore/cloud_firestore.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //  Add Book to Cart ( update quantity if exists)
  Future<void> addToCart(String userId, int bookId, int quantity) async {
    DocumentReference userRef = _firestore.collection('users').doc(userId);
    DocumentSnapshot userDoc = await userRef.get();

    if (userDoc.exists) {
      List cartItems = userDoc.get('cartItems') ?? [];

      // Check if book is already in the cart
      int index = cartItems.indexWhere((item) => item['bookId'] == bookId);
      if (index != -1) {
        cartItems[index]['quantity'] += quantity;
      } else {
        cartItems.add({'bookId': bookId, 'quantity': quantity});
      }

      await userRef.update({'cartItems': cartItems});
    }
  }

  //  Remove Book from Cart
  Future<void> removeFromCart(String userId, int bookId) async {
    DocumentReference userRef = _firestore.collection('users').doc(userId);
    DocumentSnapshot userDoc = await userRef.get();

    if (userDoc.exists) {
      List cartItems = userDoc.get('cartItems') ?? [];
      cartItems.removeWhere((item) => item['bookId'] == bookId);

      await userRef.update({'cartItems': cartItems});
    }
  }
  Future<void> clearCart(String userId) async {
    await _firestore.collection('users').doc(userId).update({'cartItems': []});
  }
}