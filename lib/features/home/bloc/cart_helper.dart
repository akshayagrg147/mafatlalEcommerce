import 'package:hive_flutter/hive_flutter.dart';
import 'package:mafatlal_ecommerce/features/home/model/product.dart';

class CartHelper {
  static Future<void> init() async {
    await Hive.initFlutter();

    await Hive.openBox('cart');
  }

  static void clear() {
    _cartBox.clear();
  }

  static final Box _cartBox = Hive.box('cart');

  static void addProduct(int productId, int quantity, {Variant? variant}) {
    final Map<String, dynamic> product = {
      'productId': productId,
      'quantity': quantity,
    };
    String id = "$productId";
    if (variant != null) {
      product[variant.variantTitle] = variant.selectedVariant.name;
      id += "_${variant.variantTitle}.${variant.selectedVariant.name}";
    }

    _cartBox.put(id, product);
  }

  static int getProductQuantity(int productId, {Variant? variant}) {
    String id = "$productId";
    if (variant != null) {
      id += "_${variant.variantTitle}.${variant.selectedVariant.name}";
    }
    return (_cartBox.get(id) ?? {})['quantity'] ?? 0;
  }

  static int getAllProductQuantity() {
    final quantity = getAllProducts().fold(0,
        (previousValue, element) => (element['quantity'] ?? 0) + previousValue);
    return quantity;
  }

  // static String? getProductSize(
  //   int productId,
  // ) {
  //   return (_cartBox.get(productId) ?? {})['size'];
  // }

  static void updateProduct(int productId, int quantity, {Variant? variant}) {
    final Map<String, dynamic> product = {
      'productId': productId,
      'quantity': quantity,
    };
    String id = "$productId";
    if (variant != null) {
      product[variant.variantTitle] = variant.selectedVariant.name;
      id += "_${variant.variantTitle}.${variant.selectedVariant.name}";
    }

    _cartBox.put(id, product);
  }

  static void removeProduct(int productId, {Variant? variant}) {
    String id = "$productId";
    if (variant != null) {
      id += "_${variant.variantTitle}.${variant.selectedVariant.name}";
    }
    _cartBox.delete(id);
  }

  static Stream<BoxEvent> watchCart([int? productId, Variant? variant]) {
    if (productId == null) {
      return _cartBox.watch();
    }
    String id = "$productId";
    if (variant != null) {
      id += "_${variant.variantTitle}.${variant.selectedVariant.name}";
    }
    return _cartBox.watch(key: id);
  }

  static List<Map> getAllProducts() {
    return _cartBox.values.cast<Map>().toList();
  }

  static List<int> getAllProductIds() {
    return _cartBox.values.map((e) => e['productId'] as int).toSet().toList();
  }
}
