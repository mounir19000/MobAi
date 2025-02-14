import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/book_model.dart';

class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<BookModel?> getBook(int bookId) async {
    try {
      final query = await _firestore
          .collection('books')
          .where('bookId', isEqualTo: bookId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;
      
      final doc = query.docs.first;
      return BookModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);

    } catch (e) {
      print('Error getting book: $e');
      return null;
    }
  }

  Future<List<BookModel>> getBooksForUser(String userId) async {
    try {
      // Example: Get user's wishlist and fetch those books
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return [];

      final wishlist = List<int>.from(userDoc.get('wishlist') ?? []);
      
      if (wishlist.isEmpty) return [];
      
      final booksQuery = await _firestore
          .collection('books')
          .where('bookId', whereIn: wishlist)
          .get();

      return booksQuery.docs
          .map((doc) => BookModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting user books: $e');
      return [];
    }
  }

  Future<void> addToWishlist(String userId, int bookId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'wishlist': FieldValue.arrayUnion([bookId])
      });
    } catch (e) {
      print('Error adding to wishlist: $e');
      rethrow;
    }
  }

  Future<void> removeFromWishlist(String userId, int bookId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'wishlist': FieldValue.arrayRemove([bookId])
      });
    } catch (e) {
      print('Error removing from wishlist: $e');
      rethrow;
    }
  }

    Stream<List<BookModel>> searchBooks(String query) {
    return _firestore
        .collection('books')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff') // Firestore string range query
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => BookModel.fromJson(doc.data() as Map<String, dynamic>, doc.id)
).toList());
  }

  
}