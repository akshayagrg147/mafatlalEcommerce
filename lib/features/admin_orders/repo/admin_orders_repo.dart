import 'package:mafatlal_ecommerce/features/admin_orders/model/order_detail.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/model/order_model.dart';
import 'package:mafatlal_ecommerce/routes/api_routes.dart';
import 'package:mafatlal_ecommerce/services/dio_utils_service.dart';

class AdminOrderRepo {
  static Future<ApiResponse<List<OrderModel>>> fetchOrder(int userId,
      {required int page}) async {
    final dt = DateTime.now();
    final fromDate = dt.subtract(Duration(days: 30));
    final response = await DioUtil()
        .getInstance()
        ?.get(ApiRoutes.adminOrderList, queryParameters: {
      'user_id': userId,
      'page': page,
      'from': fromDate.toIso8601String()
    });

    return ApiResponse.fromJson(
        response!.data,
        (data) =>
            List<OrderModel>.from(data.map((e) => OrderModel.fromMap(e))));
  }

  static Future<ApiResponse<OrderDetailModel>> fetchOrderDetails(
      int orderId) async {
    final response = await DioUtil().getInstance()?.get(
        ApiRoutes.getOrderDetails,
        queryParameters: {'order_id': orderId});
    return ApiResponse.fromJson(
        response!.data, (data) => OrderDetailModel.fromMap(data));
  }
}
