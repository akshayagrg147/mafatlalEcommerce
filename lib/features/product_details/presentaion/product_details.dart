import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/asset_path.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/add_to_cart_btn.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/footer_widget.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/header.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/relatedproduct_tile.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/size_selection_widget.dart';

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
    final List<String> bannerImages = [
      AssetPath.banner1,
      AssetPath.banner2,
      AssetPath.banner3,
    ];

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: Header(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(48),
              child: Text(
                'Petrol Pump Uniform / Hindutsan Petroleum / Hind Petroleum Waist Coat',
                style: AppTextStyle.f33darkblue,
              ),
            ),
            BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) =>
                  current is FetchProductDetailsSuccessState,
              // current is UpdateProductVariantState,
              builder: (context, state) {
                if (state is FetchProductDetailsSuccessState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                        BlocBuilder<HomeCubit, HomeState>(
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
                                              CubitsInjector.homeCubit
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
                                      child: BlocBuilder<HomeCubit, HomeState>(
                                        buildWhen: (previous, current) =>
                                            (current
                                                    is UpdateProductVariantState &&
                                                current.id ==
                                                    int.parse(context
                                                        .read<HomeCubit>()
                                                        .productDetail!
                                                        .id)) ||
                                            (current
                                                    is UpdateProductVariantLoadingState &&
                                                current.id ==
                                                    int.parse(context
                                                        .read<HomeCubit>()
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
                                                  .read<HomeCubit>()
                                                  .productDetail!
                                                  .id),
                                              context
                                                  .read<HomeCubit>()
                                                  .productDetail!
                                                  .variant,
                                            ),
                                            builder: (context, eventSnapshot) {
                                              if (eventSnapshot.hasData) {
                                                final data =
                                                    eventSnapshot.data?.value ??
                                                        {};
                                                context
                                                        .read<HomeCubit>()
                                                        .productDetail!
                                                        .quantity =
                                                    data['quantity'] ?? 0;
                                              }
                                              return AddToCartWidget(
                                                isIntrisicWidth: false,
                                                quantity: context
                                                    .read<HomeCubit>()
                                                    .productDetail!
                                                    .quantity,
                                                productId: int.parse(context
                                                    .read<HomeCubit>()
                                                    .productDetail!
                                                    .id),
                                                variant: context
                                                    .read<HomeCubit>()
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
                              horizontal:
                                  ResponsiveWidget.isLargeScreen(context)
                                      ? 48
                                      : 20),
                          childAspectRatio:
                              MediaQuery.sizeOf(context).width < 600
                                  ? 0.5
                                  : 0.8,
                          crossAxisSpacing:
                              MediaQuery.sizeOf(context).width < 600 ? 15 : 60,
                          mainAxisSpacing:
                              MediaQuery.sizeOf(context).width < 600 ? 15 : 30,
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

  Widget smallScreen() {
    return Container();
  }
}
