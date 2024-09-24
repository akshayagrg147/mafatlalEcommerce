import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/add_to_cart_btn.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String route = "/productDetailScreen";
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    context.read<HomeCubit>().fetchProductDetails(widget.productId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(largeScreen: largeScreen());
  }

  Widget largeScreen() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is FetchProductDetailsSuccessState ||
          current is FetchProductDetailsLoadingState ||
          current is FetchProductDetailsFailedState,
      builder: (context, state) {
        if (state is FetchProductDetailsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is FetchProductDetailsSuccessState) {
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                  child: CachedNetworkImage(
                    imageUrl: state.product.productImage.first ?? "",
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                  child: SizedBox(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          state.product.productName,
                          maxLines: 2,
                          style: AppTextStyle.f14BlackW500,
                        ),
                        const Spacer(),
                        if (state.product.variant != null)
                          Text(
                            "${state.product.variant!.selectedVariant.name}",
                            style: AppTextStyle.f16OutfitBlackW500,
                          ),
                        if (state.product.variant != null)
                          const SizedBox(
                            height: 5,
                          ),
                        Text(
                          "₹${state.product.price}",
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
                        CartHelper.removeProduct(state.product.productId,
                            variant: state.product.variant);
                        CubitsInjector.homeCubit.updateCartProductList(
                            state.product.productId,
                            variant: state.product.variant);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border(
                              left: BorderSide(
                                  color: AppColors.kGrey400, width: 2),
                              bottom: BorderSide(
                                  color: AppColors.kGrey400, width: 2),
                            )),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 4),
                        child: Icon(
                          Icons.delete,
                          color: AppColors.kRed,
                          size: 20,
                        ),
                      ),
                    ),
                    StreamBuilder<BoxEvent>(
                        stream: CartHelper.watchCart(
                            state.product.productId, state.product.variant),
                        builder: (context, eventSnapshot) {
                          if (eventSnapshot.hasData) {
                            final data = eventSnapshot.data?.value ?? {};
                            String id = "${state.product.productId}";
                            if (state.product.variant != null) {
                              id +=
                                  "_${state.product.variant!.variantTitle}.${state.product.variant!.selectedVariant.name}";
                            }
                            if (id == eventSnapshot.data?.key) {
                              state.product.quantity = data['quantity'] ?? 0;
                              CubitsInjector.homeCubit.updateCartBilling();
                            }
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 5),
                            child: AddToCartWidget(
                              quantity: state.product.quantity,
                              productId: state.product.productId,
                              variant: state.product.variant,
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
        return const Center(
          child: Text('No Data'),
        );
      },
    );
  }

  Widget smallScreen() {
    return Container();
  }
}
