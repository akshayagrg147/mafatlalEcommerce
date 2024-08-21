import 'package:hive_flutter/hive_flutter.dart';

class CartHelper {
  static void init() async {
    await Hive.initFlutter();

    Hive.openBox('cart');
  }

  static void clear() {
    _cartBox.clear();
  }

  static final Box _cartBox = Hive.box('cart');

  static void addProduct(int productId, String? size, int quantity) {
    final product = {
      'productId': productId,
      'size': size,
      'quantity': quantity,
    };

    _cartBox.put(productId, product);
  }

  static int getProductQuantity(
    int productId,
  ) {
    return (_cartBox.get(productId) ?? {})['quantity'] ?? 0;
  }

  static int getAllProductQuantity() {
    final quantity = getAllProducts().fold(0,
        (previousValue, element) => (element['quantity'] ?? 0) + previousValue);
    return quantity;
  }

  static String? getProductSize(
    int productId,
  ) {
    return (_cartBox.get(productId) ?? {})['size'];
  }

  static void updateProduct(int productId, String? size, int quantity) {
    final product = {
      'productId': productId,
      'size': size,
      'quantity': quantity,
    };

    _cartBox.put(productId, product);
  }

  static void removeProduct(int productId) {
    _cartBox.delete(productId);
  }

  static Stream<BoxEvent> watchCart([int? productId]) {
    if (productId == null) {
      return _cartBox.watch();
    }
    return _cartBox.watch(key: productId);
  }

  static List<Map> getAllProducts() {
    return _cartBox.values.cast<Map>().toList();
  }

  static List<int> getAllProductIds() {
    return _cartBox.keys.cast<int>().toList();
  }
}
