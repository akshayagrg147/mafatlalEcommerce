import 'package:mafatlal_ecommerce/features/admin_orders/model/order_detail.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/model/order_model.dart';
import 'package:mafatlal_ecommerce/routes/api_routes.dart';
import 'package:mafatlal_ecommerce/services/dio_utils_service.dart';

class AdminOrderRepo {
  static Future<ApiResponse<List<OrderModel>>> fetchOrder(int userId,
      {required int page, DateTime? fromDate, DateTime? toDate}) async {
    final Map<String, dynamic> query = {
      'user_id': userId,
      'page': page,
    };
    if (fromDate != null) {
      query['from'] = fromDate.toIso8601String();
    }
    if (toDate != null) {
      query['to'] = toDate.toIso8601String();
    }
    final response = await DioUtil()
        .getInstance()
        ?.get(ApiRoutes.adminOrderList, queryParameters: query);

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

  static Future<void> updateOrderStatus(int orderId,
      {String? trackingUrl, required String status}) async {
    String path = ApiRoutes.updateOrderStatus;
    final Map<String, dynamic> query = {'order_id': orderId, 'status': status};
    if (trackingUrl != null) {
      path += '?tracking_url=$trackingUrl';
    }
    final response =
        await DioUtil().getInstance()?.get(path, queryParameters: query);
  }
}
