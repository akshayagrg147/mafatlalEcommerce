import 'package:mafatlal_ecommerce/features/home/SubCategory/model/district_model.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/organization_model.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/state_model.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';
import 'package:mafatlal_ecommerce/routes/api_routes.dart';
import 'package:mafatlal_ecommerce/services/dio_utils_service.dart';

class SubCategoryRepo {
  static Future<List<Organization>> getorganization(int subid,
      {int? stateId, int? districtId}) async {
    final queryParams = {'sub_id': subid};
    if (stateId != null && stateId != 0) {
      queryParams['state'] = stateId;
    }
    if (districtId != null && districtId != 0) {
      queryParams['district'] = districtId;
    }
    final response = await DioUtil()
        .getInstance()
        ?.get(ApiRoutes.getorgainzation, queryParameters: queryParams);
    List<dynamic> organizationsJson = response?.data['data'];
    return organizationsJson
        .map((json) => Organization.fromJson(json))
        .toList();
  }

  static Future<List<Organization>> getorganizationsubit(int subid) async {
    final response = await DioUtil()
        .getInstance()
        ?.get(ApiRoutes.getorgainzation, queryParameters: {'sub_id': subid});
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

  static Future<ApiResponse<List<Product_new>>> getProductsByState(int subid,
      {int? stateId, int? districtId, int? organizationId}) async {
    final queryParam = {
      'sub_id': subid,
    };
    if (stateId != null && stateId != 0) {
      queryParam['state'] = stateId;
    }
    if (districtId != null && districtId != 0) {
      queryParam['district'] = districtId;
    }
    if (organizationId != null && organizationId != 0) {
      queryParam['organization'] = organizationId;
    }
    final response = await DioUtil()
        .getInstance()
        ?.get(ApiRoutes.getProductsAccToCategory, queryParameters: queryParam);
    return ApiResponse<List<Product_new>>.fromJson(
        response?.data,
        (data) =>
            List<Product_new>.from(data.map((e) => Product_new.fromJson(e))));
  }

  static Future<List<StateModel>> getallstate() async {
    final response = await DioUtil().getInstance()?.get(
          ApiRoutes.get_all_state,
        );

    List<dynamic> statedata = response?.data['data'];
    return statedata.map((json) => StateModel.fromJson(json)).toList();
  }

  static Future<List<DistrictModel>> getalldistrict(int stateid) async {
    final response = await DioUtil()
        .getInstance()
        ?.get(ApiRoutes.get_district, queryParameters: {'state': stateid});
    List<dynamic> districtdata = response?.data['data'];
    return districtdata.map((json) => DistrictModel.fromJson(json)).toList();
  }
}
