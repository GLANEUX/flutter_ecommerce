import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';

class LocalOrdersRepository {
  static const _key = 'orders_v1';

  Future<List<Order>> getOrders() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getStringList(_key) ?? <String>[];
    return raw.map((s) => Order.fromJson(s)).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> addOrder(Order order) async {
    final sp = await SharedPreferences.getInstance();
    final list = sp.getStringList(_key) ?? <String>[];
    list.add(order.toJson());
    await sp.setStringList(_key, list);
  }

  Future<void> clearAll() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_key);
  }
}
