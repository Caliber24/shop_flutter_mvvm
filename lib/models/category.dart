/// این کلاس داده‌های مختلفی که از API میان (string، map یا هر نوع دیگه) رو می‌گیره
/// و اون‌ها رو به یک شیء استاندارد با دو فیلد `id` (به صورت slug) و `name` (اسم خوانا) تبدیل می‌کنه.
/// هدفش نرمال‌سازی و یکدست کردن داده‌های دسته‌بندی برای استفاده در برنامه است.
class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});
  factory Category.fromApi(dynamic data) {
    if (data == null) return Category(id: 'unknown', name: 'Unknown');
    if (data is String) {
      final slug = _normalizeSlug(data);
      return Category(id: slug, name: _beautify(slug));
    }
    if (data is Map<String, dynamic>) {
      final rawId = (data['id'] ?? data['slug'] ?? data['name'] ?? '').toString();
      final slug = _normalizeSlug(rawId);
      final name = (data['name'] ?? data['title'] ?? rawId).toString();
      return Category(id: slug, name: name);
    }
    final s = data.toString();
    final slug = _normalizeSlug(s);
    return Category(id: slug, name: _beautify(slug));
  }
  static String _normalizeSlug(String s) {
    return s.toLowerCase().trim().replaceAll(RegExp(r'[_\s]+'), '-');
  }
  static String _beautify(String slug) {
    final words = slug.replaceAll('-', ' ').split(' ');
    return words.map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1)).join(' ');
  }
}
