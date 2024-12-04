import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/add_to_cart_btn.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/cart_btn.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/footer_widget.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/header.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/relatedproduct_tile.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/size_selection_widget.dart';
import 'package:mafatlal_ecommerce/features/product_details/bloc/product_detail_cubit.dart';
import 'package:mafatlal_ecommerce/features/product_details/bloc/product_detail_state.dart';
import 'package:mafatlal_ecommerce/routes/auto_route/mf_router.gr.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String route = "/productDetails";
  final int productId;

  const ProductDetailsScreen({super.key, @PathParam() required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // late int productId;

  @override
  void initState() {
    // productId=widget.productId;
    context.read<ProductDetailsCubit>().fetchProductDetails(widget.productId);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ProductDetailsScreen oldWidget) {
    if (widget.productId != oldWidget.productId) {
      context.read<ProductDetailsCubit>().fetchProductDetails(widget.productId);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      largeScreen: largeScreen(),
      smallScreen: smallScreen(),
    );
  }

  Widget smallScreen() {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kWhite,
          surfaceTintColor: AppColors.kWhite,
          title: Text(
            "Product Details",
            style: AppTextStyle.f18OutfitBlackW500,
          ),
          actions: [
            CartBtn(),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: BlocBuilder<ProductDetailsCubit, ProductDetailState>(
            buildWhen: (previous, current) =>
                current is FetchProductDetailsSuccessState ||
                current is FetchProductDetailsLoadingState ||
                current is FetchProductDetailsFailedState,
            builder: (context, state) {
              if (state is FetchProductDetailsLoadingState) {
                return const LoadingAnimation();
              }
              if (state is FetchProductDetailsSuccessState) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 350,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x1F004392),
                                      offset: Offset(0, 8),
                                      blurRadius: 24.0,
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: CachedNetworkImage(
                                  imageUrl: state.product.productImage.first,
                                  fit: BoxFit.contain,
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.error,
                                    color: AppColors.kBlack,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                height: 100,
                                width: double.maxFinite,
                                child: ListView.separated(
                                  itemCount: state.product.productImage.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFFFFFFF),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0x29004392),
                                              offset: Offset(0, 8),
                                              blurRadius: 12.0,
                                            ),
                                          ],
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              state.product.productImage[index],
                                          fit: BoxFit.contain,
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.error,
                                            color: AppColors.kBlack,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(
                                      height: 20,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              Text(
                                state.product.name,
                                style: AppTextStyle.f14OutfitBlackW500,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Text('Organization: ',
                                      style:
                                          AppTextStyle.f14RobotoDarkgrayW500),
                                  SizedBox(width: 5),
                                  Text(
                                    state.product.productOrganization,
                                    style: AppTextStyle.f14OutfitBlackW500,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Text('Product Type: ',
                                      style:
                                          AppTextStyle.f14RobotoDarkgrayW500),
                                  const SizedBox(width: 5),
                                  Text(
                                    state.product.productCategory,
                                    style: AppTextStyle.f14OutfitBlackW500,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Text('Rs. ',
                                      style: AppTextStyle.f14OutfitBlackW500),
                                  const SizedBox(width: 5),
                                  BlocBuilder<ProductDetailsCubit,
                                      ProductDetailState>(
                                    buildWhen: (previous, current) {
                                      return current
                                          is UpdateProductVariantState;
                                    },
                                    builder: (context, st) {
                                      return Text(
                                          state.product
                                              .getPrice()
                                              .toStringAsFixed(2),
                                          style:
                                              AppTextStyle.f14OutfitBlackW500);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              if (state.product.variant != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Select Size',
                                      style: AppTextStyle.f12OutfitBlackW500,
                                    ),
                                    const SizedBox(height: 10),
                                    SizeSelection(
                                      variant: state.product.variant!,
                                      onVariantSelected: (o) {
                                        state.product.variant!.selectedVariant =
                                            o;
                                        state.product.quantity =
                                            CartHelper.getProductQuantity(
                                          int.parse(state.product.id),
                                          variant: state.product.variant,
                                        );
                                        context
                                            .read<ProductDetailsCubit>()
                                            .updateProductVariant(
                                              int.parse(state.product.id),
                                              selectedVariant: state.product
                                                  .variant!.selectedVariant,
                                            );
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),

                              // Quantity selection
                              Text(
                                'Select Quantity',
                                style: AppTextStyle.f12OutfitBlackW500,
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 200,
                                child: BlocBuilder<ProductDetailsCubit,
                                    ProductDetailState>(
                                  buildWhen: (previous, current) =>
                                      (current is UpdateProductVariantState &&
                                          current.id ==
                                              int.parse(context
                                                  .read<ProductDetailsCubit>()
                                                  .productDetail!
                                                  .id)) ||
                                      (current
                                              is UpdateProductVariantLoadingState &&
                                          current.id ==
                                              int.parse(context
                                                  .read<ProductDetailsCubit>()
                                                  .productDetail!
                                                  .id)),
                                  builder: (context, state) {
                                    if (state
                                        is UpdateProductVariantLoadingState) {
                                      return const SizedBox(
                                        height: 70,
                                      );
                                    }
                                    return StreamBuilder<BoxEvent>(
                                      stream: CartHelper.watchCart(
                                        int.parse(context
                                            .read<ProductDetailsCubit>()
                                            .productDetail!
                                            .id),
                                        context
                                            .read<ProductDetailsCubit>()
                                            .productDetail!
                                            .variant,
                                      ),
                                      builder: (context, eventSnapshot) {
                                        if (eventSnapshot.hasData) {
                                          final data =
                                              eventSnapshot.data?.value ?? {};
                                          context
                                              .read<ProductDetailsCubit>()
                                              .productDetail!
                                              .quantity = data['quantity'] ?? 0;
                                        }
                                        return AddToCartWidget(
                                          isIntrisicWidth: false,
                                          quantity: context
                                              .read<ProductDetailsCubit>()
                                              .productDetail!
                                              .quantity,
                                          productId: int.parse(context
                                              .read<ProductDetailsCubit>()
                                              .productDetail!
                                              .id),
                                          variant: context
                                              .read<ProductDetailsCubit>()
                                              .productDetail!
                                              .variant,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          )),

                      // Product information
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: buildDescription(context
                                .read<ProductDetailsCubit>()
                                .productDetail
                                ?.description ??
                            ''),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Related Products :- ',
                          style: AppTextStyle.f33darkblue,
                        ),
                      ),
                      SizedBox(
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount:
                              ResponsiveWidget.getGridCount(context),
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveWidget.isSmallScreen(context)
                                ? 20
                                : 48,
                          ),
                          childAspectRatio:
                              ResponsiveWidget.isLargeScreen(context)
                                  ? 0.7
                                  : 0.5,
                          crossAxisSpacing:
                              ResponsiveWidget.isLargeScreen(context) ? 68 : 15,
                          mainAxisSpacing:
                              ResponsiveWidget.isLargeScreen(context) ? 68 : 15,
                          children: List.generate(
                            state.product.relatedProducts.length,
                            (index) {
                              return RelatedProductTile(
                                product: state.product.relatedProducts[index],
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                );
              }
              return const Center(child: Text('No Data'));
            }));
  }

  Widget buildDescription(String description) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.kWhite,
          border: Border.all(color: AppColors.kGrey200)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              'Description',
              style: AppTextStyle.f22BlackW600,
            ),
          ),
          Divider(
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              description,
              style: AppTextStyle.f18OutfitBlackW500,
            ),
          ),
        ],
      ),
    );
  }

  Widget largeScreen() {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: Header(
          onSearchSubmitted: (value) {
            context.router.push(SearchScreenRoute(searchText: value));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ProductDetailsCubit, ProductDetailState>(
              buildWhen: (previous, current) =>
                  current is FetchProductDetailsSuccessState,
              // current is UpdateProductVariantState,
              builder: (context, state) {
                if (state is FetchProductDetailsSuccessState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(48),
                        child: Text(
                          '${state.product.productSubCategory} / ${state.product.productOrganization} ',
                          style: AppTextStyle.f33darkblue,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 350,
                              width: 100,
                              child: ListView.separated(
                                itemCount: state.product.productImage.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFFFFFF),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x29004392),
                                            offset: Offset(0, 8),
                                            blurRadius: 12.0,
                                          ),
                                        ],
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            state.product.productImage[index],
                                        fit: BoxFit.contain,
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error,
                                          color: AppColors.kBlack,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(
                                    height: 20,
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 350,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x1F004392),
                                      offset: Offset(0, 8),
                                      blurRadius: 24.0,
                                    ),
                                  ],
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: state.product.productImage.first,
                                  fit: BoxFit.contain,
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.error,
                                    color: AppColors.kBlack,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 70,
                            ),

                            // Product information
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.product.name,
                                      style: AppTextStyle.f14OutfitBlackW500,
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Text('Organization: ',
                                            style: AppTextStyle
                                                .f14RobotoDarkgrayW500),
                                        SizedBox(width: 5),
                                        Text(
                                          state.product.productOrganization,
                                          style:
                                              AppTextStyle.f14OutfitBlackW500,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Text('Product Type: ',
                                            style: AppTextStyle
                                                .f14RobotoDarkgrayW500),
                                        const SizedBox(width: 5),
                                        Text(
                                          state.product.productCategory,
                                          style:
                                              AppTextStyle.f14OutfitBlackW500,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Text('Rs. ',
                                            style: AppTextStyle
                                                .f14OutfitBlackW500),
                                        const SizedBox(width: 5),
                                        BlocBuilder<ProductDetailsCubit,
                                            ProductDetailState>(
                                          buildWhen: (previous, current) {
                                            return current
                                                is UpdateProductVariantState;
                                          },
                                          builder: (context, st) {
                                            return Text(
                                                state.product
                                                    .getPrice()
                                                    .toStringAsFixed(2),
                                                style: AppTextStyle
                                                    .f14OutfitBlackW500);
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),

                                    if (state.product.variant != null)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Select Size',
                                            style:
                                                AppTextStyle.f12OutfitBlackW500,
                                          ),
                                          const SizedBox(height: 10),
                                          SizeSelection(
                                            variant: state.product.variant!,
                                            onVariantSelected: (o) {
                                              state.product.variant!
                                                  .selectedVariant = o;
                                              state.product.quantity =
                                                  CartHelper.getProductQuantity(
                                                int.parse(state.product.id),
                                                variant: state.product.variant,
                                              );
                                              context
                                                  .read<ProductDetailsCubit>()
                                                  .updateProductVariant(
                                                    int.parse(state.product.id),
                                                    selectedVariant: state
                                                        .product
                                                        .variant!
                                                        .selectedVariant,
                                                  );
                                            },
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),

                                    // Quantity selection
                                    Text(
                                      'Select Quantity',
                                      style: AppTextStyle.f12OutfitBlackW500,
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: 200,
                                      child: BlocBuilder<ProductDetailsCubit,
                                          ProductDetailState>(
                                        buildWhen: (previous, current) =>
                                            (current
                                                    is UpdateProductVariantState &&
                                                current.id ==
                                                    int.parse(context
                                                        .read<
                                                            ProductDetailsCubit>()
                                                        .productDetail!
                                                        .id)) ||
                                            (current
                                                    is UpdateProductVariantLoadingState &&
                                                current.id ==
                                                    int.parse(context
                                                        .read<
                                                            ProductDetailsCubit>()
                                                        .productDetail!
                                                        .id)),
                                        builder: (context, state) {
                                          if (state
                                              is UpdateProductVariantLoadingState) {
                                            return const SizedBox(
                                              height: 70,
                                            );
                                          }
                                          return StreamBuilder<BoxEvent>(
                                            stream: CartHelper.watchCart(
                                              int.parse(context
                                                  .read<ProductDetailsCubit>()
                                                  .productDetail!
                                                  .id),
                                              context
                                                  .read<ProductDetailsCubit>()
                                                  .productDetail!
                                                  .variant,
                                            ),
                                            builder: (context, eventSnapshot) {
                                              if (eventSnapshot.hasData) {
                                                final data =
                                                    eventSnapshot.data?.value ??
                                                        {};
                                                context
                                                    .read<ProductDetailsCubit>()
                                                    .productDetail!
                                                    .quantity = data[
                                                        'quantity'] ??
                                                    0;
                                              }
                                              return AddToCartWidget(
                                                isIntrisicWidth: false,
                                                quantity: context
                                                    .read<ProductDetailsCubit>()
                                                    .productDetail!
                                                    .quantity,
                                                productId: int.parse(context
                                                    .read<ProductDetailsCubit>()
                                                    .productDetail!
                                                    .id),
                                                variant: context
                                                    .read<ProductDetailsCubit>()
                                                    .productDetail!
                                                    .variant,
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                        ),
                        child: buildDescription(context
                                .read<ProductDetailsCubit>()
                                .productDetail
                                ?.description ??
                            ''),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(48),
                        child: Text(
                          'Related Products :- ',
                          style: AppTextStyle.f33darkblue,
                        ),
                      ),
                      SizedBox(
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount:
                              ResponsiveWidget.getGridCount(context),
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveWidget.isSmallScreen(context)
                                ? 20
                                : 48,
                          ),
                          childAspectRatio:
                              ResponsiveWidget.isLargeScreen(context)
                                  ? 0.7
                                  : 0.5,
                          crossAxisSpacing:
                              ResponsiveWidget.isLargeScreen(context) ? 68 : 15,
                          mainAxisSpacing:
                              ResponsiveWidget.isLargeScreen(context) ? 68 : 15,
                          children: List.generate(
                            state.product.relatedProducts.length,
                            (index) {
                              return RelatedProductTile(
                                product: state.product.relatedProducts[index],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return const Center(child: Text('No Data'));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Footer(), // Footer widget
          ],
        ),
      ),
    );
  }
}
