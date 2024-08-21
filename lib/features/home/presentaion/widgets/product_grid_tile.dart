import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/features/home/model/product.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/add_to_cart_btn.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/size_selection_widget.dart';

class ProductGridTile extends StatelessWidget {
  final Product product;
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
                  imageUrl: product.productImage ?? "",
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
                    SizeSelection(
                        sizesAvailable: product.sizeAvailable.sizes ?? [],
                        selectedSize: product.selectedSize,
                        onSizeSelected: (size) {
                          product.selectedSize = size;
                          if (product.quantity > 0) {
                            CartHelper.updateProduct(
                                product.productId, size, product.quantity);
                          }
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "₹${product.price}",
                          style: AppTextStyle.f17OutfitBlackW500,
                        ),
                        StreamBuilder<BoxEvent>(
                            stream: CartHelper.watchCart(product.productId),
                            builder: (context, eventSnapshot) {
                              if (eventSnapshot.hasData) {
                                final data = eventSnapshot.data?.value ?? {};
                                product.quantity = data['quantity'] ?? 0;
                                product.selectedSize = data['size'];
                              }
                              return AddToCartWidget(
                                  quantity: product.quantity,
                                  productId: product.productId,
                                  productSize: product.selectedSize);
                            })
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
