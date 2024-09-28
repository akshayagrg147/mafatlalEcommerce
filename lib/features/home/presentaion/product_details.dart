import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
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
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/home_banner.dart';
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

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is FetchStoreDataLoadingState ||
          current is FetchStoreDataFailedState ||
          current is FetchStoreDataSuccessState,
      builder: (context, state) {
        if (state is FetchStoreDataLoadingState) {
          return const LoadingAnimation();
        }
        if (CubitsInjector.homeCubit.storeData == null) {
          return const Center(
            child: Text(
              "No Data",
              style: AppTextStyle.f20GreyW600,
            ),
          );
        }
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                CarouselSlider(
                  items: bannerImages
                      .map((imagePath) => HomeBanner(imagePath: imagePath))
                      .toList(),
                  options: CarouselOptions(
                    viewportFraction: 1,
                    height:
                        ResponsiveWidget.isSmallScreen(context) ? 200 : 400.0,
                    autoPlay: true,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Petrol Pump Uniform / Hindutsan Petroleum / Hind Petroleum Waist Coat',
                    style: AppTextStyle.f33darkblue,
                  ),
                ),
                BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (previous, current) =>
                      current is FetchProductDetailsSuccessState ||
                      current is UpdateProductVariantLoadingState ||
                      current is UpdateProductVariantState,
                  builder: (context, state) {
                    if (state is FetchProductDetailsSuccessState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                height: 290,
                                width: 100,
                                child: ListView.builder(
                                  itemCount: state.product.productImage.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return Container(
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
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 290,
                                  margin: const EdgeInsets.all(20),
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

                              // Product information
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.product.name,
                                        style: AppTextStyle.f16BlackW400,
                                      ),
                                      const SizedBox(height: 20),
                                      const Row(
                                        children: [
                                          Text('Availability: '),
                                          SizedBox(width: 5),
                                          Text(
                                            'In Stock',
                                            style: AppTextStyle.f12GreenW500,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          const Text('Product Type: '),
                                          const SizedBox(width: 5),
                                          Text(
                                            state.product.productCategory,
                                            style:
                                                AppTextStyle.f12OutfitBlackW500,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          const Text('Rs. '),
                                          const SizedBox(width: 5),
                                          Text(state.product.price,
                                              style: AppTextStyle
                                                  .f12OutfitBlackW500),
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
                                              style: AppTextStyle
                                                  .f12OutfitBlackW500,
                                            ),
                                            const SizedBox(height: 10),
                                            SizeSelection(
                                              variant: state.product.variant!,
                                              onVariantSelected: (o) {
                                                state.product.variant!
                                                    .selectedVariant = o;
                                                state.product.quantity =
                                                    CartHelper
                                                        .getProductQuantity(
                                                  int.parse(state.product.id),
                                                  variant:
                                                      state.product.variant,
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
                                        width: 100,
                                        child: StreamBuilder<BoxEvent>(
                                          stream: CartHelper.watchCart(
                                            int.parse(state.product.id),
                                            state.product.variant,
                                          ),
                                          builder: (context, eventSnapshot) {
                                            if (eventSnapshot.hasData) {
                                              final data =
                                                  eventSnapshot.data?.value ??
                                                      {};
                                              state.product.quantity =
                                                  data['quantity'] ?? 0;
                                            }
                                            return AddToCartWidget(
                                              quantity: state.product.quantity,
                                              productId:
                                                  int.parse(state.product.id),
                                              variant: state.product.variant,
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
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'Petrol Pump Uniforms by Hindustan Petroleum',
                              style: AppTextStyle.f33darkblue,
                            ),
                          ),
                          SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.product.relatedProducts.length,
                              itemBuilder: (context, index) {
                                return RelatedProductTile(
                                  product: state.product.relatedProducts[index],
                                );
                              },
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
      },
    );
  }

  Widget smallScreen() {
    return Container();
  }
}
