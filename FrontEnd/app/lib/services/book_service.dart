import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';

class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<BookModel?> getBook(int bookId) async {
    try {
      QuerySnapshot book = await _firestore
          .collection('books')
          .where('bookId', isEqualTo: bookId)
          .get();
      if (book.docs.isNotEmpty) {
        return BookModel.fromJson(book.docs.first.data() as Map<String, dynamic>);
      }

      return null; // Book not found
    } catch (e) {
      return null;
    }
  }


  Future<void> addToWishlist(String userId, int bookId) async {
    DocumentReference userRef = _firestore.collection('users').doc(userId);
    DocumentSnapshot userDoc = await userRef.get();

    if (userDoc.exists) {
      List wishlist = userDoc.get('wishlist') ?? [];

      if (!wishlist.contains(bookId)) {
        wishlist.add(bookId);
        await userRef.update({'wishlist': wishlist});
      }
    }
  }
  Future<void> removeFromWishlist(String userId, int bookId) async {
    DocumentReference userRef = _firestore.collection('users').doc(userId);
    DocumentSnapshot userDoc = await userRef.get();

    if (userDoc.exists) {
      List wishlist = userDoc.get('wishlist') ?? [];

      if (wishlist.contains(bookId)) {
        wishlist.remove(bookId);
        await userRef.update({'wishlist': wishlist});
      }
    }
  }
}
