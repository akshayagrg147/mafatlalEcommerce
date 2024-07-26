import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/model/subcategory_model.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/product_grid_tile.dart';

class SubCategoryProductTab extends StatelessWidget {
  final SubCategory subCategory;

  const SubCategoryProductTab({super.key, required this.subCategory});

  @override
  Widget build(BuildContext context) {
    CubitsInjector.homeCubit.fetchProductsBySubcategoryId(subCategory.id);
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          (current is FetchSubcategoryProductsLoadingState ||
              current is FetchSubcategoryProductsSuccessState ||
              current is FetchSubcategoryProductsFailedState) &&
          (current as dynamic).subCategoryId == subCategory.id,
      builder: (context, state) {
        if (state is FetchSubcategoryProductsLoadingState) {
          return const LoadingAnimation();
        }
        if (state is FetchSubcategoryProductsSuccessState &&
            state.products.isNotEmpty) {
          return Container(
              padding: EdgeInsets.only(
                  left: 8 * SizeConfig.widthMultiplier,
                  right: 8 * SizeConfig.widthMultiplier,
                  top: 12 * SizeConfig.heightMultiplier,
                  bottom: 5 * SizeConfig.heightMultiplier),
              color: AppColors.kGrey50,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Wrap(
                  runSpacing: 8 * SizeConfig.heightMultiplier,
                  spacing: 8 * SizeConfig.widthMultiplier,
                  children: List.generate(
                      state.products.length,
                      (index) => ProductGridTile.subList(
                          product: state.products[index])),
                ),
              ));
        }
        return Center(
          child: Text(
            "No Data",
            style: AppTextStyle.f20GreyW600,
          ),
        );
      },
    );
  }
}
