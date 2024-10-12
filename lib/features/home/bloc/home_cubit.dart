import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/constants/state_district.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/repo/admin_orders_repo.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/model/address.dart';
import 'package:mafatlal_ecommerce/features/home/model/category_model.dart';
import 'package:mafatlal_ecommerce/features/home/model/product.dart';
import 'package:mafatlal_ecommerce/features/home/model/productdetial_model.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/search_screen.dart';
import 'package:mafatlal_ecommerce/features/home/repo/home_repo.dart';
import 'package:mafatlal_ecommerce/helper/enums.dart';
import 'package:mafatlal_ecommerce/services/dio_utils_service.dart';
import 'package:mafatlal_ecommerce/services/navigation_service.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());

  CategoriesAndProducts? _storeData;

  CategoriesAndProducts? get storeData => _storeData;

  bool isCategoryScreenShown = false;
  final List<Product_new> cartProducts = [];
  final searchController = TextEditingController();
  ProductDetail? productDetail;

  // Timer? _timer;

  bool isSearchScreenShown = false;

  final homeNavigatorKey = GlobalKey<NavigatorState>();

  void disposeSearch() {
    searchController.clear();
    // searchController.removeListener(searchDebouncer);
    isSearchScreenShown = false;
    // _timer = null;
  }

  // void initializeSearch() {
  //   if (_timer == null) {
  //
  //     searchController.addListener(searchDebouncer);
  //     emit(SearchInitialState());
  //   }
  // }

  // void searchDebouncer() {
  //   if (_timer != null) {
  //     _timer!.cancel();
  //   }
  //   _timer = Timer(
  //     const Duration(milliseconds: 500),
  //     () {
  //       searchOrganisation(searchController.text);
  //     },
  //   );
  // }
  void searchOrganisation(String searchText) async {
    try {
      emit(SearchLoadingState());

      await Future.delayed(const Duration(milliseconds: 200));
      final response = await HomeRepo.search(searchText);
      if (isSearchScreenShown == false) {
        homeNavigatorKey.currentState!
            .pushNamed(SearchScreen.route, arguments: response.data ?? []);
        isSearchScreenShown = true;
      } else {
        final route = NavigationService.getCurrentRouteName();
        if (route != SearchScreen.route) {
          homeNavigatorKey.currentState!
              .pushNamed(SearchScreen.route, arguments: response.data ?? []);
          isSearchScreenShown = true;
        }
      }
      print(response.data);
      emit(SearchSuccessState(
        organisations: response.data ?? [],
      ));
    } on DioException catch (e) {
      print(e);
      emit(SearchFailedState(
          message: e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      print(e);
      emit(SearchFailedState(message: AppStrings.somethingWentWrong));
    }
  }

  void searchOrganisationsmall(String searchText) async {
    try {
      emit(SearchLoadingState());

      await Future.delayed(const Duration(milliseconds: 200));
      final response = await HomeRepo.search(searchText);
      // homeNavigatorKey.currentState!.push(MaterialPageRoute(
      //     builder: (_) => SearchScreen(
      //           products: response.data ?? [],
      //         )));
      // isSearchScreenShown = true;
      print(response.data);
      emit(SearchSuccessState(
        organisations: response.data ?? [],
      ));
    } on DioException catch (e) {
      print(e);
      emit(SearchFailedState(
          message: e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      print(e);
      emit(SearchFailedState(message: AppStrings.somethingWentWrong));
    }
  }

  void getsubcategory() {
    emit(GetSubCategoryLoadingState());
  }

  void UpdateSubCategory(
      List<SubCategory_new> subCategories, String selectedCategoryName) {
    emit(UpdateLabelSuccessState(selectedCategoryName: selectedCategoryName));
    emit(UpdateSubCategorySuccessState(subcategoy: subCategories));
  }

  Future<void> UpdateproductAccordingtoCategory(int subid) async {
    emit(UpdateProductUsingSubCategoryLoadingState());
    final response = await HomeRepo.getProductsBySubCatId(subid);
    print(response);
    emit(UpdateProductUsingSubCategorySuccessState(
        products: response.data!, subCategoryId: subid));
  }

  void updateState(String state) {
    final districtList = StateDistricts.getDistrictList(state);
    emit(GetDistrictListState(districtList));
  }

  void updateDistrict(String district) {
    emit(UpdateDistrictState(district));
  }

  void saveAddress(Address address,
      {required bool isUpdate, bool isShipping = true}) async {
    try {
      emit(SaveAddressLoadingState());
      final userId = CubitsInjector.authCubit.currentUser!.id;
      final response = (await HomeRepo.saveAddress(address,
          userId: userId, isShipping: isShipping));
      CubitsInjector.authCubit.fetchCurrentUser();
      emit(UpdateAddressState());
    } on DioException catch (e) {
      emit(SaveAddressFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(SaveAddressFailedState(AppStrings.somethingWentWrong));
    }
  }

  void fetchStoreData() async {
    try {
      emit(FetchStoreDataLoadingState());
      final response =
          await HomeRepo.getStoreData(CubitsInjector.authCubit.currentUser?.id);
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
      print('e----$e');
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
        final localItems = CartHelper.getAllProducts();

        for (var product in response.data!) {
          final cartItems =
              localItems.where((e) => product.productId == e['productId']);

          for (var cartItem in cartItems) {
            final variantTitle = product.variant?.variantTitle;
            final selectedVariantString = cartItem[variantTitle];
            final selectedVariant =
                product.variant?.variantOptions.firstWhereOrNull(
              (option) => option.name == selectedVariantString,
            );

            final cartProduct = Product_new(
              productId: product.productId,
              productName: product.productName,
              productCategory: product.productCategory,
              productImage: product.productImage,
              price: product.price,
              quantity: cartItem['quantity'] ?? 0,
              variant: selectedVariant != null
                  ? product.variant!.copyWith(selectedVariant)
                  : product.variant,
              categoryId: product.categoryId,
            );

            cartProducts.add(cartProduct);
          }
        }

        emit(FetchCartSuccessState());
        updateCartBilling();
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

  void updateCartProductList(int productId, {Variant? variant}) {
    if (variant != null) {
      cartProducts.removeWhere((element) =>
          element.productId == productId &&
          element.variant?.selectedVariant.name ==
              variant.selectedVariant.name);
    } else {
      cartProducts.removeWhere((element) => element.productId == productId);
    }
    emit(FetchCartSuccessState());
    updateCartBilling();
  }

  void fetchProductDetails(int productId) async {
    try {
      emit(FetchProductDetailsLoadingState());
      final response = await HomeRepo.fetchProductDetails(productId);
      productDetail = response.data;
      print("e---${response.data!.price}");

      emit(FetchProductDetailsSuccessState(product: response.data!));
    } on DioException catch (e) {
      print(e);
      emit(FetchProductDetailsFailedState(
          message: e.message ?? AppStrings.somethingWentWrong));
    } catch (e) {
      print(e);
      emit(FetchProductDetailsFailedState(
          message: AppStrings.somethingWentWrong));
    }
  }

  void fetchOrderhistory() async {
    try {
      emit(FetchOrdersLoadingState());
      final response = await HomeRepo.fetchOrderHistory();

      emit(FetchOrdersSuccessState(orders: response.data ?? []));
    } on DioException catch (e) {
      emit(FetchOrdersFailedState(
          message: e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(FetchOrdersFailedState(message: AppStrings.somethingWentWrong));
    }
  }

  void fetchOrderDetails(int orderId) async {
    try {
      emit(FetchOrderDetailsLoadingState());
      final response = await AdminOrderRepo.fetchOrderDetails(orderId);
      emit(FetchOrderDetailsSuccessState(orderDetails: response.data!));
    } on DioException catch (e) {
      emit(FetchOrderDetailsFailedState());
    } catch (e) {
      emit(FetchOrderDetailsFailedState());
    }
  }

  void updateCartBilling() {
    final cartProductsCount = cartProducts.fold(
        0, (previousValue, element) => previousValue + element.quantity);
    final num cartAmount = cartProducts.fold(
        0,
        (previousValue, element) =>
            previousValue + (element.getPrice() * element.quantity));
    log("${cartProductsCount}  ${cartAmount}");
    emit(UpdateCartBillingState(
        itemCount: cartProductsCount, amount: cartAmount));
  }

  void resetCart() {
    cartProducts.clear();
  }

  void placeOrder() async {
    try {
      emit(PlaceOrderLoadingState());
      final response = await HomeRepo.placeOrder(cartProducts,
          shippingAddress:
              CubitsInjector.authCubit.currentUser!.shippingAddress!,
          billingAddress:
              CubitsInjector.authCubit.currentUser!.billingAddress!);
      if (response.status) {
        CartHelper.clear();
        emit(PlaceOrderSuccessState());
      } else {
        emit(PlaceOrderFailedState(message: response.message));
      }
    } on DioException catch (e) {
      emit(PlaceOrderFailedState(
          message: e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(PlaceOrderFailedState(message: AppStrings.somethingWentWrong));
    }
  }

  void showCategoryWidget(Category category) {
    emit(UpdateHomeWidgetState(category: category));
  }

  void showHomeWidget() {
    emit(ShowHomeWidget());
  }

  void clear() {
    _storeData = null;
    cartProducts.clear();
  }

  void updateProductVariant(int productId,
      {required VariantOption selectedVariant}) async {
    emit(UpdateProductVariantLoadingState(
        id: productId, selectedVariant: selectedVariant));
    await Future.delayed(const Duration(milliseconds: 100));
    emit(UpdateProductVariantState(
        id: productId, selectedVariant: selectedVariant));
  }
}
