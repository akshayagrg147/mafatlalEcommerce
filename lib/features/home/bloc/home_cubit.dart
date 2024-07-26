import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/constants/state_district.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/model/address.dart';
import 'package:mafatlal_ecommerce/features/home/model/product.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_model.dart';
import 'package:mafatlal_ecommerce/features/home/repo/home_repo.dart';
import 'package:mafatlal_ecommerce/services/dio_utils_service.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());

  Store? _storeData;
  Store? get storeData => _storeData;
  Address? _deliveryAddress;
  Address? get deliveryAddress => _deliveryAddress;
  StreamSubscription<BoxEvent>? _cartStream;
  final List<Product> cartProducts = [];

  void updateState(String state) {
    final districtList = StateDistricts.getDistrictList(state);
    emit(GetDistrictListState(districtList));
  }

  void updateDistrict(String district) {
    emit(UpdateDistrictState(district));
  }

  void updateAddress(Address address) {
    _deliveryAddress = address;
    emit(UpdateAddressState());
  }

  void fetchStoreData() async {
    try {
      emit(FetchStoreDataLoadingState());
      final response = await HomeRepo.getStoreData();
      if (response.data != null) {
        _storeData = response.data;
        emit(FetchStoreDataSuccessState());
      } else {
        emit(FetchStoreDataFailedState(response.message));
      }
    } on DioException catch (e) {
      emit(FetchStoreDataFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(FetchStoreDataFailedState(AppStrings.somethingWentWrong));
    }
  }

  void fetchProductsBySubcategoryId(int subCategoryId) async {
    try {
      emit(FetchSubcategoryProductsLoadingState(subCategoryId));
      final response = await HomeRepo.getProductsBySubCatId(subCategoryId);
      if (response.data != null) {
        emit(FetchSubcategoryProductsSuccessState(subCategoryId,
            products: response.data!));
      } else {
        emit(FetchSubcategoryProductsFailedState(response.message,
            subCategoryId: subCategoryId));
      }
    } on DioException catch (e) {
      emit(FetchSubcategoryProductsFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong,
          subCategoryId: subCategoryId));
    } catch (e) {
      emit(FetchSubcategoryProductsFailedState(AppStrings.somethingWentWrong,
          subCategoryId: subCategoryId));
    }
  }

  void fetchCartProducts() async {
    try {
      emit(FetchCartLoadingState());
      cartProducts.clear();

      final productIds = CartHelper.getAllProductIds();
      if (productIds.isEmpty) {
        emit(FetchCartSuccessState());
        return;
      }
      final response = await HomeRepo.getCartProducts(productIds);
      if (response.data != null) {
        cartProducts.addAll(response.data!);
        emit(FetchCartSuccessState());
        _UpdateCartBilling();
      } else {
        emit(FetchCartFailedState(message: response.message));
      }
    } on DioException catch (e) {
      emit(FetchCartFailedState(
          message: e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(FetchCartFailedState(message: AppStrings.somethingWentWrong));
    }
  }

  void initializeCartStream() {
    _cartStream = CartHelper.watchCart().listen((event) {
      final productId = event.key;
      final data = event.value ?? {};
      final quantity = data['quantity'] ?? 0;

      if (quantity <= 0) {
        cartProducts.removeWhere((element) => element.productId == productId);
        emit(FetchCartSuccessState());
      } else {
        cartProducts
            .firstWhere((element) => element.productId == productId)
            .quantity = quantity;
      }
      _UpdateCartBilling();
    });
  }

  void _UpdateCartBilling() {
    final cartProductsCount = cartProducts.fold(
        0, (previousValue, element) => previousValue + element.quantity);
    final num cartAmount = cartProducts.fold(
        0,
        (previousValue, element) =>
            previousValue + (element.price * element.quantity));
    log("${cartProductsCount}  ${cartAmount}");
    emit(UpdateCartBillingState(
        itemCount: cartProductsCount, amount: cartAmount));
  }

  void resetCart() {
    _cartStream?.cancel();
    _cartStream = null;
    cartProducts.clear();
  }

  void placeOrder() async {
    try {
      emit(PlaceOrderLoadingState());
      // final response = await HomeRepo.getCartProducts(productIds)
    } on DioException catch (e) {
    } catch (e) {}
  }

  void clear() {
    _storeData = null;
    _cartStream = null;
    cartProducts.clear();
    _deliveryAddress = null;
  }
}
