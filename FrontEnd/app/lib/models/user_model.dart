class UserModel {
  String uid;
  String username;
  String email;
  String phone;
  List<String> searchPrompts;
  List<int> wishlist;
  List<Map<String, dynamic>> cartItems;
  List<String> orders;
  List<int> boughtBooks;
  double balance;

  //add list of bought books
  //save prompts
  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.phone,
    this.searchPrompts = const [],
    this.wishlist = const [],
    this.cartItems = const [],
    this.orders = const [],
    this.boughtBooks = const [],
    required this.balance
  });

  // Convert to Firestore Map
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'phone': phone,
      'searchPrompts': searchPrompts,
      'wishlist': wishlist,
      'cartItems': cartItems,
      'orders': orders,
      'boughtBooks':boughtBooks,
      'balance':balance
    };
  }

  // Convert from Firestore Map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      searchPrompts: List<String>.from(json['searchPrompts'] ?? []),
      wishlist: List<int>.from(json['wishlist'] ?? []),
      cartItems: List<Map<String, dynamic>>.from(json['cartItems'] ?? []),
      orders: List<String>.from(json['orders'] ?? []),
      boughtBooks: List<int>.from(json['boughtBooks'] ?? []),
      balance: json['balance']
    );
  }
}
