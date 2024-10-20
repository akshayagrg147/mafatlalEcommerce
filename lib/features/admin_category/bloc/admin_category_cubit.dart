import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/admin_category/bloc/admin_category_state.dart';
import 'package:mafatlal_ecommerce/features/admin_category/repository/admin_cat_repo.dart';
import 'package:mafatlal_ecommerce/features/auth/repo/auth_repo.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/district_model.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/state_model.dart';

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

  void addCategory(String name) async {
    try {
      emit(AddCategoryLoadingState());

      await AdminCatRepo.addCategory(
        CubitsInjector.authCubit.currentUser!.id,
        categoryName: name,
      );
      emit(AddCategorySuccessState());
    } on DioException catch (e) {
      emit(AddCategoryFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(AddCategoryFailedState(AppStrings.somethingWentWrong));
    }
  }

  void addSubCategory(int categoryId,
      {required String name,
      required MediaInfo image,
      MediaInfo? bannerImage}) async {
    try {
      emit(AddSubCategoryLoadingState());
      final imgUrl = (await AuthRepo.uploadImage(image)).data;
      String? bannerImgurl;
      if (bannerImage != null) {
        bannerImgurl = (await AuthRepo.uploadImage(bannerImage)).data;
      }
      await AdminCatRepo.addSubCategory(
          CubitsInjector.authCubit.currentUser!.id,
          categoryId: categoryId,
          subCategoryName: name,
          bannerImageUrl: bannerImgurl,
          imageUrl: imgUrl!);
      emit(AddSubCategorySuccessState());
    } on DioException catch (e) {
      emit(AddSubCategoryFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(AddSubCategoryFailedState(AppStrings.somethingWentWrong));
    }
  }

  void updateCategory(
    String name, {
    required int categoryId,
  }) async {
    try {
      emit(AddCategoryLoadingState());
      // String? imgUrl;
      // if (image != null) {
      //   imgUrl = (await AuthRepo.uploadImage(image)).data;
      // } else {
      //   imgUrl = img;
      // }
      //
      // if (imgUrl == null) {
      //   throw Exception();
      // }

      await AdminCatRepo.updateCategory(
        CubitsInjector.authCubit.currentUser!.id,
        categoryId: categoryId,
        categoryName: name,
      );
      emit(AddCategorySuccessState());
    } on DioException catch (e) {
      emit(AddCategoryFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(AddCategoryFailedState(AppStrings.somethingWentWrong));
    }
  }

  void updateSubCategory(String name,
      {required int subCategoryId,
      MediaInfo? image,
      String? img,
      MediaInfo? bannerImage,
      String? bannerImg}) async {
    try {
      emit(AddSubCategoryLoadingState());
      String? imgUrl;
      String? bannerImgUrl;
      if (image != null) {
        imgUrl = (await AuthRepo.uploadImage(image)).data;
      } else {
        imgUrl = img;
      }

      if (imgUrl == null) {
        throw Exception();
      }
      if (bannerImage != null) {
        bannerImgUrl = (await AuthRepo.uploadImage(bannerImage)).data;
      } else {
        bannerImgUrl = bannerImg;
      }
      await AdminCatRepo.updateSubCategory(
          CubitsInjector.authCubit.currentUser!.id,
          subCategoryId: subCategoryId,
          subCategoryName: name,
          imageUrl: imgUrl,
          bannerImgUrl: bannerImgUrl);
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

  void addOrganisation(String name,
      {StateModel? state, DistrictModel? district}) async {
    try {
      emit(AddOrganisationLoadingState());

      await AdminCatRepo.addOrganisation(
          CubitsInjector.authCubit.currentUser!.id,
          organisationName: name,
          stateId: state?.id,
          districtId: district?.id);
      emit(AddOrganisationSuccessState());
    } on DioException catch (e) {
      emit(AddOrganisationFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(AddOrganisationFailedState(AppStrings.somethingWentWrong));
    }
  }

  void updateOrganisation(String name,
      {required int organisationId,
      StateModel? state,
      DistrictModel? district}) async {
    try {
      emit(AddOrganisationLoadingState());

      await AdminCatRepo.updateOrganisation(
          CubitsInjector.authCubit.currentUser!.id,
          organisationId: organisationId,
          organisationName: name,
          stateId: state?.id,
          districtId: district?.id);
      emit(AddOrganisationSuccessState());
    } on DioException catch (e) {
      emit(AddOrganisationFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(AddOrganisationFailedState(AppStrings.somethingWentWrong));
    }
  }

  void deleteOrganisation(int organisationId) async {
    try {
      emit(AddOrganisationLoadingState());

      await AdminCatRepo.deleteOrganisation(organisationId);
      emit(AddOrganisationSuccessState());
    } on DioException catch (e) {
      emit(AddOrganisationFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(AddOrganisationFailedState(AppStrings.somethingWentWrong));
    }
  }

  void showErrorMessage(AdminCategoryState state) {
    emit(state);
  }

  void fetchStates() async {
    try {
      emit(FetchStatesLoadingState());
      final response = await AdminCatRepo.getAllStates();
      emit(FetchStatesSuccessState(states: response.data ?? []));
    } on DioException catch (e) {
      emit(FetchStatesFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(FetchStatesFailedState(AppStrings.somethingWentWrong));
    }
  }

  void selectState(StateModel state) {
    emit(UpdateSelectedState(state: state));
  }

  void fetchDistricts(int stateId) async {
    try {
      emit(FetchDistrictsLoadingState());
      final response = await AdminCatRepo.getDistrictsByStateId(stateId);
      emit(FetchDistrictsSuccessState(districts: response.data ?? []));
    } on DioException catch (e) {
      emit(FetchDistrictsFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(FetchDistrictsFailedState(AppStrings.somethingWentWrong));
    }
  }

  void selectDistrict(DistrictModel district) {
    emit(UpdateSelectedDistrict(district: district));
  }
}
