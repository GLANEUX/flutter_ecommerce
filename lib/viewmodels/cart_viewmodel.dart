import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

class CartViewModel extends ChangeNotifier {
  final Map<int, CartItem> _items = {}; // clé = product.id (int)

  Map<int, CartItem> get items => _items;

  int get totalItems =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.values.fold(
    0.0,
    (sum, item) => sum + (item.product.price * item.quantity),
  );

  double get shipping => _items.isEmpty ? 0.0 : 4.99; // à ta guise
  double get total => subtotal + shipping;

  void add(Product product, {int qty = 1}) {
    final id = product.id;
    if (_items.containsKey(id)) {
      _items[id]!.quantity += qty;
    } else {
      _items[id] = CartItem(product: product, quantity: qty);
    }
    notifyListeners();
  }

  void remove(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void decrease(int productId) {
    if (!_items.containsKey(productId)) return;
    final item = _items[productId]!;
    if (item.quantity > 1) {
      item.quantity -= 1;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void increase(int productId) {
    if (!_items.containsKey(productId)) return;
    _items[productId]!.quantity += 1;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
