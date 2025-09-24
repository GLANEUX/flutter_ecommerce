import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductsViewModel extends ChangeNotifier {
  final ProductService _apiService = ProductService();

  List<Product> _products = [];
  List<String> _categories = ['All'];
  String _selectedCategory = 'All';
  bool _isLoading = false;
  String _errorMessage = '';

  List<Product> get products => _products;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;

  ProductsViewModel() {
    init();
  }

  Future<void> init() async {
    await Future.wait([
      loadCategories(),
      loadProducts(), // par défaut All
    ]);
  }

  Future<void> loadProducts({String? category}) async {
    if (_isLoading) return;
    _setLoading(true);
    _clearError();
    try {
      _products = await ProductService.fetchProducts(
        category: category ?? _selectedCategory,
      );
    } catch (_) {
      _setError('Impossible de charger les produits');
    }
    _setLoading(false);
  }

  Future<void> loadCategories() async {
    try {
      final cats = await ProductService.fetchCategories();
      _categories = ['All', ...cats];
      notifyListeners();
    } catch (_) {
      // silencieux, on garde ['All']
    }
  }

  Future<void> selectCategory(String cat) async {
    if (cat == _selectedCategory) return;
    _selectedCategory = cat;
    notifyListeners();
    await loadProducts(category: cat);
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String e) {
    _errorMessage = e;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
