import 'package:mafatlal_ecommerce/features/admin_products/model/admin_product.dart';
import 'package:mafatlal_ecommerce/features/admin_products/model/organisation_model.dart';
import 'package:mafatlal_ecommerce/features/admin_products/model/subcategory_model.dart';

abstract class AdminProductState {}

class AdminProductInitial extends AdminProductState {}

class FetchProductsLoadingState extends AdminProductState {}

class FetchProductsSuccessState extends AdminProductState {
  final List<AdminProduct> products;

  FetchProductsSuccessState(this.products);
}

class FetchProductsErrorState extends AdminProductState {
  final String message;
  FetchProductsErrorState(this.message);
}

class UpdateSelectedOrganisationState extends AdminProductState {
  final Organisation organisation;

  UpdateSelectedOrganisationState(this.organisation);
}

class UpdateSelectedSubCategoryState extends AdminProductState {
  final SubCategory subCategory;

  UpdateSelectedSubCategoryState(this.subCategory);
}

class FetchOrganisationsLoadingState extends AdminProductState {}

class FetchOrganisationsSuccessState extends AdminProductState {
  final List<Organisation> organisations;

  FetchOrganisationsSuccessState(this.organisations);
}

class FetchOrganisationsErrorState extends AdminProductState {
  final String message;
  FetchOrganisationsErrorState(this.message);
}

class FetchSubCategoriesLoadingState extends AdminProductState {}

class FetchSubCategoriesSuccessState extends AdminProductState {
  final List<SubCategory> subCategories;

  FetchSubCategoriesSuccessState(this.subCategories);
}

class FetchSubCategoriesErrorState extends AdminProductState {
  final String message;
  FetchSubCategoriesErrorState(this.message);
}
