import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //  Add Item to Cart (or update quantity if already exists)
  Future<void> addToCart(String userId, String bookId, int quantity) async {
    DocumentReference userRef = _firestore.collection('users').doc(userId);
    DocumentSnapshot userDoc = await userRef.get();

    if (userDoc.exists) {
      List cartItems = userDoc.get('cartItems') ?? [];

      // Check if book is already in the cart
      int index = cartItems.indexWhere((item) => item['bookId'] == bookId);
      if (index != -1) {
        cartItems[index]['quantity'] += quantity;  // ✅ Update quantity
      } else {
        cartItems.add({'bookId': bookId, 'quantity': quantity});
      }

      await userRef.update({'cartItems': cartItems});
    }
  }

  // 🔹 Remove Item from Cart
  Future<void> removeFromCart(String userId, String bookId) async {
    DocumentReference userRef = _firestore.collection('users').doc(userId);
    DocumentSnapshot userDoc = await userRef.get();

    if (userDoc.exists) {
      List cartItems = userDoc.get('cartItems') ?? [];
      cartItems.removeWhere((item) => item['bookId'] == bookId);  // ✅ Remove book from cart

      await userRef.update({'cartItems': cartItems});
    }
  }

  // 🔹 Clear Cart (After Purchase)
  Future<void> clearCart(String userId) async {
    await _firestore.collection('users').doc(userId).update({'cartItems': []});
  }
}
