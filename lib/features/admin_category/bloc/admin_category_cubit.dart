import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/admin_category/bloc/admin_category_state.dart';
import 'package:mafatlal_ecommerce/features/admin_category/repository/admin_cat_repo.dart';
import 'package:mafatlal_ecommerce/features/auth/repo/auth_repo.dart';

class AdminCategoryCubit extends Cubit<AdminCategoryState> {
  AdminCategoryCubit() : super(AdminCategoryInitial());

  void fetchCategories() async {
    try {
      emit(FetchCategoriesLoadingState());
      final response = await AdminCatRepo.fetchCategories(
          CubitsInjector.authCubit.currentUser!.id);
      emit(FetchCategoriesSuccessState(categories: response.data ?? []));
    } on DioException catch (e) {
      emit(FetchCategoriesFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(FetchCategoriesFailedState(AppStrings.somethingWentWrong));
    }
  }

  void fetchSubCategories(int categoryId) async {
    try {
      emit(FetchSubCategoriesLoadingState());
      final response = await AdminCatRepo.fetchSubCategories(
          CubitsInjector.authCubit.currentUser!.id,
          categoryId: categoryId);
      emit(FetchSubCategoriesSuccessState(subCategories: response.data ?? []));
    } on DioException catch (e) {
      emit(FetchSubCategoriesFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(FetchSubCategoriesFailedState(AppStrings.somethingWentWrong));
    }
  }

  void fetchOrganisation() async {
    try {
      emit(FetchOrganisationLoadingState());
      final response = await AdminCatRepo.fetchOrganisation(
        CubitsInjector.authCubit.currentUser!.id,
      );
      emit(FetchOrganisationSuccessState(organisations: response.data ?? []));
    } on DioException catch (e) {
      emit(FetchOrganisationFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(FetchOrganisationFailedState(AppStrings.somethingWentWrong));
    }
  }

  void addCategory(String name, {required XFile image}) async {
    try {
      emit(AddCategoryLoadingState());
      final imgUrl = (await AuthRepo.uploadImage(image)).data;

      await AdminCatRepo.addCategory(CubitsInjector.authCubit.currentUser!.id,
          categoryName: name, imageUrl: imgUrl!);
      emit(AddCategorySuccessState());
    } on DioException catch (e) {
      emit(AddCategoryFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(AddCategoryFailedState(AppStrings.somethingWentWrong));
    }
  }

  void addSubCategory(int categoryId,
      {required String name, required XFile image}) async {
    try {
      emit(AddSubCategoryLoadingState());
      final imgUrl = (await AuthRepo.uploadImage(image)).data;

      await AdminCatRepo.addSubCategory(
          CubitsInjector.authCubit.currentUser!.id,
          categoryId: categoryId,
          subCategoryName: name,
          imageUrl: imgUrl!);
      emit(AddSubCategorySuccessState());
    } on DioException catch (e) {
      emit(AddSubCategoryFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(AddSubCategoryFailedState(AppStrings.somethingWentWrong));
    }
  }

  void updateCategory(String name,
      {required int categoryId, XFile? image, String? img}) async {
    try {
      emit(AddCategoryLoadingState());
      String? imgUrl;
      if (image != null) {
        imgUrl = (await AuthRepo.uploadImage(image)).data;
      } else {
        imgUrl = img;
      }

      if (imgUrl == null) {
        throw Exception();
      }

      await AdminCatRepo.updateCategory(
          CubitsInjector.authCubit.currentUser!.id,
          categoryId: categoryId,
          categoryName: name,
          imageUrl: imgUrl);
      emit(AddCategorySuccessState());
    } on DioException catch (e) {
      emit(AddCategoryFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(AddCategoryFailedState(AppStrings.somethingWentWrong));
    }
  }

  void updateSubCategory(String name,
      {required int subCategoryId, XFile? image, String? img}) async {
    try {
      emit(AddSubCategoryLoadingState());
      String? imgUrl;
      if (image != null) {
        imgUrl = (await AuthRepo.uploadImage(image)).data;
      } else {
        imgUrl = img;
      }

      if (imgUrl == null) {
        throw Exception();
      }

      await AdminCatRepo.updateSubCategory(
          CubitsInjector.authCubit.currentUser!.id,
          subCategoryId: subCategoryId,
          subCategoryName: name,
          imageUrl: imgUrl);
      emit(AddSubCategorySuccessState());
    } on DioException catch (e) {
      emit(AddSubCategoryFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(AddSubCategoryFailedState(AppStrings.somethingWentWrong));
    }
  }

  void deleteCategory(int categoryId) async {
    try {
      emit(AddCategoryLoadingState());
      await AdminCatRepo.deleteCategory(categoryId);
      emit(AddCategorySuccessState());
    } on DioException catch (e) {
      emit(AddCategoryFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(AddCategoryFailedState(AppStrings.somethingWentWrong));
    }
  }

  void deleteSubCategory(int subCategoryId) async {
    try {
      emit(AddSubCategoryLoadingState());
      await AdminCatRepo.deleteSubCategory(subCategoryId);
      emit(AddSubCategorySuccessState());
    } on DioException catch (e) {
      emit(AddSubCategoryFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(AddSubCategoryFailedState(AppStrings.somethingWentWrong));
    }
  }
}
