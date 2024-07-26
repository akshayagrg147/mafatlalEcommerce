
class SubCategory {
  final int id;
  final String name;

  SubCategory({required this.id, required this.name});

  factory SubCategory.fromJson(MapEntry entry) {
    return SubCategory(id: entry.value, name: entry.key);
  }
}
