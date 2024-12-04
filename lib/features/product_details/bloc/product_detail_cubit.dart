import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/features/home/model/product.dart';
import 'package:mafatlal_ecommerce/features/home/model/productdetial_model.dart';
import 'package:mafatlal_ecommerce/features/home/repo/home_repo.dart';
import 'package:mafatlal_ecommerce/features/product_details/bloc/product_detail_state.dart';
import 'package:mafatlal_ecommerce/services/dio_utils_service.dart';

class ProductDetailsCubit extends Cubit<ProductDetailState> {
  ProductDetailsCubit() : super(ProductDetailInitialState());

  ProductDetail? productDetail;

  void fetchProductDetails(int productId) async {
    try {
      emit(FetchProductDetailsLoadingState());
      final response = await HomeRepo.fetchProductDetails(productId);
      productDetail = response.data;
      print("e---${response.data!.price}");

      emit(FetchProductDetailsSuccessState(product: response.data!));
    } on DioException catch (e) {
      print(e);
      emit(FetchProductDetailsFailedState(
          message: e.message ?? AppStrings.somethingWentWrong));
    } catch (e) {
      print(e);
      emit(FetchProductDetailsFailedState(
          message: AppStrings.somethingWentWrong));
    }
  }

  void updateProductVariant(int productId,
      {required VariantOption selectedVariant}) async {
    emit(UpdateProductVariantLoadingState(
        id: productId, selectedVariant: selectedVariant));
    await Future.delayed(const Duration(milliseconds: 100));
    emit(UpdateProductVariantState(
        id: productId, selectedVariant: selectedVariant));
  }
}
