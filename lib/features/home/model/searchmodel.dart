import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/features/home/model/product.dart';

class ProductSearch {
  final int? id;
  final String? name;
  final List<String>? productImage;
  final Variant? variant;
  final String? price;
  final String? description;
  final int? productCategoryId;
  final String? productCategoryName;
  final int? productSubcategoryId;
  final String? productSubcategoryName;
  final String? productOrganizationId;
  final String? productOrganizationName;
  int quantity;

  ProductSearch({
    this.id,
    this.name,
    this.productImage,
    this.variant,
    this.price,
    this.description,
    this.productCategoryId,
    this.productCategoryName,
    this.productSubcategoryId,
    this.productSubcategoryName,
    this.productOrganizationId,
    this.productOrganizationName,
    required this.quantity,
  });

  static List<String> _parseProductImage(dynamic productImage) {
    if (productImage is Map) {
      return List<String>.from(productImage.values.map((e) => e.toString()));
    }
    return [];
  }

  static Variant? _parseVariant(dynamic sizeAvailable) {
    if (sizeAvailable is Map && sizeAvailable.isNotEmpty) {
      return Variant.fromJson(
          sizeAvailable.entries.first); // Adjust based on your Variant model
    }
    return null;
  }

  factory ProductSearch.fromJson(Map<String, dynamic> json) {
    final idStr = json['id']?.toString() ?? '0';
    final id = int.tryParse(idStr);

    return ProductSearch(
      id: id,
      name: json['name'] ?? '',
      productImage: _parseProductImage(json['img']),
      variant: _parseVariant(json['size_available']),
      price: json['price'] ?? '0.0',
      description: json['description'] ?? '',
      productCategoryId: json['product_category_id'] as int?,
      productCategoryName: json['product_category_name'] ?? '',
      productSubcategoryId: json['product_subcategory_id'] as int?,
      productSubcategoryName: json['product_subcategory_name'] ?? '',
      productOrganizationId: json['product_organization_id']?.toString() ?? '',
      productOrganizationName: json['product_organization_name'] ?? '',
      quantity: CartHelper.getProductQuantity(id ?? 0),
    );
  }
}
