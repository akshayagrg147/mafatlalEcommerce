import 'package:mafatlal_ecommerce/features/home/model/category_model.dart';
import 'package:mafatlal_ecommerce/features/home/model/product.dart';

class Store {
  List<Category> categories;
  List<Product> products;

  Store({required this.categories, required this.products});

  factory Store.fromJson(Map<String, dynamic> json) {
    var categories = List<Category>.from(
        json['categories'].entries.map((e) => Category.fromJson(e)));
    var products = List<Product>.from(
        (json['products'] as List).map((product) => Product.fromJson(
              product,
            )));

    return Store(categories: categories, products: products);
  }
}
