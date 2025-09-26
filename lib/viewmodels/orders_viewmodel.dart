import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../services/local_orders_repository.dart';

class OrdersViewModel extends ChangeNotifier {
  final LocalOrdersRepository _repo = LocalOrdersRepository();

  List<Order> _orders = [];
  bool _loading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _orders = await _repo.getOrders();
    _loading = false;
    notifyListeners();
  }

  Future<void> add(Order order) async {
    await _repo.addOrder(order);
    _orders.insert(0, order);
    notifyListeners();
  }
}
