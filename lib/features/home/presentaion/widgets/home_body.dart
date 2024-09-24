import 'package:carousel_slider/carousel_slider.dart';import 'package:flutter/material.dart';import 'package:flutter_bloc/flutter_bloc.dart';import 'package:mafatlal_ecommerce/components/loading_animation.dart';import 'package:mafatlal_ecommerce/components/responsive_screen.dart';import 'package:mafatlal_ecommerce/constants/app_strings.dart';import 'package:mafatlal_ecommerce/constants/asset_path.dart';import 'package:mafatlal_ecommerce/constants/textstyles.dart';import 'package:mafatlal_ecommerce/core/dependency_injection.dart';import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/footer_widget.dart';import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/home_banner.dart';import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/product_grid_tile.dart';import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/subcategory_new.dart';class HomeBody extends StatelessWidget {  final bool isWeb;  const HomeBody({super.key, required this.isWeb});  @override  Widget build(BuildContext context) {    if (isWeb) {      return Align(        alignment: Alignment.topCenter,        child: body(context, true),      );    }    return body(context);  }  Widget body(BuildContext context, [bool isWeb = false]) {    final List<String> bannerImages = [      AssetPath.banner1,      AssetPath.banner2,      AssetPath.banner3,    ];    return BlocBuilder<HomeCubit, HomeState>(      buildWhen: (previous, current) =>          current is FetchStoreDataLoadingState ||          current is FetchStoreDataFailedState ||          current is FetchStoreDataSuccessState,      builder: (context, state) {        if (state is FetchStoreDataLoadingState) {          return const LoadingAnimation();        }        if (CubitsInjector.homeCubit.storeData == null) {          return const Center(            child: Text(              "No Data",              style: AppTextStyle.f20GreyW600,            ),          );        }        return SingleChildScrollView(          child: Column(            crossAxisAlignment: CrossAxisAlignment.start,            mainAxisAlignment: MainAxisAlignment.start,            mainAxisSize: MainAxisSize.min,            children: [              const SizedBox(height: 40),              CarouselSlider(                items: bannerImages                    .map((imagePath) => HomeBanner(imagePath: imagePath))                    .toList(),                options: CarouselOptions(                  viewportFraction: 1,                  height: ResponsiveWidget.isSmallScreen(context) ? 200 : 400.0,                  autoPlay: true,                ),              ),              const SizedBox(height: 20),              Container(                margin: const EdgeInsets.all(30),                height: 120,                decoration: BoxDecoration(                  color: Colors.white, // Set the background color if needed                  boxShadow: [                    BoxShadow(                      color: Colors.lightBlueAccent                          .withOpacity(0.3), // Light blue shadow                      spreadRadius: 3,                      blurRadius: 6,                      offset: const Offset(                          0, 3), // Changes the position of the shadow                    ),                  ],                ),                child: BlocBuilder<HomeCubit, HomeState>(                  buildWhen: (previous, current) =>                      current is UpdateSubCategorySuccessState ||                      current is UpdateSubCategoryLoadingState ||                      current is UpdateSubCategoryFailedState,                  builder: (context, state) {                    if (state is UpdateSubCategoryLoadingState) {                      return const Center(child: CircularProgressIndicator());                    }                    if (state is UpdateSubCategorySuccessState) {                      return SubCategoryList(                        subcategories: state.subcategoy,                      );                    }                    return SubCategoryList(                      subcategories: CubitsInjector                          .homeCubit.storeData!.categories.first.subCategories,                    );                  },                ),              ),              const SizedBox(height: 20),              BlocBuilder<HomeCubit, HomeState>(                buildWhen: (previous, current) =>                    current is UpdateProductUsingSubCategorySuccessState ||                    current is UpdateProductUsingSubCategoryLoadingState ||                    current is UpdateProductUsingSubCategoryFailedState,                builder: (context, state) {                  if (state is UpdateProductUsingSubCategoryFailedState) {                    return const Text(AppStrings.somethingWentWrong);                  }                  if (state is UpdateProductUsingSubCategoryLoadingState) {                    return const Center(child: CircularProgressIndicator());                  }                  if (state is UpdateProductUsingSubCategorySuccessState) {                    return GridView.count(                      shrinkWrap: true,                      physics: const NeverScrollableScrollPhysics(),                      crossAxisCount: ResponsiveWidget.getGridCount(context),                      childAspectRatio: 0.7,                      mainAxisSpacing: 18,                      crossAxisSpacing: 18,                      children: List.generate(                        state.products.length,                        (index) {                          return Container(                            margin: const EdgeInsets.all(30),                            child: ProductGridTile(                              product: state.products[index],                            ),                          );                        },                      ),                    );                  }                  return GridView.count(                    shrinkWrap: true,                    physics: const NeverScrollableScrollPhysics(),                    crossAxisCount: ResponsiveWidget.getGridCount(context),                    childAspectRatio: 0.7,                    mainAxisSpacing: 18,                    crossAxisSpacing: 18,                    children: List.generate(                      CubitsInjector.homeCubit.storeData!.products.length,                      (index) {                        return Container(                            margin: const EdgeInsets.all(30),                            child: ProductGridTile(                              product: CubitsInjector                                  .homeCubit.storeData!.products[index],                            ));                      },                    ),                  );                },              ),              const SizedBox(height: 40), // Add space before footer              const Footer(), // Add your footer widget here            ],          ),        );      },    );  }}