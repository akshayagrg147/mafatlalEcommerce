import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/model/searchmodel.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/ProductSearchTile.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/footer_widget.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/header.dart';

class SearchScreen extends StatefulWidget {
  static const String route = "/searchScreen";
  final List<ProductSearch>? products;

  const SearchScreen({super.key, this.products});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<ProductSearch> productlist = [];
  final searchController = TextEditingController();
  late HomeCubit homeCubit;

  @override
  void dispose() {
    CubitsInjector.homeCubit.disposeSearch();
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    homeCubit = BlocProvider.of<HomeCubit>(context);
    if (widget.products != null) {
      productlist.addAll(widget.products!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      largeScreen: largeScreen(),
      smallScreen: smallscreen(),
    );
  }

  Widget largeScreen() {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: Header(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 1280,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back)),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(
                          "Search Results",
                          style: AppTextStyle.f16OutfitBlackW500,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocConsumer<HomeCubit, HomeState>(
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
                          crossAxisCount:
                              ResponsiveWidget.getGridCount(context),
                          childAspectRatio:
                              MediaQuery.sizeOf(context).width < 600
                                  ? 0.5
                                  : 0.65,
                          crossAxisSpacing:
                              MediaQuery.sizeOf(context).width < 600 ? 20 : 60,
                          mainAxisSpacing:
                              MediaQuery.sizeOf(context).width < 600 ? 10 : 30,
                          children: List.generate(productlist.length, (index) {
                            return ProductSearchTile(
                              product: productlist[index],
                            );
                          }),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Footer()
          ],
        ),
      ),
    );
  }

  Widget smallscreen() {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: AppBar(
          titleSpacing: 0.0, // No unnecessary padding
          backgroundColor: Colors.transparent, // Transparent AppBar
          elevation: 0, // Remove AppBar shadow
          flexibleSpace: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 60.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                // Light grey background for the search bar
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextField(
                onChanged: (value) {
                  homeCubit.searchOrganisationsmall(value);
                },
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  // Light grey fill
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  suffixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      Icons.search_sharp,
                      color: AppColors.kGrey, // Use your app's grey color
                      size: 25, // Adjust size for better alignment
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: AppTextStyle.f16GreyW500,
                  hintText: AppStrings.searchHint, // Your search hint text
                ),
              ),
            ),
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 1280, // Ensures it is responsive
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              BlocBuilder<HomeCubit, HomeState>(
                buildWhen: (previous, current) => current is SearchSuccessState,
                builder: (context, state) {
                  if (state is SearchSuccessState) {
                    return const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Search Results",
                            style: AppTextStyle.f20GreyW600,
                          ),
                        )
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 20),
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
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      crossAxisCount: ResponsiveWidget.getGridCount(context),
                      childAspectRatio: 0.5,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      children: List.generate(productlist.length, (index) {
                        return ProductSearchTile(
                          product: productlist[index],
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
