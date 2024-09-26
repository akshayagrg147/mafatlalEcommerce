import 'package:mafatlal_ecommerce/features/home/SubCategory/model/organization_model.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';

abstract class SubCategoryDetailState {}

class SubCategoryDetailInitialState extends SubCategoryDetailState {}

class GetSubCategoryDetailScreenLoadingState extends SubCategoryDetailState {}

class GetSubCategoryDetailScreenFailedState extends SubCategoryDetailState {
  final String message;
  GetSubCategoryDetailScreenFailedState({required this.message});
}

class GetSubCategoryDetailScreenSuccessState extends SubCategoryDetailState {
  final List<Organization> organizations;
  final Organization? selectedSubCategory;
  final Organization? selectedDistrict;
  final Organization? selectedState;
  final Organization? selectedOrganization;

  GetSubCategoryDetailScreenSuccessState({
    required this.organizations,
    this.selectedSubCategory,
    this.selectedDistrict,
    this.selectedState,
    this.selectedOrganization,
  });
}

class UpdateProductUsingSubCategorySuccessState extends SubCategoryDetailState {
  final List<Product_new> products;
  final Organization organization;

  UpdateProductUsingSubCategorySuccessState(
      {required this.products, required this.organization});
}

class UpdateProductUsingSubCategoryLoadingState
    extends SubCategoryDetailState {}

class UpdateProductUsingSubCategoryFailedState extends SubCategoryDetailState {}

class UpdateLabelSuccessState extends SubCategoryDetailState {
  final String selectedCategoryName;

  UpdateLabelSuccessState({required this.selectedCategoryName});
}
