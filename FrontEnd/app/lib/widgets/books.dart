import 'package:app/views/book_details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../routes/routes.dart';

class BookGrid extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('books').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No books available"));
        }

        List<BookModel> books = snapshot.data!.docs.map((doc) {
          return BookModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            itemCount: books.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 300,
            ),
            itemBuilder: (context, index) {
              return BookCard(book: books[index]);
            },
          ),
        );
      },
    );
  }
}

class BookCard extends StatelessWidget {
  final BookModel book;

  BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Tapped on ${book.name}");
        Navigator.pushNamed(
          context,
          AppRoutes.book_details_page,
          arguments: book, 
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              book.imageurl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Text(book.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(book.author, style: TextStyle(fontSize: 14, color: Colors.grey)),
          Text("${book.price}",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}











class BookGridOfWishlist extends StatelessWidget {
  final List<int> wishlist; // List of book IDs
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BookGridOfWishlist({required this.wishlist});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('books').where('id', whereIn: wishlist).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No books in your wishlist"));
        }

        List<BookModel> books = snapshot.data!.docs.map((doc) {
          return BookModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            itemCount: books.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 300,
            ),
            itemBuilder: (context, index) {
              return BookCard(book: books[index]);
            },
          ),
        );
      },
    );
  }
}
