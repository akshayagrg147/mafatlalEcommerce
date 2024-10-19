import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/add_to_cart_btn.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/size_selection_widget.dart';
import 'package:mafatlal_ecommerce/features/product_details/presentaion/product_details.dart';

class ProductGridTile extends StatelessWidget {
  final Product_new product;
  final Color bgColor;
  final double shadowOpacity;

  ProductGridTile({super.key, required this.product})
      : bgColor = AppColors.kGrey200,
        shadowOpacity = 0.5;

  const ProductGridTile.subList({super.key, required this.product})
      : bgColor = AppColors.kWhite,
        shadowOpacity = 0.2;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            ProductDetailsScreen.route,
            arguments: product.productId,
          );
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            boxShadow: [
              BoxShadow(
                color: Color(
                    0x1F004392), // #0043921F in Flutter's color format (with opacity)
                offset: Offset(0, 8), // X and Y offset for the shadow
                blurRadius: 24.0, // The blur effect for the shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 6,
                  child: CachedNetworkImage(
                    imageUrl: product.productImage.isNotEmpty
                        ? product.productImage.first
                        : "",
                    errorWidget: (context, url, error) => CachedNetworkImage(
                      imageUrl:
                          "https://image.spreadshirtmedia.com/image-server/v1/products/T1412A330PA3703PT17X246Y19D1040247317W6640H6184/views/1,width=550,height=550,appearanceId=330,backgroundColor=F2F2F2,modelId=5186,crop=list/42-dont-panic-life-universe-everything-mens-pique-polo-shirt.jpg",
                      fit: BoxFit.fill,
                    ),
                    fit: BoxFit.contain,
                  )),
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.productName,
                          maxLines: 2,
                          style: AppTextStyle.f16OutfitBlackW500,
                        ),
                        Text(
                          product.productOrganisation,
                          maxLines: 2,
                          style: AppTextStyle.f14OutfitBlackW500,
                        ),
                        if (product.variant != null)
                          SizeSelection(
                              variant: product.variant!,
                              onVariantSelected: (o) {
                                product.variant!.selectedVariant = o;
                                product.quantity =
                                    CartHelper.getProductQuantity(
                                        product.productId,
                                        variant: product.variant);
                                CubitsInjector.homeCubit.updateProductVariant(
                                    product.productId,
                                    selectedVariant:
                                        product.variant!.selectedVariant);
                              }),
                        BlocBuilder<HomeCubit, HomeState>(
                          buildWhen: (previous, current) =>
                              (current is UpdateProductVariantState &&
                                  current.id == product.productId) ||
                              (current is UpdateProductVariantLoadingState &&
                                  current.id == product.productId),
                          builder: (context, state) {
                            if (state is UpdateProductVariantLoadingState) {
                              return const SizedBox.shrink();
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "₹${product.price}",
                                  style: AppTextStyle.f17OutfitBlackW500,
                                ),
                                StreamBuilder<BoxEvent>(
                                    stream: CartHelper.watchCart(
                                        product.productId, product.variant),
                                    builder: (context, eventSnapshot) {
                                      if (eventSnapshot.hasData) {
                                        final data =
                                            eventSnapshot.data?.value ?? {};
                                        product.quantity =
                                            data['quantity'] ?? 0;
                                        // product.selectedSize = data['size'];
                                      }
                                      return AddToCartWidget(
                                        quantity: product.quantity,
                                        productId: product.productId,
                                        variant: product.variant,
                                        isGridTile: true,
                                      );
                                    })
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
