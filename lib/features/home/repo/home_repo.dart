import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/organization_model.dart';
import 'package:mafatlal_ecommerce/features/home/model/address.dart';
import 'package:mafatlal_ecommerce/features/home/model/order.dart';
import 'package:mafatlal_ecommerce/features/home/model/product.dart';
import 'package:mafatlal_ecommerce/features/home/model/productdetial_model.dart';
import 'package:mafatlal_ecommerce/features/home/model/searchmodel.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';
import 'package:mafatlal_ecommerce/routes/api_routes.dart';
import 'package:mafatlal_ecommerce/services/dio_utils_service.dart';

class HomeRepo {
  static Future<ApiResponse<CategoriesAndProducts>> getStoreData(
      int? userId) async {
    final response = await DioUtil().getInstance()?.get(
        ApiRoutes.fetchStoreDetails,
        queryParameters: userId != null ? {'user_id': userId} : null);
    print(response?.data);
    return ApiResponse<CategoriesAndProducts>.fromJson(
        response?.data, (data) => CategoriesAndProducts.fromJson(data));
  }

  static Future<List<Organization>> getsubcateddetails(int subid) async {
    final response = await DioUtil()
        .getInstance()
        ?.get(ApiRoutes.getorgainzation, queryParameters: {'sub_id': 27});
    List<dynamic> organizationsJson = response?.data['data'];
    return organizationsJson
        .map((json) => Organization.fromJson(json))
        .toList();
  }

  static Future<ApiResponse<List<Product_new>>> getProductsBySubCatId(
      int subCategoryId) async {
    final response = await DioUtil().getInstance()?.get(
        ApiRoutes.getProductsAccToCategory,
        queryParameters: {'sub_id': subCategoryId});
    return ApiResponse<List<Product_new>>.fromJson(
        response?.data,
        (data) =>
            List<Product_new>.from(data.map((e) => Product_new.fromJson(e))));
  }

  static Future<ApiResponse<ProductDetail>> fetchProductDetails(
      int productId) async {
    final response = await DioUtil()
        .getInstance()
        ?.get(ApiRoutes.getProductInfo, queryParameters: {'id': productId});
    return ApiResponse<ProductDetail>.fromJson(
        response?.data, (data) => ProductDetail.fromJson(data));
  }

  static Future<ApiResponse<List<Product>>> getCartProducts(
      List<int> productIds) async {
    final response = await DioUtil()
        .getInstance()
        ?.post(ApiRoutes.getCartProducts, data: {'ids': productIds});
    return ApiResponse<List<Product>>.fromJson(response?.data,
        (data) => List<Product>.from(data.map((e) => Product.fromJson(e))));
  }

  static Future<ApiResponse<Map>> placeOrder(List<Product> products,
      {required Address shippingAddress,
      required Address billingAddress}) async {
    final num price = products.fold(
        0,
        (previousValue, element) =>
            previousValue + (element.price * element.quantity));
    final data = {
      "user_id": CubitsInjector.authCubit.currentUser!.id,
      "price": price,
      "shipping": shippingAddress.toJson(),
      "billing": billingAddress.toJson(),
      "products": products.map((e) => e.toCartProductJson()).toList()
    };
    final response =
        await DioUtil().getInstance()?.post(ApiRoutes.placeOrder, data: data);
    return ApiResponse<Map>.fromJson(response?.data, (data) => data);
  }

  static Future<ApiResponse<List<Order>>> fetchOrderHistory() async {
    final response = await DioUtil().getInstance()?.get(ApiRoutes.orderHistory,
        queryParameters: {'user_id': CubitsInjector.authCubit.currentUser!.id});

    return ApiResponse<List<Order>>.fromJson(response?.data,
        (data) => List<Order>.from(data.map((e) => Order.fromJson(e))));
  }

  static Future<void> saveAddress(Address address,
      {required int userId, required bool isShipping}) async {
    final Map<String, dynamic> data = {
      "user_id": userId,
    };
    if (isShipping) {
      data['shipping'] = address.toJson();
    } else {
      data['billing'] = address.toJson();
    }

    await DioUtil().getInstance()?.post(ApiRoutes.address, data: data);
  }

  static Future<void> updateAddress(Address address,
      {required int userId, required bool isShipping}) async {
    final Map<String, dynamic> data = address.toJson();

    data["user_id"] = userId;
    data['address_type'] = isShipping ? 'shipping' : 'billing';

    await DioUtil().getInstance()?.patch(ApiRoutes.address, data: data);
  }

  static Future<ApiResponse<List<ProductSearch>>> search(
      String searchQuery) async {
    final response = await DioUtil()
        .getInstance()
        ?.get(ApiRoutes.search, queryParameters: {'search': searchQuery});
    return ApiResponse<List<ProductSearch>>.fromJson(response?.data, (data) {
      final categories = data['products'] ?? [];
      return List<ProductSearch>.from(
          categories.map((e) => ProductSearch.fromJson(e)));
    });
  }
}
