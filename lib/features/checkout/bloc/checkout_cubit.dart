import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/checkout/bloc/checkout_state.dart';
import 'package:mafatlal_ecommerce/features/checkout/repo/checkout_repo.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/features/home/model/address.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';
import 'package:razorpay_web/razorpay_web.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitialState());
  final _razorpay = Razorpay();
  Address? shippingAddress;
  Address? billingAddress;

  void selectBillingState(String stateName) {
    emit(SelectBillingState(stateName));
  }

  void selectShippingState(String stateName) {
    emit(SelectShippingState(stateName));
  }

  void selectBillingDistrict(String districtName) {
    emit(SelectBillingDistrict(districtName));
  }

  void selectShippingDistrict(String districtName) {
    emit(SelectShippingDistrict(districtName));
  }

  void updateSaveAddressCheckbox() {
    emit(UpdateStateAddressCheckBoxState());
  }

  void placeOrder({
    required List<Product_new> cartProducts,
    required Address shippingAddress,
    required Address billingAddress,
    String? gstNumber,
  }) async {
    try {
      emit(CheckoutOrderLoadingState());
      this.shippingAddress = shippingAddress;
      this.billingAddress = billingAddress;
      final response = await CheckoutRepo.placeOrder(cartProducts,
          gstNumber: gstNumber,
          shippingAddress: shippingAddress,
          billingAddress: billingAddress);
      if (response.status) {
        // CartHelper.clear();
        startPayment(
            orderId: response.data?['razorpay_order_id'] ?? "",
            amount: response.data?['price'] ?? 0,
            mobile: billingAddress.mobile);
      } else {
        emit(CheckoutOrderErrorState(response.message));
      }
    } on DioException catch (e) {
      emit(CheckoutOrderErrorState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(CheckoutOrderErrorState(AppStrings.somethingWentWrong));
    }
  }

  void startPayment({
    required String orderId,
    required double amount,
    required String mobile,
  }) async {
    try {
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

      var options = {
        'key': 'rzp_test_d6vCM7qPSQHngx',
        'amount': amount * 100,
        'name': 'Mafatlal Store',
        'order_id': orderId,
        'prefill': {
          'email': CubitsInjector.authCubit.currentUser!.email,
          mobile: mobile
        }
      };
      _razorpay.open(options);
    } catch (e) {
      _razorpay.clear();
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    log("message");
    verifyPayment(response);
    _razorpay.clear();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    log("message");
    emit(CheckoutOrderErrorState(
        response.message ?? AppStrings.somethingWentWrong));
    _razorpay.clear();
  }

  void verifyPayment(PaymentSuccessResponse successResponse) async {
    try {
      final response = await CheckoutRepo.verifyPayment(
          orderId: successResponse.orderId!,
          paymentId: successResponse.paymentId!,
          signature: successResponse.signature!);

      if (response.status) {
        CartHelper.clear();
        emit(CheckoutOrderSuccessState());
      } else {
        emit(CheckoutOrderErrorState(response.message));
      }
    } on DioException catch (e) {
      emit(CheckoutOrderErrorState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(CheckoutOrderErrorState(AppStrings.somethingWentWrong));
    }
  }
}
