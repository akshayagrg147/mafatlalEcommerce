import 'package:mafatlal_ecommerce/features/admin_category/model/admin_cat_model.dart';

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
