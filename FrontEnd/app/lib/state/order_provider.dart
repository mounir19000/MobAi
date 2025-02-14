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
    _orders = (await _orderService.getUserOrders(userId)) as List<OrderModel>;
    notifyListeners();
  }
}
