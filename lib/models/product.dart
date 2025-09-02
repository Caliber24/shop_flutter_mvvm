// محصولات را به شکل شی ذخیره می کنیم. و مدلسازی میکنیم
class Product {
  final int id;
  final String title;
  final String description;
  final String thumbnail;
  final double price;
  final double rating;
  final String? categoryId;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.price,
    required this.rating,
    this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
