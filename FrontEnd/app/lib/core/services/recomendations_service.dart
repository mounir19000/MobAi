import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class RecommendationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String apiUrl = "test/getRecommendations"; //


  Future<List<Map<String, dynamic>>> getRecommendedBooks(String userId) async {
    try {

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return [];

      List<String> searchPrompts = List<String>.from(userDoc.get('searchPrompts') ?? []);
      List<String> orderHistory = List<String>.from(userDoc.get('orders') ?? []);


      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "searchPrompts": searchPrompts,
          "orderHistory": orderHistory,
        }),
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));  // Expected response: [{bookId: "...", name: "...", author: "..."}]
      } else {

        return [];
      }
    } catch (e) {

      return [];
    }
  }
}
