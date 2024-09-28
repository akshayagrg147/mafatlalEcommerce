import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/model/searchmodel.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/ProductSearchTile.dart';

class SearchScreen extends StatefulWidget {
  static const String route = "/searchScreen";
  final List<ProductSearch>? products;

  const SearchScreen({super.key, this.products});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<ProductSearch> productlist = [];

  @override
  void dispose() {
    CubitsInjector.homeCubit.disposeSearch();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.products != null) {
      productlist.addAll(widget.products!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(largeScreen: largeScreen());
  }

  Widget largeScreen() {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 1280,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back)),
                SizedBox(
                  width: 50,
                ),
                Text(
                  "Search Results",
                  style: AppTextStyle.f16OutfitBlackW500,
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: BlocConsumer<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is SearchSuccessState) {
                  productlist.clear();
                  productlist.addAll(state.organisations);
                }
                if (state is SearchFailedState) {
                  productlist.clear();
                }
              },
              buildWhen: (previous, current) =>
                  current is SearchSuccessState ||
                  current is SearchFailedState ||
                  current is SearchLoadingState,
              builder: (context, state) {
                if (state is SearchLoadingState) {
                  return const LoadingAnimation();
                }
                return GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: ResponsiveWidget.getGridCount(context),
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  children: List.generate(productlist.length, (index) {
                    return ProductSearchTile(
                      product: productlist[index],
                    );
                  }),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
