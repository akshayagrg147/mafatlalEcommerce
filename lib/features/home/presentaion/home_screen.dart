import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/category_item_widget.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/drawer.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/home_appbar.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/product_grid_tile.dart';

class HomeScreen extends StatefulWidget {
  static const String route = "/homeScreen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeKey = GlobalKey<ScaffoldState>();
  late HomeCubit homeCubit;

  @override
  void initState() {
    homeCubit = BlocProvider.of<HomeCubit>(context);
    homeCubit.fetchStoreData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _homeKey,
      appBar: HomeAppBar(
        onMenuTap: () {
          _homeKey.currentState?.openDrawer();
        },
      ),
      drawer: const HomeDrawer(),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 16 * SizeConfig.widthMultiplier),
        child: SizedBox(
          width: SizeConfig.screenWidth > 1000
              ? 1000 * SizeConfig.widthMultiplier
              : double.maxFinite,
          child: BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) =>
                current is FetchStoreDataLoadingState ||
                current is FetchStoreDataFailedState ||
                current is FetchStoreDataSuccessState,
            builder: (context, state) {
              if (state is FetchStoreDataLoadingState) {
                return const LoadingAnimation();
              }
              if (homeCubit.storeData == null) {
                return Center(
                  child: Text(
                    "No Data",
                    style: AppTextStyle.f20GreyW600,
                  ),
                );
              }
              return Column(
                children: [
                  SizedBox(
                    height: 20 * SizeConfig.heightMultiplier,
                  ),
                  SizedBox(
                    height: 90 * SizeConfig.widthMultiplier,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: homeCubit.storeData!.categories.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 10 * SizeConfig.widthMultiplier,
                          );
                        },
                        itemBuilder: (context, index) {
                          return CategoryWidget(
                              category: homeCubit.storeData!.categories[index]);
                        }),
                  ),
                  trendingProducts()
                ],
              );
            },
          ),
        ),
      ),
    ));
  }

  Widget trendingProducts() {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: AppColors.kGrey200,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: 16 * SizeConfig.widthMultiplier,
          vertical: 16 * SizeConfig.heightMultiplier),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Trending Items",
            style: AppTextStyle.f22BlackW600,
          ),
          SizedBox(
            height: 16 * SizeConfig.heightMultiplier,
          ),
          Wrap(
            runSpacing: 10 * SizeConfig.heightMultiplier,
            spacing: 20 * SizeConfig.widthMultiplier,
            children:
                List.generate(homeCubit.storeData!.products.length, (index) {
              return ProductGridTile(
                product: homeCubit.storeData!.products[index],
              );
            }),
          )
        ],
      ),
    );
  }
}
