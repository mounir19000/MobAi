import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../core/services/order_service.dart'; // Service to fetch orders

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  final OrderService _orderService = OrderService(); // Assuming OrderService exists

  List<OrderModel> get orders => _orders;

  void addOrder(OrderModel order) {
    _orders.add(order);
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((order) => order.orderId == orderId);
    if (index != -1) {
      _orders[index].status = newStatus;
      notifyListeners();
    }
  }

Future<void> loadOrdersForUser(String userId) async {
  try {
    final ordersStream = _orderService.getUserOrders(userId); // Get the stream
    final ordersData = await ordersStream.first; // Get first emitted value

    _orders = ordersData.map((orderData) => OrderModel.fromMap(orderData)).toList();
  } catch (e) {
    print("Error loading orders: $e");
    _orders = [];
  }
  notifyListeners();
}


}
