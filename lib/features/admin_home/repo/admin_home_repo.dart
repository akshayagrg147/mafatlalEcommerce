import 'package:mafatlal_ecommerce/features/admin_home/model/graph_model.dart';
import 'package:mafatlal_ecommerce/routes/api_routes.dart';
import 'package:mafatlal_ecommerce/services/dio_utils_service.dart';

class AdminHomeRepository {
  static Future<ApiResponse<GraphModel>> fetchOrderStats(
      String fromDate, int userId, String toDate) async {
    final response = await DioUtil().getInstance()?.get(
      ApiRoutes.adminhomegraph,
      queryParameters: {'from': fromDate, 'user_id': userId, "to": toDate},
    );

    return ApiResponse.fromJson(
      response!.data,
      (data) => GraphModel.fromJson(data),
    );
  }
}
