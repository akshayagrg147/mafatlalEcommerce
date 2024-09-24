import 'package:mafatlal_ecommerce/features/admin_orders/model/order_detail.dart';
import 'package:mafatlal_ecommerce/features/home/model/category_model.dart';
import 'package:mafatlal_ecommerce/features/home/model/order.dart';
import 'package:mafatlal_ecommerce/features/home/model/product.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';

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
  final List<Product_new> products;
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

class AddressLoadingState extends HomeState {}

class AddressFailedState extends HomeState {}

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

class UpdateProductVariantState extends HomeState {
  final int id;
  final VariantOption selectedVariant;

  UpdateProductVariantState({required this.id, required this.selectedVariant});
}

class UpdateProductVariantLoadingState extends HomeState {
  final int id;
  final VariantOption selectedVariant;

  UpdateProductVariantLoadingState(
      {required this.id, required this.selectedVariant});
}

class SaveAddressLoadingState extends HomeState {}

class SaveAddressFailedState extends HomeState {
  final String message;

  SaveAddressFailedState(this.message);
}

class GetSubCategorySuccessState extends HomeState {}

class GetSubCategoryFailedState extends HomeState {}

class GetSubCategoryLoadingState extends HomeState {}

class SearchInitialState extends HomeState {}

class SearchLoadingState extends HomeState {}

class SearchSuccessState extends HomeState {
  final List<Category_new> organisations;

  SearchSuccessState({required this.organisations});
}

class SearchFailedState extends HomeState {
  final String message;

  SearchFailedState({required this.message});
}

class FetchOrderDetailsLoadingState extends HomeState {}

class FetchOrderDetailsSuccessState extends HomeState {
  final OrderDetailModel orderDetails;

  FetchOrderDetailsSuccessState({required this.orderDetails});
}

class FetchOrderDetailsFailedState extends HomeState {}

class FetchProductDetailsLoadingState extends HomeState {}

class FetchProductDetailsSuccessState extends HomeState {
  final Product_new product;

  FetchProductDetailsSuccessState({required this.product});
}

class FetchProductDetailsFailedState extends HomeState {
  final String message;

  FetchProductDetailsFailedState({required this.message});
}

class UpdateSubCategoryLoadingState extends HomeState {}

class UpdateSubCategorySuccessState extends HomeState {
  final List<SubCategory_new> subcategoy;

  UpdateSubCategorySuccessState({required this.subcategoy});
}

class UpdateSubCategoryFailedState extends HomeState {}

class UpdateProductUsingSubCategorySuccessState extends HomeState {
  final List<Product_new> products;
  final int subCategoryId;

  UpdateProductUsingSubCategorySuccessState(
      {required this.products, required this.subCategoryId});
}

class UpdateProductUsingSubCategoryLoadingState extends HomeState {}

class UpdateProductUsingSubCategoryFailedState extends HomeState {}

class UpdateLabelSuccessState extends HomeState {
  final String selectedCategoryName;

  UpdateLabelSuccessState({required this.selectedCategoryName});
}
