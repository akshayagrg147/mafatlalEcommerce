import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/category_item_widget.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/footer_widget.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/home_banner.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/product_grid_tile.dart';

class HomeBody extends StatelessWidget {
  final bool isWeb;

  const HomeBody({super.key, required this.isWeb});

  @override
  Widget build(BuildContext context) {
    if (isWeb) {
      return Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 1280,
          child: body(context, true),
        ),
      );
    }
    return body(context);
  }

  Widget body(BuildContext context, [bool isWeb = false]) {
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
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 40),
              CarouselSlider(
                items: [0, 1, 2, 3].map((e) => HomeBanner()).toList(),
                options: CarouselOptions(
                    viewportFraction: 1,
                    height:
                        ResponsiveWidget.isSmallScreen(context) ? 200 : 400.0,
                    autoPlay: true),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      CubitsInjector.homeCubit.storeData!.categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 25),
                  itemBuilder: (context, index) {
                    return CategoryWidget(
                      category:
                          CubitsInjector.homeCubit.storeData!.categories[index],
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Trending Items",
                style: AppTextStyle.f22BlackW600,
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: ResponsiveWidget.getGridCount(context),
                childAspectRatio: 0.7,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                children: List.generate(
                  CubitsInjector.homeCubit.storeData!.products.length,
                  (index) {
                    return ProductGridTile(
                      product:
                          CubitsInjector.homeCubit.storeData!.products[index],
                    );
                  },
                ),
              ),
              const SizedBox(height: 40), // Add space before footer
              Footer(), // Add your footer widget here
            ],
          ),
        );
      },
    );
  }
}
