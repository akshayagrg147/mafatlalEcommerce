import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/model/product.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/add_to_cart_btn.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/size_selection_widget.dart';

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
    return Container(
      decoration: BoxDecoration(
          color: AppColors.kWhite,
          border: Border.all(color: AppColors.kGrey200),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: AppColors.kGrey.withOpacity(.1),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(1, 1))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 6,
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: product.productImage.isNotEmpty ? product.productImage[0]['image_1'] ?? "" : "",
                  errorWidget: (context, url, error) => CachedNetworkImage(
                    imageUrl: "https://image.spreadshirtmedia.com/image-server/v1/products/T1412A330PA3703PT17X246Y19D1040247317W6640H6184/views/1,width=550,height=550,appearanceId=330,backgroundColor=F2F2F2,modelId=5186,crop=list/42-dont-panic-life-universe-everything-mens-pique-polo-shirt.jpg",
                    fit: BoxFit.fill,
                  ),
                  fit: BoxFit.contain,
                ),
              )),
          Expanded(
              flex: 4,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.productName,
                      maxLines: 2,
                      style: AppTextStyle.f16OutfitBlackW500,
                    ),
                    if (product.sizeAvailable.isNotEmpty)
                      SizeSelection(
                        onSizeSelected: (selectedSize) {
                          // product.selectedSize = selectedSize; // Assuming you've added a selectedSize property to the product class
                          // product.quantity = CartHelper.getProductQuantity(
                          //   product.productId,
                          //   selectedSize: product.selectedSize,


                          // Update the product variant in the cubit
                          // CubitsInjector.homeCubit.updateProductVariant(
                          //   product.productId,
                          //   selectedSize: product.selectedSize, // Pass the selected size directly
                          // );
                        },
                        sizeAvailable: product.sizeAvailable,
                      ),


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
                            // StreamBuilder<BoxEvent>(
                            //     stream: CartHelper.watchCart(
                            //         product.productId, product.variant),
                            //     builder: (context, eventSnapshot) {
                            //       if (eventSnapshot.hasData) {
                            //         final data =
                            //             eventSnapshot.data?.value ?? {};
                            //         product.quantity = data['quantity'] ?? 0;
                            //         // product.selectedSize = data['size'];
                            //       }
                            //       return AddToCartWidget(
                            //         quantity: product.quantity,
                            //         productId: product.productId,
                            //         variant: product.variant,
                            //       );
                            //     })
                          ],
                        );
                      },
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
