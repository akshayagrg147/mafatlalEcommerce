import 'package:mafatlal_ecommerce/features/admin_category/model/admin_cat_model.dart';
import 'package:mafatlal_ecommerce/features/admin_category/model/admin_org-model.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/district_model.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/state_model.dart';

abstract class AdminCategoryState {}

class AdminCategoryInitial extends AdminCategoryState {}

class FetchCategoriesSuccessState extends AdminCategoryState {
  final List<AdminCategory> categories;

  FetchCategoriesSuccessState({required this.categories});
}

class FetchCategoriesFailedState extends AdminCategoryState {
  final String message;

  FetchCategoriesFailedState(this.message);
}

class FetchCategoriesLoadingState extends AdminCategoryState {}

class FetchSubCategoriesSuccessState extends AdminCategoryState {
  final List<AdminCategory> subCategories;

  FetchSubCategoriesSuccessState({required this.subCategories});
}

class FetchSubCategoriesFailedState extends AdminCategoryState {
  final String message;

  FetchSubCategoriesFailedState(this.message);
}

class FetchSubCategoriesLoadingState extends AdminCategoryState {}

class FetchOrganisationSuccessState extends AdminCategoryState {
  final List<AdminOrganisation> organisations;

  FetchOrganisationSuccessState({required this.organisations});
}

class FetchOrganisationFailedState extends AdminCategoryState {
  final String message;

  FetchOrganisationFailedState(this.message);
}

class FetchOrganisationLoadingState extends AdminCategoryState {}

class AddCategorySuccessState extends AdminCategoryState {}

class AddCategoryFailedState extends AdminCategoryState {
  final String message;

  AddCategoryFailedState(this.message);
}

class AddCategoryLoadingState extends AdminCategoryState {}

class AddSubCategorySuccessState extends AdminCategoryState {}

class AddSubCategoryFailedState extends AdminCategoryState {
  final String message;

  AddSubCategoryFailedState(this.message);
}

class AddSubCategoryLoadingState extends AdminCategoryState {}

class AddOrganisationSuccessState extends AdminCategoryState {}

class AddOrganisationFailedState extends AdminCategoryState {
  final String message;

  AddOrganisationFailedState(this.message);
}

class AddOrganisationLoadingState extends AdminCategoryState {}

class FetchStatesLoadingState extends AdminCategoryState {}

class FetchStatesSuccessState extends AdminCategoryState {
  final List<StateModel> states;

  FetchStatesSuccessState({required this.states});
}

class FetchStatesFailedState extends AdminCategoryState {
  final String message;

  FetchStatesFailedState(this.message);
}

class FetchDistrictsLoadingState extends AdminCategoryState {}

class FetchDistrictsSuccessState extends AdminCategoryState {
  final List<DistrictModel> districts;

  FetchDistrictsSuccessState({required this.districts});
}

class FetchDistrictsFailedState extends AdminCategoryState {
  final String message;

  FetchDistrictsFailedState(this.message);
}

class UpdateSelectedState extends AdminCategoryState {
  final StateModel state;

  UpdateSelectedState({required this.state});
}

class UpdateSelectedDistrict extends AdminCategoryState {
  final DistrictModel district;

  UpdateSelectedDistrict({required this.district});
}
