import 'package:mafatlal_ecommerce/features/admin_products/model/admin_product.dart';
import 'package:mafatlal_ecommerce/features/admin_products/model/organisation_model.dart';

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
  final DataObject organisation;

  UpdateSelectedOrganisationState(this.organisation);
}

class UpdateSelectedCategoryState extends AdminProductState {
  final DataObject category;

  UpdateSelectedCategoryState(this.category);
}

class UpdateSelectedSubCategoryState extends AdminProductState {
  final DataObject subCategory;

  UpdateSelectedSubCategoryState(this.subCategory);
}

class FetchOrganisationsLoadingState extends AdminProductState {}

class FetchOrganisationsSuccessState extends AdminProductState {
  final List<DataObject> organisations;

  FetchOrganisationsSuccessState(this.organisations);
}

class FetchOrganisationsErrorState extends AdminProductState {
  final String message;
  FetchOrganisationsErrorState(this.message);
}

class FetchCategoryLoadingState extends AdminProductState {}

class FetchCategorySuccessState extends AdminProductState {
  final List<DataObject> categories;

  FetchCategorySuccessState(this.categories);
}

class FetchCategoriesErrorState extends AdminProductState {
  final String message;
  FetchCategoriesErrorState(this.message);
}

class FetchSubCategoriesLoadingState extends AdminProductState {}

class FetchSubCategoriesSuccessState extends AdminProductState {
  final List<DataObject> subCategories;

  FetchSubCategoriesSuccessState(this.subCategories);
}

class FetchSubCategoriesErrorState extends AdminProductState {
  final String message;
  FetchSubCategoriesErrorState(this.message);
}

class UpdateProductImageState extends AdminProductState {}

class AddProductLoadingState extends AdminProductState {}

class AddProductSuccessState extends AdminProductState {}

class AddProductErrorState extends AdminProductState {
  final String message;
  AddProductErrorState(this.message);
}
