import 'package:mafatlal_ecommerce/features/admin_category/model/admin_cat_model.dart';
import 'package:mafatlal_ecommerce/features/admin_category/model/admin_org-model.dart';
import 'package:mafatlal_ecommerce/routes/api_routes.dart';
import 'package:mafatlal_ecommerce/services/dio_utils_service.dart';

class AdminCatRepo {
  static Future<ApiResponse<List<AdminCategory>>> fetchCategories(
      int userId) async {
    final response = await DioUtil()
        .getInstance()
        ?.get(ApiRoutes.crudCategoryList, queryParameters: {'user_id': userId});

    return ApiResponse<List<AdminCategory>>.fromJson(
        response!.data,
        (data) => List<AdminCategory>.from(
            data.map((e) => AdminCategory.fromJson(e))));
  }

  static Future<ApiResponse<List<AdminCategory>>> fetchSubCategories(int userId,
      {required int categoryId}) async {
    final response = await DioUtil().getInstance()?.get(
        ApiRoutes.crudSubCategoryList,
        queryParameters: {'user_id': userId, 'category': categoryId});

    return ApiResponse<List<AdminCategory>>.fromJson(
        response!.data,
        (data) => List<AdminCategory>.from(
            data.map((e) => AdminCategory.fromJson(e))));
  }

  static Future<ApiResponse<List<AdminOrganisation>>> fetchOrganisation(
      int userId) async {
    final response = await DioUtil().getInstance()?.get(
        ApiRoutes.crudOrganisationList,
        queryParameters: {'user_id': userId});

    return ApiResponse<List<AdminOrganisation>>.fromJson(
        response!.data,
        (data) => List<AdminOrganisation>.from(
            data.map((e) => AdminOrganisation.fromJson(e))));
  }

  static Future<void> addCategory(int userId,
      {required String categoryName, required String imageUrl}) async {
    final data = {
      "user_id": userId,
      "categories": [
        {"name": categoryName, "image": imageUrl}
      ]
    };
    final response = await DioUtil()
        .getInstance()
        ?.post(ApiRoutes.crudCategoryList, data: data);
    if (response?.statusCode == 200) {
      return;
    }
  }

  static Future<void> updateCategory(int userId,
      {required int categoryId,
      required String categoryName,
      required String imageUrl}) async {
    final data = {
      "id": categoryId,
      "user_id": userId,
      "name": categoryName,
      "image": imageUrl
    };
    final response = await DioUtil()
        .getInstance()
        ?.patch(ApiRoutes.crudCategoryList, data: data);
    if (response?.statusCode == 200) {
      return;
    }
  }

  static Future<void> addSubCategory(int userId,
      {required int categoryId,
      required String subCategoryName,
      required String imageUrl}) async {
    final data = {
      "user_id": userId,
      "sub_category": [
        {"name": subCategoryName, "image": imageUrl, "category": categoryId}
      ]
    };
    final response = await DioUtil()
        .getInstance()
        ?.post(ApiRoutes.crudSubCategoryList, data: data);
    if (response?.statusCode == 200) {
      return;
    }
  }

  static Future<void> updateSubCategory(int userId,
      {required int subCategoryId,
      required String subCategoryName,
      required String imageUrl}) async {
    final data = {
      "id": subCategoryId,
      "user_id": userId,
      "name": subCategoryName,
      "image": imageUrl
    };
    final response = await DioUtil()
        .getInstance()
        ?.patch(ApiRoutes.crudSubCategoryList, data: data);
    if (response?.statusCode == 200) {
      return;
    }
  }

  static Future<void> deleteCategory(
    int categoryId,
  ) async {
    await DioUtil()
        .getInstance()
        ?.delete(ApiRoutes.crudCategoryList, data: {'id': categoryId});
  }

  static Future<void> deleteSubCategory(
    int subCategoryId,
  ) async {
    await DioUtil()
        .getInstance()
        ?.delete(ApiRoutes.crudSubCategoryList, data: {'id': subCategoryId});
  }
}
