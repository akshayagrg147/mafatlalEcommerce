import 'package:mafatlal_ecommerce/features/admin_products/model/admin_product.dart';
import 'package:mafatlal_ecommerce/features/admin_products/model/organisation_model.dart';
import 'package:mafatlal_ecommerce/features/admin_products/model/subcategory_model.dart';
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

  static Future<ApiResponse<List<Organisation>>> fetchOrganisations(
      int userId) async {
    final response = await DioUtil().getInstance()?.get(
        ApiRoutes.crudOrganisationList,
        queryParameters: {'user_id': userId});
    return ApiResponse<List<Organisation>>.fromJson(
        response!.data,
        (data) =>
            List<Organisation>.from(data.map((e) => Organisation.fromJson(e))));
  }

  static Future<ApiResponse<List<SubCategory>>> fetchSubCategories(int userId,
      {required int organisationId}) async {
    final response = await DioUtil().getInstance()?.get(
        ApiRoutes.crudOrganisationList,
        queryParameters: {'user_id': userId, 'organization': organisationId});
    return ApiResponse<List<SubCategory>>.fromJson(
        response!.data,
        (data) =>
            List<SubCategory>.from(data.map((e) => SubCategory.fromJson(e))));
  }
}
