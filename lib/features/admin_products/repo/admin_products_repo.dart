import 'package:mafatlal_ecommerce/features/admin_products/model/admin_product.dart';
import 'package:mafatlal_ecommerce/features/admin_products/model/organisation_model.dart';
import 'package:mafatlal_ecommerce/routes/api_routes.dart';
import 'package:mafatlal_ecommerce/services/dio_utils_service.dart';

class AdminProductRepo {
  static Future<ApiResponse<List<AdminProduct>>> fetchProducts(
      int userId) async {
    final response = await DioUtil()
        .getInstance()
        ?.get(ApiRoutes.crudProductList, queryParameters: {'user_id': userId});
    return ApiResponse<List<AdminProduct>>.fromJson(
        response!.data,
        (data) =>
            List<AdminProduct>.from(data.map((e) => AdminProduct.fromJson(e))));
  }

  static Future<ApiResponse<List<DataObject>>> fetchOrganisations(
      int userId) async {
    final response = await DioUtil().getInstance()?.get(
        ApiRoutes.crudOrganisationList,
        queryParameters: {'user_id': userId});
    return ApiResponse<List<DataObject>>.fromJson(
        response!.data,
        (data) =>
            List<DataObject>.from(data.map((e) => DataObject.fromJson(e))));
  }

  static Future<ApiResponse<List<DataObject>>> fetchCategories(
      int userId) async {
    final response = await DioUtil()
        .getInstance()
        ?.get(ApiRoutes.crudCategoryList, queryParameters: {'user_id': userId});
    return ApiResponse<List<DataObject>>.fromJson(
        response!.data,
        (data) =>
            List<DataObject>.from(data.map((e) => DataObject.fromJson(e))));
  }

  static Future<ApiResponse<List<DataObject>>> fetchSubCategories(int userId,
      {required int categoryId}) async {
    final response = await DioUtil().getInstance()?.get(
        ApiRoutes.crudSubCategoryList,
        queryParameters: {'user_id': userId, 'category': categoryId});
    return ApiResponse<List<DataObject>>.fromJson(
        response!.data,
        (data) =>
            List<DataObject>.from(data.map((e) => DataObject.fromJson(e))));
  }

  static Future<void> addProduct(
    int userId, {
    required String name,
    required String description,
    required List<String> imageUrl,
    int? categoryId,
    int? subCategoryId,
    int? orgId,
    required int price,
    required Map<String, int> size,
  }) async {
    final data = {
      "user_id": userId,
      "products": [
        {
          "name": name,
          "description": description,
          "price": price.toString(),
          "image": imageUrl,
        }
      ]
    };

    if (categoryId != null) {
      (data["products"] as List)[0]["category"] = categoryId.toString();
    }

    if (subCategoryId != null) {
      (data["products"] as List)[0]["sub_category"] = subCategoryId.toString();
    }

    if (orgId != null) {
      (data["products"] as List)[0]["organization"] = orgId.toString();
    }
    if (size.isNotEmpty) {
      (data["products"] as List)[0]["size"] = {"size": size};
    }
    await DioUtil().getInstance()?.post(ApiRoutes.crudProductList,
        queryParameters: {'user_id': userId}, data: data);
  }
}
