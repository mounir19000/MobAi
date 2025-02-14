import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../../models/book_model.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String apiUrl = "test/searchBooks";

  Future<dynamic> searchBooks(String userId,String prompt) async {
    try {

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"prompt": prompt}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<BookModel> books = (data["books"] as List)
            .map((book) => BookModel.fromJson(book))
            .toList();
        List<Map<String, dynamic>> booksdata = List<Map<String, dynamic>>.from(data["books"]);
        bool buy = data["buy"];


        await _saveBooksToFirestore(booksdata);

        DocumentReference userRef = _firestore.collection('users').doc(userId);
        DocumentSnapshot userDoc = await userRef.get();

        if (userDoc.exists) {
          List searchPrompts = userDoc.get('searchPrompts') ?? [];

          if (!searchPrompts.contains(prompt)) {
            searchPrompts.add(prompt);
            await userRef.update({'searchPrompts': searchPrompts});
          }
        }

        return {'buy':buy  , 'books':books};
      } else {

        return [];
      }
    } catch (e) {

      return [];
    }
  }

  Future<void> _saveBooksToFirestore(List<Map<String, dynamic>> books) async {
    for (var book in books) {
      int bookId = book["bookId"];
      QuerySnapshot existingBooks = await _firestore
          .collection('books')
          .where('bookId', isEqualTo: bookId)
          .get();
      if (existingBooks.docs.isEmpty) {
        String Id = _firestore.collection('books').doc().id;
        await _firestore.collection('books').doc(Id).set({
              'id':Id,
              'bookId':book["bookId"],
              'imageurl':book["imageurl"],
              'description':book["desciption"],
              'name': book["name"],
              'author': book["author"],
              'genre': book["genre"],
              'price': book["price"],
              'stock': book["stock"],
              });
        }
      }
    }
  }

