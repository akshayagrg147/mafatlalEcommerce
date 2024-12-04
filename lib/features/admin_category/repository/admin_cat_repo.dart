import 'package:mafatlal_ecommerce/features/admin_category/model/admin_cat_model.dart';
import 'package:mafatlal_ecommerce/features/admin_category/model/admin_org-model.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/district_model.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/state_model.dart';
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

  static Future<void> addCategory(
    int userId, {
    required String categoryName,
  }) async {
    final data = {
      "user_id": userId,
      "categories": [
        {
          "name": categoryName,
        }
      ]
    };
    final response = await DioUtil()
        .getInstance()
        ?.post(ApiRoutes.crudCategoryList, data: data);
    if (response?.statusCode == 200) {
      return;
    }
  }

  static Future<void> updateCategory(
    int userId, {
    required int categoryId,
    required String categoryName,
  }) async {
    final data = {
      "id": categoryId,
      "user_id": userId,
      "name": categoryName,
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
      required String imageUrl,
      String? bannerImageUrl}) async {
    final subcat = {
      "name": subCategoryName,
      "image": imageUrl,
      "category": categoryId
    };
    if (bannerImageUrl != null) {
      subcat['banner_images'] = [bannerImageUrl];
    }
    final data = {
      "user_id": userId,
      "sub_category": [subcat]
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
      required String imageUrl,
      String? bannerImgUrl}) async {
    final data = {
      "id": subCategoryId,
      "user_id": userId,
      "name": subCategoryName,
      "image": imageUrl,
    };
    if (bannerImgUrl != null) {
      data['banner_images'] = [bannerImgUrl];
    }
    final response = await DioUtil()
        .getInstance()
        ?.patch(ApiRoutes.crudSubCategoryList, data: data);
    if (response?.statusCode == 200) {
      return;
    }
  }

  static Future<void> addOrganisation(int userId,
      {required String organisationName, int? stateId, int? districtId}) async {
    final Map<String, dynamic> org = {
      "name": organisationName,
    };

    if (stateId != null) {
      org['state'] = stateId;
    }
    if (districtId != null) {
      org['district'] = districtId;
    }

    final data = {
      "user_id": 13,
      "organizations": [org]
    };
    final response = await DioUtil()
        .getInstance()
        ?.post(ApiRoutes.crudOrganisationList, data: data);
    if (response?.statusCode == 200) {
      return;
    }
  }

  static Future<void> updateOrganisation(int userId,
      {required String organisationName,
      required int organisationId,
      int? stateId,
      int? districtId}) async {
    final Map<String, dynamic> data = {
      "id": organisationId,
      "user_id": userId,
      "name": organisationName,
    };

    if (stateId != null) {
      data['state'] = stateId;
    }
    if (districtId != null) {
      data['district'] = districtId;
    }
    final response = await DioUtil()
        .getInstance()
        ?.patch(ApiRoutes.crudOrganisationList, data: data);
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

  static Future<void> deleteOrganisation(
    int organisationId,
  ) async {
    await DioUtil()
        .getInstance()
        ?.delete(ApiRoutes.crudOrganisationList, data: {'id': organisationId});
  }

  static Future<ApiResponse<List<StateModel>>> getAllStates() async {
    final response = await DioUtil().getInstance()?.get(
          ApiRoutes.get_all_state,
        );

    return ApiResponse<List<StateModel>>.fromJson(
      response!.data,
      (data) => List<StateModel>.from(data.map((e) => StateModel.fromJson(e))),
    );
  }

  static Future<ApiResponse<List<DistrictModel>>> getDistrictsByStateId(
      int stateId) async {
    final response = await DioUtil()
        .getInstance()
        ?.get(ApiRoutes.get_district, queryParameters: {'state': stateId});

    return ApiResponse<List<DistrictModel>>.fromJson(
      response!.data,
      (data) =>
          List<DistrictModel>.from(data.map((e) => DistrictModel.fromJson(e))),
    );
  }
}
