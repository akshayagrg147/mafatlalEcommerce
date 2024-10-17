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
  final int categoryId; // Should be an int
  final String productName;
  final String productCategory;
  final Variant? variant;
  final List<String> productImage;
  final num price; // Should be num
  int quantity;

  Product_new({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.productCategory,
    required this.variant,
    required this.productImage,
    required this.price,
    required this.quantity,
  });

  // Method to handle dynamic type conversion
  static int _convertToInt(dynamic value) {
    if (value is String) {
      return int.tryParse(value) ?? 0; // Convert String to int, default to 0
    }
    return value as int; // Return value as int if already int
  }

  static num _convertToNum(dynamic value) {
    if (value is String) {
      return num.tryParse(value) ?? 0; // Convert String to num, default to 0
    }
    return value as num; // Return value as num if already num
  }

  factory Product_new.fromJson(Map<String, dynamic> json) {
    // Convert product_id and product_category_id to int
    final int id = _convertToInt(json['product_id'] ?? json['id']);
    final int categoryId = _convertToInt(json['product_category_id']);

    // Convert price to num
    final num price = _convertToNum(json['price']);

    return Product_new(
      productId: id,
      categoryId: categoryId,
      productName: json['product_name']?.toString() ?? '',
      productCategory: json['product_category']?.toString() ?? '',
      variant: _parseVariant(json['size_available']),
      productImage: _parseProductImage(json['product_image']),
      price: price,
      quantity: CartHelper.getProductQuantity(id,
          variant: _parseVariant(json['size_available'])),
    );
  }

  num getPrice() {
    if (variant != null) {
      return variant!.selectedVariant.price;
    }
    return price; // Price is always num now
  }

  num getAmount() {
    return getPrice() * quantity;
  }

  static Variant? _parseVariant(dynamic sizeAvailable) {
    if (sizeAvailable is Map && sizeAvailable.isNotEmpty) {
      return Variant.fromJson(
          sizeAvailable.entries.first); // Adjust based on your Variant model
    }
    return null; // Return null if size_available is empty or not a Map
  }

  static List<String> _parseProductImage(dynamic productImage) {
    if (productImage is Map) {
      return List<String>.from(productImage.values.map((e) => e.toString()));
    }
    return [];
  }

  Map<String, dynamic> toCartProductJson() {
    final Map<String, dynamic> map = {
      'product_id': productId,
      'quantity': quantity,
      'price': price,
    };
    if (variant != null) {
      map[variant!.variantTitle] = variant!.selectedVariant.name;
      map['price'] = variant!.selectedVariant.price;
    } else {
      map['variant'] = ''; // Ensure to add a placeholder for no variant
    }
    return map;
  }
}
