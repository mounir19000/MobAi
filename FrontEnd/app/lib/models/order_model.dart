class OrderModel {
  String orderId;
  String userId;
  List<Map<String, dynamic>> items;
  double total;
  String status;
  String name;
  String phonenumber;
  String address;


  OrderModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.total,
    this.status = "Pending",
    required this.name,
    required this.phonenumber,
    required this.address
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'items': items,
      'total': total,
      'status': status,
      'name':name,
      'phonenumber':phonenumber,
      'address':address
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      userId: json['userId'],
      items: List<Map<String, dynamic>>.from(json['items'] ?? []),
      total: json['total'].toDouble(),
      status: json['status'] ?? "Pending",
      name: json['name'],
      phonenumber: json['phonenumber'],
      address: json['address']
    );
  }

    factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'],
      status: map['status'],

      userId: map['userId'],
      items: List<Map<String, dynamic>>.from(map['items'] ?? []),
      total: map['total'].toDouble(),
      
      name: map['name'],
      phonenumber: map['phonenumber'],
      address: map['address']
    );
  }
}
