class Product {
  final int id;
  final String title;
  final String thumbnail;
  final double price;
  final double rating;

  Product({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['id'] as int,
    title: j['title'] as String,
    thumbnail: (j['thumbnail'] ?? '') as String,
    price: (j['price'] as num).toDouble(),
    rating: (j['rating'] as num).toDouble(),
  );
}
