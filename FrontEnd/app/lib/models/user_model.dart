class UserModel {
  String uid;
  String username;
  String email;
  String phone;
  List<String> searchPrompts;
  List<String> wishlist;
  List<Map<String, dynamic>> cartItems;
  List<String> orders;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.phone,
    this.searchPrompts = const [],
    this.wishlist = const [],
    this.cartItems = const [],
    this.orders = const [],
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
      wishlist: List<String>.from(json['wishlist'] ?? []),
      cartItems: List<Map<String, dynamic>>.from(json['cartItems'] ?? []),
      orders: List<String>.from(json['orders'] ?? []),
    );
  }
}
