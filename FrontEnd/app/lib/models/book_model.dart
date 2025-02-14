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
      'Id': id,
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

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['Id'],
      bookId:json['bookId'],
      imageurl: json['imageurl'],
      name: json['name'],
      description: json['description'],
      author: json['author'],
      genre: json['genre'],
      price: json['price'].toDouble(),
      stock: json['stock'],
    );
  }
}
