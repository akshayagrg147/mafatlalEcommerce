import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/constants/asset_path.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/bloc/subcategory_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/bloc/subcategory_state.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/model/organization_model.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/footer_widget.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/home_banner.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/product_grid_tile.dart';

class SubCategoryDetail extends StatefulWidget {
  static const String route = "/SubCategoryDetail";
  final int subid;

  const SubCategoryDetail({super.key, required this.subid});

  @override
  State<SubCategoryDetail> createState() => _SubCategoryDetailState();
}

class _SubCategoryDetailState extends State<SubCategoryDetail> {
  late SubcategoryCubit subcategoryCubit;

  @override
  void initState() {
    super.initState();
    subcategoryCubit = BlocProvider.of<SubcategoryCubit>(context);
    subcategoryCubit.getsubcategorydetails(widget.subid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveWidget(largeScreen: largeScreen()),
    );
  }

  Widget largeScreen() {
    final List<String> bannerImages = [
      AssetPath.banner1,
      AssetPath.banner2,
      AssetPath.banner3,
    ];
    return SingleChildScrollView(
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
          BlocBuilder<SubcategoryCubit, SubCategoryDetailState>(
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
                return Container(
                  alignment: Alignment.center,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1F004392),
                        // #0043921F in Flutter's color format (with opacity)
                        offset: Offset(0, 8),
                        // X and Y offset for the shadow
                        blurRadius: 24.0, // The blur effect for the shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildDropdown(
                        hintText: 'Select a Subcategory',
                        value: state.selectedSubCategory,
                        items: state.organizations.map((org) {
                          return DropdownMenuItem<Organization>(
                            value: org,
                            child: Text(org.subCategoryName),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          subcategoryCubit.selectSubCategory(newValue);
                        },
                      ),
                      _buildDropdown(
                        hintText: 'Select a District',
                        value: state.selectedDistrict,
                        items: state.organizations.map((org) {
                          return DropdownMenuItem<Organization>(
                            value: org,
                            child: Text(org.districtName),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          subcategoryCubit.selectDistrict(newValue);
                        },
                      ),
                      _buildDropdown(
                        hintText: 'Select a State',
                        value: state.selectedState,
                        items: state.organizations.map((org) {
                          return DropdownMenuItem<Organization>(
                            value: org,
                            child: Text(org.stateName),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          subcategoryCubit.selectState(newValue);
                        },
                      ),
                      _buildDropdown(
                        hintText: 'Select an Organization',
                        value: state.selectedOrganization,
                        items: state.organizations.map((org) {
                          return DropdownMenuItem<Organization>(
                            value: org,
                            child: Text(org.name),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          subcategoryCubit.selectOrganization(newValue);
                        },
                      ),
                    ],
                  ),
                );
              }
              return const Center(
                child: Text('No Data', style: AppTextStyle.f16BlackW400),
              );
            },
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
                    Container(
                      margin: const EdgeInsets.all(30),
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${state.organization.subCategoryName} / ${state.organization.stateName} / ${state.organization.districtName} / ${state.organization.name} ',
                        style: AppTextStyle.f33darkblue,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(30),
                      alignment: Alignment.topLeft,
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: ResponsiveWidget.getGridCount(context),
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 18,
                        crossAxisSpacing: 42,
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
    );
  }

  Widget _buildDropdown({
    required String hintText,
    required Organization? value,
    required List<DropdownMenuItem<Organization>> items,
    required void Function(Organization?) onChanged,
  }) {
    return Container(
      width: 200,
      height: 30,
      margin: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1F000000), offset: Offset(0, 2), blurRadius: 4)
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Organization>(
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(hintText, style: AppTextStyle.f12OutfitBlackW500),
          ),
          value: value,
          items: items,
          onChanged: (newValue) {
            onChanged(newValue);
            print('Selected: ${newValue?.name ?? 'None'}'); // Debugging
          },
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
        ),
      ),
    );
  }
}
