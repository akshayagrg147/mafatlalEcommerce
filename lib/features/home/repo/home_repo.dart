import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/model/address.dart';
import 'package:mafatlal_ecommerce/features/home/model/order.dart';
import 'package:mafatlal_ecommerce/features/home/model/product.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_model.dart';
import 'package:mafatlal_ecommerce/routes/api_routes.dart';
import 'package:mafatlal_ecommerce/services/dio_utils_service.dart';

class HomeRepo {
  static Future<ApiResponse<Store>> getStoreData() async {
    final response = await DioUtil()
        .getInstance()
        ?.get(ApiRoutes.fetchStoreDetails, queryParameters: {'user_id': 1});
    return ApiResponse<Store>.fromJson(
        response?.data, (data) => Store.fromJson(data));
  }

  static Future<ApiResponse<List<Product>>> getProductsBySubCatId(
      int subCategoryId) async {
    final response = await DioUtil().getInstance()?.get(
        ApiRoutes.getProductsAccToCategory,
        queryParameters: {'sub_id': subCategoryId});
    return ApiResponse<List<Product>>.fromJson(response?.data,
        (data) => List<Product>.from(data.map((e) => Product.fromJson(e))));
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
      {required Address address}) async {
    final num price = products.fold(
        0,
        (previousValue, element) =>
            previousValue + (element.price * element.quantity));
    final data = {
      "user_id": CubitsInjector.authCubit.currentUser!.id,
      "price": price,
      "address": address.address,
      "state": address.state,
      "pincode": address.pincode,
      "district": address.district,
      "city": address.city,
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
}
