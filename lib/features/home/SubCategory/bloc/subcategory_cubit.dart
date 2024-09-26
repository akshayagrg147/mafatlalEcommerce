import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/bloc/subcategory_state.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/organization_model.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/repo/subcategory_repo.dart';

class SubcategoryCubit extends Cubit<SubCategoryDetailState> {
  SubcategoryCubit() : super(SubCategoryDetailInitialState());

  void selectSubCategory(Organization? newSubCategory) {
    final currentState = state;
    if (currentState is GetSubCategoryDetailScreenSuccessState) {
      emit(GetSubCategoryDetailScreenSuccessState(
        organizations: currentState.organizations,
        selectedSubCategory: newSubCategory,
        selectedDistrict: currentState.selectedDistrict,
        selectedState: currentState.selectedState,
        selectedOrganization: currentState.selectedOrganization,
      ));
    }
  }

  void selectDistrict(Organization? newDistrict) {
    final currentState = state;
    if (currentState is GetSubCategoryDetailScreenSuccessState) {
      emit(GetSubCategoryDetailScreenSuccessState(
        organizations: currentState.organizations,
        selectedSubCategory: currentState.selectedSubCategory,
        selectedDistrict: newDistrict,
        selectedState: currentState.selectedState,
        selectedOrganization: currentState.selectedOrganization,
      ));
    }
  }

  void selectState(Organization? newState) {
    final currentState = state;
    if (currentState is GetSubCategoryDetailScreenSuccessState) {
      emit(GetSubCategoryDetailScreenSuccessState(
        organizations: currentState.organizations,
        selectedSubCategory: currentState.selectedSubCategory,
        selectedDistrict: currentState.selectedDistrict,
        selectedState: newState,
        selectedOrganization: currentState.selectedOrganization,
      ));
    }
  }

  void selectOrganization(Organization? newOrganization) {
    final currentState = state;
    if (currentState is GetSubCategoryDetailScreenSuccessState) {
      // Print the ID of the selected organization
      if (newOrganization != null) {
        print('Selected Organization ID: ${newOrganization.id}');
        UpdateproductAccordingtoCategory(newOrganization, currentState);
      }

      emit(GetSubCategoryDetailScreenSuccessState(
        organizations: currentState.organizations,
        selectedSubCategory: currentState.selectedSubCategory,
        selectedDistrict: currentState.selectedDistrict,
        selectedState: currentState.selectedState,
        selectedOrganization: newOrganization,
      ));
    }
  }

  Future<void> getsubcategorydetails(int subid) async {
    try {
      emit(GetSubCategoryDetailScreenLoadingState());
      final response = await SubCategoryRepo.getsubcateddetails(subid);
      emit(GetSubCategoryDetailScreenSuccessState(
        organizations: response,
      ));
    } on DioException catch (e) {
      emit(GetSubCategoryDetailScreenFailedState(
          message: e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(GetSubCategoryDetailScreenFailedState(
          message: AppStrings.somethingWentWrong));
    }
  }

  Future<void> UpdateproductAccordingtoCategory(Organization newOrganization,
      GetSubCategoryDetailScreenSuccessState currentState) async {
    emit(UpdateProductUsingSubCategoryLoadingState());
    final response =
        await SubCategoryRepo.getProductsBySubCatId(newOrganization.id);
    print(response);

    emit(UpdateProductUsingSubCategorySuccessState(
        products: response.data!, organization: newOrganization));
    emit(GetSubCategoryDetailScreenSuccessState(
      organizations: currentState.organizations,
      selectedSubCategory: currentState.selectedSubCategory,
      selectedDistrict: currentState.selectedDistrict,
      selectedState: currentState.selectedState,
      selectedOrganization: newOrganization,
    ));
  }
}
