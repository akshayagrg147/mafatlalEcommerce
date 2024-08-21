import 'package:mafatlal_ecommerce/features/home/model/category_model.dart';
import 'package:mafatlal_ecommerce/features/home/model/order.dart';
import 'package:mafatlal_ecommerce/features/home/model/product.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class FetchStoreDataLoadingState extends HomeState {}

class FetchStoreDataSuccessState extends HomeState {}

class FetchStoreDataFailedState extends HomeState {
  final String message;

  FetchStoreDataFailedState(this.message);
}

class FetchSubcategoryProductsLoadingState extends HomeState {
  final int subCategoryId;

  FetchSubcategoryProductsLoadingState(this.subCategoryId);
}

class FetchSubcategoryProductsSuccessState extends HomeState {
  final List<Product> products;
  final int subCategoryId;

  FetchSubcategoryProductsSuccessState(this.subCategoryId,
      {required this.products});
}

class FetchSubcategoryProductsFailedState extends HomeState {
  final String message;
  final int subCategoryId;
  FetchSubcategoryProductsFailedState(this.message,
      {required this.subCategoryId});
}

class GetDistrictListState extends HomeState {
  final List<String> districts;

  GetDistrictListState(this.districts);
}

class UpdateDistrictState extends HomeState {
  final String district;

  UpdateDistrictState(this.district);
}

class UpdateAddressState extends HomeState {}

class PlaceOrderLoadingState extends HomeState {}

class PlaceOrderSuccessState extends HomeState {}

class PlaceOrderFailedState extends HomeState {
  final String message;

  PlaceOrderFailedState({required this.message});
}

class FetchCartLoadingState extends HomeState {}

class FetchCartSuccessState extends HomeState {}

class FetchCartFailedState extends HomeState {
  final String message;

  FetchCartFailedState({required this.message});
}

class UpdateCartBillingState extends HomeState {
  final int itemCount;
  final num amount;

  UpdateCartBillingState({required this.itemCount, required this.amount});
}

class FetchOrdersLoadingState extends HomeState {}

class FetchOrdersSuccessState extends HomeState {
  final List<Order> orders;

  FetchOrdersSuccessState({required this.orders});
}

class FetchOrdersFailedState extends HomeState {
  final String message;

  FetchOrdersFailedState({required this.message});
}

class UpdateHomeWidgetState extends HomeState {
  final Category category;

  UpdateHomeWidgetState({required this.category});
}

class ShowHomeWidget extends HomeState {}
