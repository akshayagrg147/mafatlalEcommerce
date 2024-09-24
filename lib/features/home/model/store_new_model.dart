import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/features/home/model/product.dart';

class CategoriesAndProducts {
  final List<Category_new> categories;
  final List<Product_new> products;

  CategoriesAndProducts({required this.categories, required this.products});

  factory CategoriesAndProducts.fromJson(Map<String, dynamic> json) {
    return CategoriesAndProducts(
      categories: List<Category_new>.from(
          json['categories']?.map((x) => Category_new.fromJson(x))),
      products: List<Product_new>.from(
          json['products']?.map((x) => Product_new.fromJson(x))),
    );
  }
}

class Data {
  final List<Category_new> categories;
  final List<Product_new> products;

  Data({
    required this.categories,
    required this.products,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      categories:
          json['categories']?.map((x) => Category_new.fromJson(x)).toList() ??
              [],
      products:
          (json['products'])?.map((x) => Product_new.fromJson(x)).toList(),
    );
  }
}

class Category_new {
  final int id;
  final String name;
  final String img;
  final List<SubCategory_new> subCategories;

  Category_new({
    required this.id,
    required this.name,
    required this.img,
    required this.subCategories,
  });

  factory Category_new.fromJson(Map<String, dynamic> json) {
    return Category_new(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      img: json['img']?.toString() ?? '',
      subCategories: (json['sub_categories'] as List<dynamic>? ?? [])
          .map(
              (x) => SubCategory_new.fromJson(x as Map<String, dynamic>? ?? {}))
          .toList(),
    );
  }
}

class SubCategory_new {
  final int id;
  final String name;
  final String img;
  final bool isDistrict;
  final bool isState;
  final bool isOrganization;

  SubCategory_new({
    required this.id,
    required this.name,
    required this.img,
    required this.isDistrict,
    required this.isState,
    required this.isOrganization,
  });

  factory SubCategory_new.fromJson(Map<String, dynamic> json) {
    return SubCategory_new(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      img: json['img']?.toString() ?? '',
      isDistrict: json['is_district'] as bool? ?? false,
      isState: json['is_state'] as bool? ?? false,
      isOrganization: json['is_organization'] as bool? ?? false,
    );
  }
}

class Product_new {
  final int productId;
  final int selectedCategoryId;
  final String productName;
  final String productCategory;
  final Variant? variant;
  final List<String> productImage;
  final String price;
  int quantity;

  Product_new({
    required this.productId,
    required this.selectedCategoryId,
    required this.productName,
    required this.productCategory,
    required this.variant,
    required this.productImage,
    required this.price,
    required this.quantity,
  });

  factory Product_new.fromJson(Map<String, dynamic> json) {
    // Use the conversion method for both IDs
    final id = json['product_id'] ?? json['id'];
    final selectedCategoryId = json['Selected_category_id'] ?? 0;

    return Product_new(
      productId: _convertToInt(id),
      selectedCategoryId: _convertToInt(selectedCategoryId),
      productName: json['product_name']?.toString() ?? '',
      productCategory: json['product_category']?.toString() ?? '',
      variant: _parseVariant(json['size_available']),
      productImage: _parseProductImage(json['product_image']),
      price: json['price']?.toString() ?? '',
      quantity: CartHelper.getProductQuantity(id),
    );
  }

  static int _convertToInt(dynamic value) {
    if (value is int) {
      return value; // Already an int
    } else if (value is String) {
      // Attempt to parse the string to an int
      final parsedValue = int.tryParse(value);
      return parsedValue ?? 0; // Return 0 if parsing fails
    }
    return 0; // Default case for unexpected types
  }

  static Variant? _parseVariant(dynamic sizeAvailable) {
    if (sizeAvailable is Map) {
      return Variant.fromJson(
          sizeAvailable.entries.first); // Adjust based on your Variant model
    }
    return null;
  }

  static List<String> _parseProductImage(dynamic productImage) {
    if (productImage is Map) {
      return List<String>.from(productImage.values.map((e) => e.toString()));
    }
    return [];
  }
}

// Example of RelatedProduct to ensure proper conversion
class RelatedProduct {
  final int id;
  final String name;
  final String productCategory;

  RelatedProduct({
    required this.id,
    required this.name,
    required this.productCategory,
  });

  factory RelatedProduct.fromJson(Map<String, dynamic> json) {
    return RelatedProduct(
      id: Product_new._convertToInt(json['id']),
      name: json['name']?.toString() ?? '',
      productCategory: json['product_category']?.toString() ?? '',
    );
  }
}
