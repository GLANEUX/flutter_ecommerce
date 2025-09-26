import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductsViewModel extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String _error = '';

  String _query = '';
  String _category = 'All';

  // Getters
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get errorMessage => _error;
  bool get hasError => _error.isNotEmpty;
  String get query => _query;
  String get category => _category;

  // Liste filtrée (query + catégorie)
  List<Product> get filteredProducts {
    final q = _query.trim().toLowerCase();
    return _products.where((p) {
      final t = p.title.toLowerCase();
      final c = p.category.toLowerCase();
      final matchesQuery = q.isEmpty || t.contains(q) || c.contains(q);
      final matchesCat =
          _category.toLowerCase() == 'all' || c == _category.toLowerCase();
      return matchesQuery && matchesCat;
    }).toList();
  }

  ProductsViewModel() {
    loadProducts();
  }

  Future<void> loadProducts({String? category}) async {
    if (_isLoading) return;
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      if (category != null) _category = category;
      _products = await ProductService.fetchProducts(category: _category);
    } catch (e) {
      _error = 'Impossible de charger les produits';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setQuery(String? value) {
    _query = value?.trim() ?? '';
    notifyListeners();
  }

  void setCategory(String value) {
    if (_category == value) return;
    _category = value;
    notifyListeners();
    loadProducts(category: value);
  }

  Future<List<String>> loadCategories() async {
    try {
      final cats = await ProductService.fetchCategories();
      return ['All', ...cats];
    } catch (_) {
      return ['All'];
    }
  }
}
