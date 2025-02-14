import 'package:flutter/foundation.dart';
import '../models/book_model.dart';
import '../core/services/book_service.dart'; // Service to fetch books
import '../models/user_model.dart';

class BookProvider with ChangeNotifier {
  List<BookModel> _books = [];
  final BookService _bookService = BookService(); // Assuming a BookService exists

  List<BookModel> get books => _books;

  void setBooks(List<BookModel> newBooks) {
    _books = newBooks;
    notifyListeners();
  }

  void addBook(BookModel book) {
    _books.add(book);
    notifyListeners();
  }

  void updateStock(int bookId, int newStock) {
    final index = _books.indexWhere((book) => book.bookId == bookId);
    if (index != -1) {
      _books[index].stock = newStock;
      notifyListeners();
    }
  }

  Future<void> loadBooksForUser(UserModel? user) async {
    if (user == null) return; // No user logged in, no books to load

    _books = await _bookService.getBooksForUser(user.uid);
    notifyListeners();
  }
}
