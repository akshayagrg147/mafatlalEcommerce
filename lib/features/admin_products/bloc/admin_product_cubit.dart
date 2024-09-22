import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/admin_products/model/organisation_model.dart';
import 'package:mafatlal_ecommerce/features/admin_products/repo/admin_products_repo.dart';
import 'package:mafatlal_ecommerce/services/dio_utils_service.dart';

import 'admin_product_state.dart';

class AdminProductCubit extends Cubit<AdminProductState> {
  AdminProductCubit() : super(AdminProductInitial());

  void getProducts() async {
    try {
      emit(FetchProductsLoadingState());
      final response = await AdminProductRepo.fetchProducts(
          CubitsInjector.authCubit.currentUser!.id);
      emit(FetchProductsSuccessState(
        response.data ?? [],
      ));
    } on DioException catch (e) {
      emit(FetchProductsErrorState(e.message ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(FetchProductsErrorState(e.toString()));
    }
  }

  void fetchOrganizations() async {
    try {
      emit(FetchOrganisationsLoadingState());
      final response = await AdminProductRepo.fetchOrganisations(
          CubitsInjector.authCubit.currentUser!.id);
      emit(FetchOrganisationsSuccessState(response.data ?? []));
    } on DioException catch (e) {
      emit(FetchOrganisationsErrorState(
          e.message ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(FetchOrganisationsErrorState(e.toString()));
    }
  }

  void updateSelectedOrganisation(Organisation organisation) {
    emit(UpdateSelectedOrganisationState(organisation));
  }

  void fetchSubCategories(int organisationId) async {
    try {
      emit(FetchSubCategoriesLoadingState());
      final response = await AdminProductRepo.fetchSubCategories(
          CubitsInjector.authCubit.currentUser!.id,
          organisationId: organisationId);
      emit(FetchSubCategoriesSuccessState(
        response.data ?? [],
      ));
    } on DioException catch (e) {
      emit(FetchSubCategoriesErrorState(
          e.message ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(FetchSubCategoriesErrorState(e.toString()));
    }
  }
}
