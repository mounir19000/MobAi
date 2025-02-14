import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String apiUrl = "test/getUserOrderDetails";
  //  Place an Order
  Future<String> placeOrder({
    required String userId,
    required String name,
    required String phone,
    required String address,
    required List<Map<String, dynamic>> cartItems,
    required double total,
  }) async {
    if (cartItems.isEmpty) return "Cart is empty";

    DocumentReference userRef = _firestore.collection('users').doc(userId);
    DocumentSnapshot userDoc = await userRef.get();

    if (!userDoc.exists) return "User not found";

    double userBalance = userDoc.get('balance') ?? 200.0;

    if (userBalance < total) return "Insufficient balance"; // 🔹 Prevent purchase if balance is low

    String orderId = _firestore.collection('orders').doc().id; // Generate unique order ID

    await _firestore.collection('orders').doc(orderId).set({
      'orderId': orderId,
      'userId': userId,
      'name': name,
      'phone': phone,
      'address': address,
      'items': cartItems,  // [{bookId: "123", quantity: 2}]
      'total': total,
      'status': 'Pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    List boughtBooks = userDoc.get('boughtBooks') ?? [];
    List<String> newBoughtBooks = cartItems.map((item) => item['bookId'] as String).toList();
    for (String bookId in newBoughtBooks) {
      if (!boughtBooks.contains(bookId)) {
        boughtBooks.add(bookId);
      }
    }
    await userRef.update({
      'balance': userBalance - total,
      'cartItems': [],
      'boughtBooks': boughtBooks, // ✅ Save updated boughtBooks list
    });

    return "Order placed successfully";
  }

  //  Fetch Orders for a User
  Stream<List<Map<String, dynamic>>> getUserOrders(String userId) {
    return _firestore.collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  //  Update Order Status
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestore.collection('orders').doc(orderId).update({'status': status});
  }
  Future<Map<String, dynamic>?> fetchUserOrderDetails(List<Map<String, dynamic>> orders ) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"orders": orders}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);  //  Expected response: { "name": "...", "phone": "...", "address": "..." }
      } else {

        return null;
      }
    } catch (e) {

      return null;
    }
  }

}
