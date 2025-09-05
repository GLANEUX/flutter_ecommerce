class Product {
  final int id;
  final String title;
  final num price;
  final String description;
  final String category;
  final String image;
  final num? rate;
  final int? count;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.rate,
    this.count,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rating = json['rating'] as Map<String, dynamic>?;
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: json['price'] as num,
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rate: rating?['rate'] as num?,
      count: rating?['count'] as int?,
    );
  }
}
