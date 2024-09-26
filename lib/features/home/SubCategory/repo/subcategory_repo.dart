import 'package:mafatlal_ecommerce/features/home/SubCategory/model/organization_model.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';
import 'package:mafatlal_ecommerce/routes/api_routes.dart';
import 'package:mafatlal_ecommerce/services/dio_utils_service.dart';

class SubCategoryRepo {
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
}
