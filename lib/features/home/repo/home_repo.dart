import 'package:mafatlal_ecommerce/features/home/model/address.dart';
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
    final data = {
      // "user_id" : CubitsInjector.authCubit.currentUser.,
      "price": "1499",
      "address": "199, New shivpuri, Ghaziabad",
      "state": "U.P.",
      "pincode": "245101",
      "district": "Ghaziabad",
      "city": "Ghaziabad",
      "products": [
        {"product_id": 3, "size": "XL", "quantity": 2, "price": 498},
        {"product_id": 4, "size": "L", "quantity": 5, "price": 299}
      ]
    };
    final response = await DioUtil().getInstance()?.post(
          ApiRoutes.placeOrder,
        );
    return ApiResponse<Map>.fromJson(response?.data, (data) => data);
  }
}
