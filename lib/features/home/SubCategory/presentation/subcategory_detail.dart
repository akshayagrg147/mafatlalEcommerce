import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/constants/asset_path.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/login_screen.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/bloc/subcategory_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/bloc/subcategory_state.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/district_model.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/organization_model.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/state_model.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/drawer.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/footer_widget.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/header.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/home_appbar.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/home_banner.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/product_grid_tile.dart';

class SubCategoryDetail extends StatefulWidget {
  static const String route = "/SubCategoryDetail";
  final List<SubCategory_new> subcategories;
  final String selectedname;

  const SubCategoryDetail(
      {super.key, required this.subcategories, required this.selectedname});

  @override
  State<SubCategoryDetail> createState() => _SubCategoryDetailState();
}

class _SubCategoryDetailState extends State<SubCategoryDetail> {
  late SubcategoryCubit subcategoryCubit;
  final _homeKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    subcategoryCubit = BlocProvider.of<SubcategoryCubit>(context);
    subcategoryCubit.getsubcategorydetails(
        widget.subcategories, widget.selectedname);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      largeScreen: largeScreen(),
      smallScreen: smallScreen(),
    );
  }

  Widget smallScreen() {
    return SafeArea(
        child: Scaffold(
            key: _homeKey,
            appBar: HomeAppBar(
              onMenuTap: () {
                if (CubitsInjector.authCubit.currentUser != null) {
                  _homeKey.currentState?.openDrawer();
                } else {
                  Navigator.pushNamed(context, LoginScreen.route);
                }
              },
            ),
            drawer: const HomeDrawer(),
            body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: largeScreen())));
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
          children: [
            const SizedBox(height: 10),
            CarouselSlider(
              items: bannerImages
                  .map((imagePath) => HomeBanner(imagePath: imagePath))
                  .toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                height: ResponsiveWidget.isSmallScreen(context) ? 200 : 400.0,
                autoPlay: true,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 15, right: 5),
              margin: const EdgeInsets.only(top: 20),
              height: MediaQuery.sizeOf(context).width < 600 ? 120 : 60,
              alignment: Alignment.topLeft,
              width: MediaQuery.sizeOf(context).width,
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
              child: Wrap(
                runSpacing: 10,
                alignment: WrapAlignment.start,
                children: [
                  BlocBuilder<SubcategoryCubit, SubCategoryDetailState>(
                    buildWhen: (previous, current) =>
                        current is GetSubCategoryDetailScreenLoadingState ||
                        current is GetSubCategoryDetailScreenFailedState ||
                        current is GetSubCategoryDetailScreenSuccessState,
                    builder: (context, state) {
                      if (state is GetSubCategoryDetailScreenLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is GetSubCategoryDetailScreenFailedState) {
                        return Center(
                            child: Text(state.message,
                                style: AppTextStyle.f12OutfitBlackW500));
                      }
                      if (state is GetSubCategoryDetailScreenSuccessState) {
                        return _buildDynamicDropdown<SubCategory_new>(
                          hintText: state.selectedname,
                          value: state.subcategories.isNotEmpty
                              ? state.subcategories.firstWhere(
                                  (subcategory) =>
                                      subcategory.name == state.selectedname,
                                  orElse: () => state.subcategories.first,
                                )
                              : null,
                          // Handle empty list case
                          items: state.subcategories,
                          itemBuilder: (subcategory) =>
                              DropdownMenuItem<SubCategory_new>(
                            value: subcategory,
                            child: Text(subcategory.name),
                          ),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              subcategoryCubit.selectSubCategory(newValue.name);
                            }
                          },
                        );
                      }

                      return _buildDynamicDropdown<SubCategory_new>(
                        hintText: context
                                .read<SubcategoryCubit>()
                                .SelectedSubcategoryname ??
                            'Select Subcategory',
                        value: context
                                    .read<SubcategoryCubit>()
                                    .subcategorieslist
                                    ?.isNotEmpty ==
                                true
                            ? context
                                .read<SubcategoryCubit>()
                                .subcategorieslist!
                                .firstWhere(
                                  (subcategory) =>
                                      subcategory.name ==
                                      context
                                          .read<SubcategoryCubit>()
                                          .SelectedSubcategoryname,
                                  orElse: () => context
                                      .read<SubcategoryCubit>()
                                      .subcategorieslist!
                                      .first,
                                )
                            : null,
                        // Handle empty or null list
                        items: context
                                .read<SubcategoryCubit>()
                                .subcategorieslist ??
                            [],
                        itemBuilder: (subcategory) =>
                            DropdownMenuItem<SubCategory_new>(
                          value: subcategory,
                          child: Text(subcategory.name),
                        ),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            subcategoryCubit.selectSubCategory(newValue.name);
                          }
                        },
                      );
                    },
                  ),
                  BlocBuilder<SubcategoryCubit, SubCategoryDetailState>(
                    buildWhen: (previous, current) =>
                        current is GetAllStateLoadingState ||
                        current is GetAllStateFailedState ||
                        current is GetAllStateSuccessState,
                    builder: (context, state) {
                      if (state is GetAllStateLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is GetAllStateFailedState) {
                        return Center(
                            child: Text(state.message,
                                style: AppTextStyle.f12OutfitBlackW500));
                      }
                      if (state is GetAllStateSuccessState) {
                        return Visibility(
                          visible: state.states.isEmpty ? false : true,
                          child: _buildDynamicDropdown<StateModel>(
                            hintText: 'Select State',
                            value: state.states.isNotEmpty
                                ? state.states.firstWhere(
                                    (stateItem) => stateItem.name == state.name,
                                    orElse: () => state.states.first,
                                  )
                                : null,
                            // Handle empty list case
                            items: state.states,
                            itemBuilder: (stateItem) =>
                                DropdownMenuItem<StateModel>(
                              value: stateItem,
                              child: Text(stateItem.name),
                            ),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                subcategoryCubit.selectState(newValue.name);
                              }
                            },
                          ),
                        );
                      }

                      return Visibility(
                        visible: context.read<SubcategoryCubit>().states.isEmpty
                            ? false
                            : true,
                        child: _buildDynamicDropdown<StateModel>(
                          hintText: context
                                  .read<SubcategoryCubit>()
                                  .SelectedStatename ??
                              'Select State',
                          value:
                              context.read<SubcategoryCubit>().states.isNotEmpty
                                  ? context
                                      .read<SubcategoryCubit>()
                                      .states
                                      .firstWhere(
                                        (stateItem) =>
                                            stateItem.name ==
                                            context
                                                .read<SubcategoryCubit>()
                                                .SelectedStatename,
                                        orElse: () => context
                                            .read<SubcategoryCubit>()
                                            .states
                                            .first,
                                      )
                                  : null,
                          // Handle empty or null list
                          items: context.read<SubcategoryCubit>().states,
                          itemBuilder: (stateItem) =>
                              DropdownMenuItem<StateModel>(
                            value: stateItem,
                            child: Text(stateItem.name),
                          ),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              subcategoryCubit.selectState(newValue.name);
                            }
                          },
                        ),
                      );
                    },
                  ),
                  BlocBuilder<SubcategoryCubit, SubCategoryDetailState>(
                    buildWhen: (previous, current) =>
                        current is GetAllDistrictLoadingState ||
                        current is GetAllDistrictFailedState ||
                        current is GetAllDistrictSuccessState,
                    builder: (context, state) {
                      if (state is GetAllDistrictLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is GetAllDistrictFailedState) {
                        return Center(
                            child: Text(state.message,
                                style: AppTextStyle.f12OutfitBlackW500));
                      }
                      if (state is GetAllDistrictSuccessState) {
                        return Visibility(
                          visible: state.district.isEmpty ? false : true,
                          child: _buildDynamicDropdown<DistrictModel>(
                            hintText: 'Select District',
                            value: state.district.isNotEmpty
                                ? state.district.firstWhere(
                                    (stateItem) => stateItem.name == state.name,
                                    orElse: () => state.district.first,
                                  )
                                : null,
                            // Handle empty list case
                            items: state.district,
                            itemBuilder: (stateItem) =>
                                DropdownMenuItem<DistrictModel>(
                              value: stateItem,
                              child: Text(stateItem.name),
                            ),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                subcategoryCubit.selectdistrict(newValue.name);
                              }
                            },
                          ),
                        );
                      }

                      return Visibility(
                        visible:
                            context.read<SubcategoryCubit>().districts.isEmpty
                                ? false
                                : true,
                        child: _buildDynamicDropdown<DistrictModel>(
                          hintText: context
                                  .read<SubcategoryCubit>()
                                  .SelectedSDistrictname ??
                              'Select District',
                          value: context
                                  .read<SubcategoryCubit>()
                                  .districts
                                  .isNotEmpty
                              ? context
                                  .read<SubcategoryCubit>()
                                  .districts
                                  .firstWhere(
                                    (stateItem) =>
                                        stateItem.name ==
                                        context
                                            .read<SubcategoryCubit>()
                                            .SelectedStatename,
                                    orElse: () => context
                                        .read<SubcategoryCubit>()
                                        .districts
                                        .first,
                                  )
                              : null,
                          items: context.read<SubcategoryCubit>().districts,
                          itemBuilder: (stateItem) =>
                              DropdownMenuItem<DistrictModel>(
                            value: stateItem,
                            child: Text(stateItem.name),
                          ),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              subcategoryCubit.selectdistrict(newValue.name);
                            }
                          },
                        ),
                      );
                    },
                  ),
                  BlocBuilder<SubcategoryCubit, SubCategoryDetailState>(
                    buildWhen: (previous, current) =>
                        current is GetAllOrganizationLoadingState ||
                        current is GetAllOrganizationFailedState ||
                        current is GetAllOrganizationSuccessState,
                    builder: (context, state) {
                      if (state is GetAllOrganizationLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is GetAllOrganizationFailedState) {
                        return Center(
                            child: Text(state.message,
                                style: AppTextStyle.f12OutfitBlackW500));
                      }
                      if (state is GetAllOrganizationSuccessState) {
                        return Visibility(
                          visible: state.organization.isEmpty ? false : true,
                          child: _buildDynamicDropdown<Organization>(
                            hintText: 'Select Organization',

                            value: state.organization.isNotEmpty
                                ? state.organization.firstWhere(
                                    (stateItem) => stateItem.name == state.name,
                                    orElse: () => state.organization.first,
                                  )
                                : null,
                            // Handle empty list case
                            items: state.organization,
                            itemBuilder: (stateItem) =>
                                DropdownMenuItem<Organization>(
                              value: stateItem,
                              child: Text(stateItem.name),
                            ),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                subcategoryCubit
                                    .selectOrganization(newValue.name);
                              }
                            },
                          ),
                        );
                      }

                      return Visibility(
                        visible: context
                                .read<SubcategoryCubit>()
                                .organizations
                                .isEmpty
                            ? false
                            : true,
                        child: _buildDynamicDropdown<Organization>(
                          hintText: context
                                  .read<SubcategoryCubit>()
                                  .SelectedOrganizationname ??
                              'Select Organization',
                          value: context
                                  .read<SubcategoryCubit>()
                                  .organizations
                                  .isNotEmpty
                              ? context
                                  .read<SubcategoryCubit>()
                                  .organizations
                                  .firstWhere(
                                    (stateItem) =>
                                        stateItem.name ==
                                        context
                                            .read<SubcategoryCubit>()
                                            .SelectedStatename,
                                    orElse: () => context
                                        .read<SubcategoryCubit>()
                                        .organizations
                                        .first,
                                  )
                              : null,
                          items: context.read<SubcategoryCubit>().organizations,
                          itemBuilder: (stateItem) =>
                              DropdownMenuItem<Organization>(
                            value: stateItem,
                            child: Text(stateItem.name),
                          ),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              subcategoryCubit
                                  .selectOrganization(newValue.name);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            BlocBuilder<SubcategoryCubit, SubCategoryDetailState>(
              buildWhen: (previous, current) =>
                  current is UpdateProductUsingSubCategorySuccessState ||
                  current is UpdateProductUsingSubCategoryLoadingState ||
                  current is UpdateProductUsingSubCategoryFailedState,
              builder: (context, state) {
                if (state is UpdateProductUsingSubCategoryFailedState) {
                  return const Text(AppStrings.somethingWentWrong);
                }
                if (state is UpdateProductUsingSubCategoryLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is UpdateProductUsingSubCategorySuccessState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: state.organization != null ? true : false,
                        child: Container(
                          margin: const EdgeInsets.all(30),
                          alignment: Alignment.topLeft,
                          child: Text(
                            '${state.organization?.subCategoryName} / ${state.organization?.stateName} / ${state.organization?.districtName} / ${state.orgname} ',
                            style: AppTextStyle.f33darkblue,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(30),
                        alignment: Alignment.topLeft,
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount:
                              ResponsiveWidget.getGridCount(context),
                          padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.sizeOf(context).width < 600
                                  ? 0
                                  : 40),
                          childAspectRatio:
                              MediaQuery.sizeOf(context).width < 600
                                  ? 0.5
                                  : 0.8,
                          crossAxisSpacing:
                              MediaQuery.sizeOf(context).width < 600 ? 20 : 60,
                          mainAxisSpacing:
                              MediaQuery.sizeOf(context).width < 600 ? 10 : 30,
                          children: List.generate(
                            state.products.length,
                            (index) {
                              return ProductGridTile(
                                product: state.products[index],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: Text('No Data'),
                  ),
                );
              },
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicDropdown<T>({
    required String hintText,
    required T? value,
    required List<T> items,
    required DropdownMenuItem<T> Function(T) itemBuilder,
    required void Function(T?) onChanged,
  }) {
    return Container(
      width: MediaQuery.sizeOf(context).width < 600 ? 150 : 200,
      height: 30,
      margin: const EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1F000000), offset: Offset(0, 2), blurRadius: 4)
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(hintText, style: AppTextStyle.f12OutfitBlackW500),
          ),
          value: value,
          items: items.map((item) {
            final dropdownItem = itemBuilder(item);
            return DropdownMenuItem<T>(
              value: dropdownItem.value,
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    (dropdownItem.child as Text).data!,
                    textAlign: TextAlign.center,
                    style:
                        AppTextStyle.f12OutfitBlackW500, // Decreased text size
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          isExpanded: true,
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const VerticalDivider(
                color: Colors.grey,
                thickness: 1,
                indent: 8,
                endIndent: 8,
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
