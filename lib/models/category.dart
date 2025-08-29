class Category {
  final String name;
  final String id;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? json['name'], // اگر API فقط اسم بده
      name: json['name'] ?? json['title'] ?? json['id'],
    );
  }
}
