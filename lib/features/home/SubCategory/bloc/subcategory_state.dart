import 'package:mafatlal_ecommerce/features/home/SubCategory/model/district_model.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/organization_model.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/state_model.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';

abstract class SubCategoryDetailState {}

class SubCategoryDetailInitialState extends SubCategoryDetailState {}

class GetSubCategoryDetailScreenLoadingState extends SubCategoryDetailState {}

class GetSubCategoryDetailScreenFailedState extends SubCategoryDetailState {
  final String message;

  GetSubCategoryDetailScreenFailedState({required this.message});
}

class GetSubCategoryDetailScreenSuccessState extends SubCategoryDetailState {
  final List<SubCategory_new> subcategories;
  final String selectedname;

  GetSubCategoryDetailScreenSuccessState({
    required this.subcategories,
    required this.selectedname,
  });
}

class UpdateProductUsingSubCategorySuccessState extends SubCategoryDetailState {
  final List<Product_new> products;
  final Organization? organization;

  UpdateProductUsingSubCategorySuccessState(
      {required this.products, required this.organization});
}

class UpdateProductUsingSubCategoryLoadingState
    extends SubCategoryDetailState {}

class UpdateProductUsingSubCategoryFailedState extends SubCategoryDetailState {}

class GetAllStateSuccessState extends SubCategoryDetailState {
  final List<StateModel> states;
  final String name;

  GetAllStateSuccessState({required this.states, required this.name});
}

class GetAllStateFailedState extends SubCategoryDetailState {
  final String message;

  GetAllStateFailedState({required this.message});
}

class GetAllStateLoadingState extends SubCategoryDetailState {}

class GetAllDistrictSuccessState extends SubCategoryDetailState {
  final List<DistrictModel> district;
  final String name;

  GetAllDistrictSuccessState({required this.district, required this.name});
}

class GetAllDistrictFailedState extends SubCategoryDetailState {
  final String message;

  GetAllDistrictFailedState({required this.message});
}

class GetAllDistrictLoadingState extends SubCategoryDetailState {}

class GetAllOrganizationSuccessState extends SubCategoryDetailState {
  final List<Organization> organization;
  final String name;

  GetAllOrganizationSuccessState(
      {required this.organization, required this.name});
}

class GetAllOrganizationFailedState extends SubCategoryDetailState {
  final String message;

  GetAllOrganizationFailedState({required this.message});
}

class GetAllOrganizationLoadingState extends SubCategoryDetailState {}
