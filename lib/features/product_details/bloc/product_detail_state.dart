import 'package:mafatlal_ecommerce/features/home/model/product.dart';
import 'package:mafatlal_ecommerce/features/home/model/productdetial_model.dart';

abstract class ProductDetailState {}

class ProductDetailInitialState extends ProductDetailState {}

class FetchProductDetailsLoadingState extends ProductDetailState {}

class FetchProductDetailsSuccessState extends ProductDetailState {
  final ProductDetail product;

  FetchProductDetailsSuccessState({required this.product});
}

class FetchProductDetailsFailedState extends ProductDetailState {
  final String message;

  FetchProductDetailsFailedState({required this.message});
}

class UpdateProductVariantState extends ProductDetailState {
  final int id;
  final VariantOption selectedVariant;

  UpdateProductVariantState({required this.id, required this.selectedVariant});
}

class UpdateProductVariantLoadingState extends ProductDetailState {
  final int id;
  final VariantOption selectedVariant;

  UpdateProductVariantLoadingState(
      {required this.id, required this.selectedVariant});
}

// class Product
