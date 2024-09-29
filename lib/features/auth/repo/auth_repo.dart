import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
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
      required String gstNo,
      required String pinCode}) async {
    final data = {
      "email": email,
      "name": name,
      "password": pwd,
      "state": state,
      "district": district,
      "gst": gstNo,
      "pincode": pinCode
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

  static Future<ApiResponse<String?>> uploadImage(XFile file) async {
    final fileName = file.name.split('.').first;
    final mimeType = file.name.split('.').last;
    final mltFile = !kIsWeb
        ? await MultipartFile.fromFile(file.path, filename: fileName)
        : MultipartFile.fromBytes(await file.readAsBytes(), filename: fileName);
    var data =
        FormData.fromMap({'mime_type': mimeType, 'image_name': fileName});
    final img = MapEntry<String, MultipartFile>('photo_dec', mltFile);
    data.files.add(img);

    final response =
        await DioUtil().getInstance()?.post(ApiRoutes.uploadImage, data: data);
    return ApiResponse<String?>.fromJson(
        response!.data,
        (data) =>
            data is Map ? data['file_url']?.toString() : data?.toString());
  }
}
