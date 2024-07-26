import 'package:mafatlal_ecommerce/features/home/model/subcategory_model.dart';

class Category {
  final String category;
  final List<SubCategory> subCategories;

  Category({required this.category, required this.subCategories});

  factory Category.fromJson(MapEntry entry) {
    return Category(
        category: entry.key,
        subCategories: List<SubCategory>.from(
            (entry.value as Map).entries.map((e) => SubCategory.fromJson(e))));
  }
}