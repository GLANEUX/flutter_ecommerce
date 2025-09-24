// product_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  static const String baseUrl = 'https://fakestoreapi.com';

  // 🔹 Produits
  static Future<List<Product>> fetchProducts({String? category}) async {
    try {
      final url = (category == null || category.toLowerCase() == 'all')
          ? '$baseUrl/products'
          : '$baseUrl/products/category/$category';

      final response = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Erreur serveur : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Impossible de charger les produits : $e');
    }
  }

  // 🔹 Catégories
  static Future<List<String>> fetchCategories() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/products/categories'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return List<String>.from(jsonData);
      } else {
        throw Exception('Erreur serveur : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Impossible de charger les catégories : $e');
    }
  }
}
