class BookModel {
  String id;
  int bookId;
  String imageurl;
  String name;
  String description;
  String author;
  String genre;
  double price;
  int stock;

  BookModel({
    required this.id,
    required this.bookId,
    required this.imageurl,
    required this.name,
    required this.description,
    required this.author,
    required this.genre,
    required this.price,
    required this.stock,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId':bookId,
      'imageurl':imageurl,
      'name': name,
      'description':description,
      'author': author,
      'genre': genre,
      'price': price,
      'stock': stock,
    };
  }

  factory BookModel.fromJson(Map<String, dynamic> json, String docId) {
  return BookModel(
    id: docId, // ✅ Assign Firestore document ID
    bookId: json['bookId'] ?? 0,
    imageurl: json['imageurl'] ?? 'https://via.placeholder.com/150',
    name: json['name'] ?? 'Unknown',
    description: json['description'] ?? 'No description available',
    author: json['author'] ?? 'Unknown Author',
    genre: json['genre'] ?? 'Unknown Genre',
    price: (json['price'] ?? 0).toDouble(),
    stock: json['stock'] ?? 0,
  );
}

}
