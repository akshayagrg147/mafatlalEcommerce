import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/features/home/model/product.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/add_to_cart_btn.dart';

class ProductListTile extends StatelessWidget {
  final Product product;

  const ProductListTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.kBlack.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
                color: AppColors.kGrey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(2, 2))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            child: CachedNetworkImage(
              imageUrl: product.productImage ?? "",
              errorWidget: (context, url, error) => CachedNetworkImage(
                imageUrl:
                    "https://image.spreadshirtmedia.com/image-server/v1/products/T1412A330PA3703PT17X246Y19D1040247317W6640H6184/views/1,width=550,height=550,appearanceId=330,backgroundColor=F2F2F2,modelId=5186,crop=list/42-dont-panic-life-universe-everything-mens-pique-polo-shirt.jpg",
                fit: BoxFit.fill,
              ),
              fit: BoxFit.fitHeight,
              width: 120,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            child: SizedBox(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    product.productName,
                    maxLines: 2,
                    style: AppTextStyle.f14BlackW500,
                  ),
                  const Spacer(),
                  if (product.variant != null)
                    Text(
                      "${product.variant!.selectedVariant.name}",
                      style: AppTextStyle.f16OutfitBlackW500,
                    ),
                  if (product.variant != null)
                    SizedBox(
                      height: 5,
                    ),
                  Text(
                    "₹${product.getPrice()}",
                    style: AppTextStyle.f16OutfitBlackW500,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  CartHelper.removeProduct(product.productId,
                      variant: product.variant);
                  CubitsInjector.homeCubit.updateCartProductList(
                      product.productId,
                      variant: product.variant);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border(
                        left: BorderSide(color: AppColors.kGrey400, width: 2),
                        bottom: BorderSide(color: AppColors.kGrey400, width: 2),
                      )),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                  child: Icon(
                    Icons.delete,
                    color: AppColors.kRed,
                    size: 20,
                  ),
                ),
              ),
              StreamBuilder<BoxEvent>(
                  stream:
                      CartHelper.watchCart(product.productId, product.variant),
                  builder: (context, eventSnapshot) {
                    if (eventSnapshot.hasData) {
                      final data = eventSnapshot.data?.value ?? {};
                      String id = "${product.productId}";
                      if (product.variant != null) {
                        id +=
                            "_${product.variant!.variantTitle}.${product.variant!.selectedVariant.name}";
                      }
                      if (id == eventSnapshot.data?.key) {
                        product.quantity = data['quantity'] ?? 0;
                        CubitsInjector.homeCubit.updateCartBilling();
                      }
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                      child: AddToCartWidget(
                        quantity: product.quantity,
                        productId: product.productId,
                        variant: product.variant,
                        isCart: true,
                      ),
                    );
                  }),
            ],
          )
        ],
      ),
    );
  }
}
