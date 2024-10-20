import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/features/home/model/product.dart';

class ProductDetail {
  final String id;
  final String name;
  final String productCategory;
  final String productSubCategory;
  final String productOrganization;
  final Variant? variant;
  final List<String> productImage;

  final String price;
  final double gstPercentage;
  final String? description;
  final List<RelatedProduct> relatedProducts;
  int quantity;

  ProductDetail({
    required this.id,
    required this.name,
    required this.productCategory,
    required this.productSubCategory,
    required this.variant,
    required this.productImage,
    required this.price,
    this.description,
    required this.relatedProducts,
    required this.quantity,
    required this.gstPercentage,
    required this.productOrganization,
  });

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

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    var relatedProductsFromJson = json['related_products'] as List;
    List<RelatedProduct> relatedProductsList = relatedProductsFromJson
        .map((product) => RelatedProduct.fromJson(product))
        .toList();
    final id = json['id'];
    final variant = _parseVariant(json['size_available']);
    return ProductDetail(
      id: json['id'],
      name: json['name'],
      productCategory: json['product_category'],
      productSubCategory: json['product_sub_category'],
      variant: variant,
      productImage: _parseProductImage(json['product_image']),
      price: json['price'],
      description: json['description'],
      gstPercentage: double.tryParse(json['gst_percentage'] ?? "0") ?? 0,
      productOrganization: json['product_organization'] ?? '',
      relatedProducts: relatedProductsList,
      quantity: CartHelper.getProductQuantity(int.parse(id), variant: variant),
    );
  }

  num getPrice() {
    if (variant != null) {
      return variant!.selectedVariant.price +
          ((variant!.selectedVariant.price * gstPercentage) / 100);
    }
    final parsedPrice = double.tryParse(price ?? '0.0') ?? 0.0;
    return parsedPrice + ((parsedPrice * gstPercentage) / 100);
  }
}

class ProductImage {
  final String image1;

  ProductImage({required this.image1});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(image1: json['image_1']);
  }
}

class RelatedProduct {
  final String id;
  final String name;
  final String productCategory;
  final String productSubCategory;
  final String productOrganization;
  final Variant? variant;
  final ProductImage productImage;
  final String price;
  final String? description;
  final double gstPercentage;
  int quantity;

  RelatedProduct(
      {required this.id,
      required this.name,
      required this.productCategory,
      required this.productSubCategory,
      required this.variant,
      required this.productImage,
      required this.price,
      this.description,
      required this.productOrganization,
      required this.quantity,
      required this.gstPercentage});

  static Variant? _parseVariant(dynamic sizeAvailable) {
    if (sizeAvailable is Map && sizeAvailable.isNotEmpty) {
      return Variant.fromJson(
          sizeAvailable.entries.first); // Adjust based on your Variant model
    }
    return null; // Return null if size_available is empty or not a Map
  }

  num getPrice() {
    if (variant != null) {
      return variant!.selectedVariant.price +
          ((variant!.selectedVariant.price * gstPercentage) / 100);
    }
    final parsedPrice = double.tryParse(price ?? '0.0') ?? 0.0;
    return parsedPrice + ((parsedPrice * gstPercentage) / 100);
  }

  factory RelatedProduct.fromJson(Map<String, dynamic> json) {
    final id = json['id'].toString();
    return RelatedProduct(
      id: json['id'].toString(),
      name: json['name'],
      productCategory: json['product_category'],
      productSubCategory: json['product_sub_category'],
      variant: _parseVariant(json['size_available']),
      productOrganization: json['product_organization'] ?? '',
      productImage: ProductImage.fromJson(json['product_image']),
      price: json['price'],
      description: json['description'],
      gstPercentage: double.tryParse(json['gst_percentage'] ?? "0") ?? 0,
      quantity: CartHelper.getProductQuantity(int.parse(id)),
    );
  }
}
