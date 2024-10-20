import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/model/address.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';
import 'package:mafatlal_ecommerce/routes/api_routes.dart';
import 'package:mafatlal_ecommerce/services/dio_utils_service.dart';

class CheckoutRepo {
  static Future<ApiResponse<Map>> placeOrder(List<Product_new> products,
      {required Address shippingAddress,
      String? gstNumber,
      required Address billingAddress}) async {
    final num price = products.fold(
        0,
        (previousValue, element) =>
            previousValue + (element.getPrice() * element.quantity));
    final num tax = products.fold(
        0,
        (previousValue, element) =>
            previousValue + (element.getTax() * element.quantity));
    final data = {
      "user_id": CubitsInjector.authCubit.currentUser!.id,
      "price": price,
      "tax_Price": tax,
      "gst_number": gstNumber,
      "shipping": shippingAddress.toJson(),
      "billing": billingAddress.toJson(),
      "products": products.map((e) => e.toCartProductJson()).toList()
    };
    final response =
        await DioUtil().getInstance()?.post(ApiRoutes.placeOrder, data: data);
    return ApiResponse<Map>.fromJson(response?.data, (data) => data);
  }

  static Future<void> saveAddress(Address address,
      {required int userId, required bool isShipping}) async {
    final Map<String, dynamic> data = {
      "user_id": userId,
    };
    if (isShipping) {
      data['shipping'] = address.toJson();
    } else {
      data['billing'] = address.toJson();
    }

    await DioUtil().getInstance()?.post(ApiRoutes.address, data: data);
  }

  static Future<void> updateAddress(Address address,
      {required int userId, required bool isShipping}) async {
    final Map<String, dynamic> data = address.toJson();

    data["user_id"] = userId;
    data['address_type'] = isShipping ? 'shipping' : 'billing';

    await DioUtil().getInstance()?.patch(ApiRoutes.address, data: data);
  }

  static Future<ApiResponse<Map<String, dynamic>>> verifyPayment(
      {required String orderId,
      required String paymentId,
      required String signature}) async {
    final response =
        await DioUtil().getInstance()?.post(ApiRoutes.verifyPayment, data: {
      "razorpay_order_id": orderId,
      "razorpay_payment_id": paymentId,
      "razorpay_signature": signature
    });
    return ApiResponse<Map<String, dynamic>>.fromJson(response?.data, (data) {
      return data;
    });
  }
}
