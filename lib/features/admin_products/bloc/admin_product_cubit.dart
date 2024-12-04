import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/admin_products/model/admin_product.dart';
import 'package:mafatlal_ecommerce/features/admin_products/model/organisation_model.dart';
import 'package:mafatlal_ecommerce/features/admin_products/repo/admin_products_repo.dart';
import 'package:mafatlal_ecommerce/features/auth/repo/auth_repo.dart';
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

  void updateSelectedOrganisation(DataObject organisation) {
    emit(UpdateSelectedOrganisationState(organisation));
  }

  void updateSelectedCategory(DataObject category) {
    emit(UpdateSelectedCategoryState(category));
  }

  void updateSelectedSubCategory(DataObject subCategory) {
    emit(UpdateSelectedSubCategoryState(subCategory));
  }

  void fetchCategories() async {
    try {
      emit(FetchCategoryLoadingState());
      final response = await AdminProductRepo.fetchCategories(
        CubitsInjector.authCubit.currentUser!.id,
      );
      emit(FetchCategorySuccessState(
        response.data ?? [],
      ));
    } on DioException catch (e) {
      emit(FetchCategoriesErrorState(
          e.message ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(FetchCategoriesErrorState(e.toString()));
    }
  }

  void fetchSubCategories(int categoryId) async {
    try {
      emit(FetchSubCategoriesLoadingState());
      final response = await AdminProductRepo.fetchSubCategories(
          CubitsInjector.authCubit.currentUser!.id,
          categoryId: categoryId);
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

  void updateProductimageState() {
    emit(UpdateProductImageState());
  }

  void addProduct({
    required String name,
    required String description,
    required List images,
    int? categoryId,
    int? subCategoryId,
    int? orgId,
    required int price,
    required double gstPercentage,
    List<AdminVariantOption>? sizes,
  }) async {
    try {
      emit(AddProductLoadingState());
      List<String> imageUrl = [];
      for (var image in images) {
        if (image is MediaInfo) {
          final imgUrl = (await AuthRepo.uploadImage(image)).data;
          if (imgUrl != null) {
            imageUrl.add(imgUrl);
          }
        } else if (image is String) {
          imageUrl.add(image);
        }
      }
      if (imageUrl.isEmpty) {
        throw Exception();
      }
      Map<String, int> size = {};
      if (sizes?.isNotEmpty == true) {
        for (var element in sizes!) {
          size[element.name] = element.price;
        }
      }
      await AdminProductRepo.addProduct(
          CubitsInjector.authCubit.currentUser!.id,
          name: name,
          description: description,
          imageUrl: imageUrl,
          price: price,
          orgId: orgId,
          categoryId: categoryId,
          subCategoryId: subCategoryId,
          gstPercentage: gstPercentage,
          size: size);
      emit(AddProductSuccessState());
    } on DioException catch (e) {
      emit(AddProductErrorState(e.message ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(AddProductErrorState(AppStrings.somethingWentWrong));
    }
  }

  void updateProduct({
    required int productId,
    required String name,
    required String description,
    required List images,
    int? categoryId,
    int? subCategoryId,
    int? orgId,
    required int price,
    required double gstPercentage,
    List<AdminVariantOption>? sizes,
  }) async {
    try {
      emit(AddProductLoadingState());
      List<String> imageUrl = [];
      for (var image in images) {
        if (image is MediaInfo) {
          final imgUrl = (await AuthRepo.uploadImage(image)).data;
          if (imgUrl != null) {
            imageUrl.add(imgUrl);
          }
        } else if (image is String) {
          imageUrl.add(image);
        }
      }
      if (imageUrl.isEmpty) {
        throw Exception();
      }
      Map<String, int> size = {};
      if (sizes?.isNotEmpty == true) {
        for (var element in sizes!) {
          size[element.name] = element.price;
        }
      }
      await AdminProductRepo.updateProduct(
          CubitsInjector.authCubit.currentUser!.id,
          productId: productId,
          name: name,
          description: description,
          imageUrl: imageUrl,
          price: price,
          orgId: orgId,
          categoryId: categoryId,
          subCategoryId: subCategoryId,
          gstPercentage: gstPercentage,
          size: size);
      emit(AddProductSuccessState());
    } on DioException catch (e) {
      emit(AddProductErrorState(e.message ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(AddProductErrorState(AppStrings.somethingWentWrong));
    }
  }

  void deleteProduct(int productId) async {
    try {
      emit(AddProductLoadingState());

      await AdminProductRepo.deleteProduct(
          userId: CubitsInjector.authCubit.currentUser!.id,
          productId: productId);
      emit(AddProductSuccessState());
    } on DioException catch (e) {
      emit(AddProductErrorState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(AddProductErrorState(AppStrings.somethingWentWrong));
    }
  }

  void showError(String msg) {
    emit(AddProductErrorState(msg));
  }
}
