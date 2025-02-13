class OrderModel {
  String orderId;
  String userId;
  List<Map<String, dynamic>> items;
  double total;
  String status;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.total,
    this.status = "Pending",
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'items': items,
      'total': total,
      'status': status,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      userId: json['userId'],
      items: List<Map<String, dynamic>>.from(json['items'] ?? []),
      total: json['total'].toDouble(),
      status: json['status'] ?? "Pending",
    );
  }
}
