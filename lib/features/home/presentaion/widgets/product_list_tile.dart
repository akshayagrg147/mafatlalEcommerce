import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/add_to_cart_btn.dart';

class ProductListTile extends StatelessWidget {
  final Product_new product;

  const ProductListTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildImage(),
          SizedBox(
            width: 40,
          ),
          Expanded(flex: 7, child: buildProductDetails())
        ],
      ),
    );
  }

  Widget buildImage() {
    return Expanded(
      flex: 3,
      child: Container(
        height: double.maxFinite, // height: 400px
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF), // background: #FFFFFF
          boxShadow: [
            BoxShadow(
              color: Color(0x1F004392), // box-shadow: #0043921F
              offset: Offset(0, 8), // offset: 0px 8px
              blurRadius: 24, // blur radius: 24px
            ),
          ],
        ),
        alignment: Alignment.center,
        child: CachedNetworkImage(
          imageUrl:
              product.productImage.isNotEmpty ? product.productImage.first : "",
          errorWidget: (context, url, error) => CachedNetworkImage(
            imageUrl:
                "https://image.spreadshirtmedia.com/image-server/v1/products/T1412A330PA3703PT17X246Y19D1040247317W6640H6184/views/1,width=550,height=550,appearanceId=330,backgroundColor=F2F2F2,modelId=5186,crop=list/42-dont-panic-life-universe-everything-mens-pique-polo-shirt.jpg",
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget buildProductDetails() {
    return StreamBuilder<BoxEvent>(
        stream: CartHelper.watchCart(product.productId, product.variant),
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.productName,
                style: AppTextStyle.f24PoppinsBlackw600,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Availability:',
                    style: AppTextStyle.f18PoppinsDarkGreyw400,
                  ),
                  SizedBox(width: 39),
                  Text(
                    'In Stock',
                    style: AppTextStyle.f18PoppinsGreenw600,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Product Type:',
                    style: AppTextStyle.f18PoppinsDarkGreyw400,
                  ),
                  const SizedBox(width: 31),
                  Text(
                    product.productCategory,
                    style: AppTextStyle.f18PoppinsDarkGreyw600,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  if (product.variant != null)
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.kRed,
                      ),
                      child: Center(
                        child: Text(
                          product.variant!.selectedVariant.name,
                          style: AppTextStyle.f18PoppinsWhitew600,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Text(
                    product.getPrice().toString(),
                    style: AppTextStyle.f24PoppinsBlueGreyw600,
                  )
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Text(
                    'Quantity',
                    style: AppTextStyle.f18PoppinsDarkGreyw400,
                  ),
                  const Spacer(),
                  Text(
                    "X\t${product.quantity}",
                    style: AppTextStyle.f24PoppinsBlueGreyw600,
                  )
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    child: AddToCartWidget(
                      quantity: product.quantity,
                      productId: product.productId,
                      variant: product.variant,
                      isCart: true,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "₹ ${product.getAmount()}",
                    style: AppTextStyle.f28PoppinsBlackw600,
                  )
                ],
              )
            ],
          );
        });
  }
}

// [
//
//
// Padding
// (
// padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
// child: CachedNetworkImage(
// imageUrl: product.productImage.isNotEmpty
// ? product.productImage.first
//     : "",
// errorWidget: (context, url, error) => CachedNetworkImage(
// imageUrl:
// "https://image.spreadshirtmedia.com/image-server/v1/products/T1412A330PA3703PT17X246Y19D1040247317W6640H6184/views/1,width=550,height=550,appearanceId=330,backgroundColor=F2F2F2,modelId=5186,crop=list/42-dont-panic-life-universe-everything-mens-pique-polo-shirt.jpg",
// fit: BoxFit.fill,
// ),
// fit: BoxFit.fitHeight,
// width: 120,
// ),
// ),
// Padding(
// padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
// child: SizedBox(
// width: 150,
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// SizedBox(
// height: 5,
// ),
// Text(
// product.productName,
// maxLines: 2,
// style: AppTextStyle.f14BlackW500,
// ),
// const Spacer(),
// if (product.variant != null)
// Text(
// "${product.variant!.selectedVariant.name}",
// style: AppTextStyle.f16OutfitBlackW500,
// ),
// if (product.variant != null)
// SizedBox(
// height: 5,
// ),
// Text(
// "₹${product.getPrice()}",
// style: AppTextStyle.f16OutfitBlackW500,
// ),
// ],
// ),
// ),
// ),
// const Spacer(),
// Column(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// crossAxisAlignment: CrossAxisAlignment.end,
// children: [
// GestureDetector(
// onTap: () {
// CartHelper.removeProduct(product.productId,
// variant: product.variant);
// CubitsInjector.homeCubit.updateCartProductList(
// product.productId,
// variant: product.variant);
// },
// child: Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(6),
// border: Border(
// left: BorderSide(color: AppColors.kGrey400, width: 2),
// bottom: BorderSide(color: AppColors.kGrey400, width: 2),
// )),
// padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
// child: Icon(
// Icons.delete,
// color: AppColors.kRed,
// size: 20,
// ),
// ),
// ),
// StreamBuilder<BoxEvent>(
// stream:
// CartHelper.watchCart(product.productId, product.variant),
// builder: (context, eventSnapshot) {
// if (eventSnapshot.hasData) {
// final data = eventSnapshot.data?.value ?? {};
// String id = "${product.productId}";
// if (product.variant != null) {
// id +=
// "_${product.variant!.variantTitle}.${product.variant!.selectedVariant.name}";
// }
// if (id == eventSnapshot.data?.key) {
// product.quantity = data['quantity'] ?? 0;
// CubitsInjector.homeCubit.updateCartBilling();
// }
// }
// return Padding(
// padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
// child: AddToCartWidget(
// quantity: product.quantity,
// productId: product.productId,
// variant: product.variant,
// isCart: true,
// ),
// );
// })
// ,
// ]
// ,
// )
// ]
