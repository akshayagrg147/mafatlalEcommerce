import 'package:mafatlal_ecommerce/features/auth/model/user_model.dart';
import 'package:mafatlal_ecommerce/routes/api_routes.dart';
import 'package:mafatlal_ecommerce/services/dio_utils_service.dart';

class AuthRepo {
  static Future<ApiResponse<User>> registerUser(
      {required String email,
      required String pwd,
      required String name,
      required String state,
      required String district,
      required String gstNo}) async {
    final data = {
      "email": email,
      "name": name,
      "password": pwd,
      "state": state,
      "district": district,
      "gst": gstNo
    };

    final response =
        await DioUtil().getInstance()!.post(ApiRoutes.registerUser, data: data);
    return ApiResponse<User>.fromJson(
        response.data, (data) => User.fromJson(data));
  }

  static Future<ApiResponse<User>> login({
    required String email,
    required String pwd,
  }) async {
    final data = {
      "email": email,
      "password": pwd,
    };

    final response =
        await DioUtil().getInstance()!.post(ApiRoutes.login, data: data);
    return ApiResponse<User>.fromJson(
        response.data, (data) => User.fromJson(data));
  }

  static Future<ApiResponse<User>> fetchCurrentUser({
    required int userId,
  }) async {
    final response = await DioUtil()
        .getInstance()!
        .get(ApiRoutes.getCurrentUser, queryParameters: {'user_id': userId});
    return ApiResponse<User>.fromJson(
        response.data, (data) => User.fromJson(data));
  }
}
