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
  final bool isSmallScreen;
  const ProductListTile(
      {super.key, required this.product, this.isSmallScreen = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isSmallScreen ? 250 : 400,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildImage(),
          SizedBox(
            width: isSmallScreen ? 20 : 40,
          ),
          Expanded(flex: isSmallScreen ? 6 : 7, child: buildProductDetails())
        ],
      ),
    );
  }

  Widget buildImage() {
    return Expanded(
      flex: isSmallScreen ? 4 : 3,
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
                style: isSmallScreen
                    ? AppTextStyle.f24PoppinsBlackw600.copyWith(fontSize: 20)
                    : AppTextStyle.f24PoppinsBlackw600,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Organization:',
                    style: isSmallScreen
                        ? AppTextStyle.f18PoppinsDarkGreyw400
                            .copyWith(fontSize: 14)
                        : AppTextStyle.f18PoppinsDarkGreyw400,
                  ),
                  SizedBox(width: isSmallScreen ? 15 : 39),
                  Text(
                    product.productOrganisation,
                    style: isSmallScreen
                        ? AppTextStyle.f18PoppinsDarkGreyw600
                            .copyWith(fontSize: 14)
                        : AppTextStyle.f18PoppinsDarkGreyw600,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Product Type:',
                    style: isSmallScreen
                        ? AppTextStyle.f18PoppinsDarkGreyw400
                            .copyWith(fontSize: 14)
                        : AppTextStyle.f18PoppinsDarkGreyw400,
                  ),
                  const SizedBox(width: 31),
                  Text(
                    product.productCategory,
                    style: isSmallScreen
                        ? AppTextStyle.f18PoppinsDarkGreyw600
                            .copyWith(fontSize: 14)
                        : AppTextStyle.f18PoppinsDarkGreyw600,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  if (product.variant != null)
                    Container(
                      height: isSmallScreen ? 35 : 48,
                      width: isSmallScreen ? 35 : 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.kRed,
                      ),
                      child: Center(
                        child: Text(
                          product.variant!.selectedVariant.name,
                          style: isSmallScreen
                              ? AppTextStyle.f18PoppinsWhitew600
                                  .copyWith(fontSize: 12)
                              : AppTextStyle.f18PoppinsWhitew600,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Text(
                    product.getPrice().toString(),
                    style: isSmallScreen
                        ? AppTextStyle.f24PoppinsBlackw600
                            .copyWith(fontSize: 18)
                        : AppTextStyle.f24PoppinsBlueGreyw600,
                  )
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Text(
                    'Quantity',
                    style: isSmallScreen
                        ? AppTextStyle.f18PoppinsDarkGreyw400
                            .copyWith(fontSize: 14)
                        : AppTextStyle.f18PoppinsDarkGreyw400,
                  ),
                  const Spacer(),
                  Text(
                    "X\t${product.quantity}",
                    style: isSmallScreen
                        ? AppTextStyle.f24PoppinsBlackw600
                            .copyWith(fontSize: 18)
                        : AppTextStyle.f24PoppinsBlueGreyw600,
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
                    style: isSmallScreen
                        ? AppTextStyle.f28PoppinsBlackw600
                            .copyWith(fontSize: 18)
                        : AppTextStyle.f28PoppinsBlackw600,
                  )
                ],
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    CartHelper.removeProduct(product.productId,
                        variant: product.variant);
                    CubitsInjector.homeCubit.updateCartProductList(
                        product.productId,
                        variant: product.variant);
                  },
                  child: Text(
                    'Remove Item',
                    style: AppTextStyle.f18PoppinsDarkGreyw400.copyWith(
                        fontSize: isSmallScreen ? 14 : 18,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.darkGray),
                  ),
                ),
              )
            ],
          );
        });
  }
}
