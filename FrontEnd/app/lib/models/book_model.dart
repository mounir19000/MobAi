class BookModel {
  String id;
  int bookid;
  String name;
  String author;
  String genre;
  double price;
  int stock;

  BookModel({
    required this.id,
    required this.bookid,
    required this.name,
    required this.author,
    required this.genre,
    required this.price,
    required this.stock,
  });

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'bookid':bookid,
      'name': name,
      'author': author,
      'genre': genre,
      'price': price,
      'stock': stock,
    };
  }

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['Id'],
      bookid:json['bookid'],
      name: json['name'],
      author: json['author'],
      genre: json['genre'],
      price: json['price'].toDouble(),
      stock: json['stock'],
    );
  }
}
