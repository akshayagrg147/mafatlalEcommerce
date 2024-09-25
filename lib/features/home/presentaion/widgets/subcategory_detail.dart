import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/asset_path.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/model/organization_model.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/footer_widget.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/home_banner.dart';

class SubCategoryDetail extends StatefulWidget {
  static const String route = "/SubCategoryDetail";
  final int subid;

  const SubCategoryDetail({super.key, required this.subid});

  @override
  State<SubCategoryDetail> createState() => _SubCategoryDetailState();
}

class _SubCategoryDetailState extends State<SubCategoryDetail> {
  late HomeCubit homeCubit;
  Organization? selectedOrganization;

  @override
  void initState() {
    super.initState();
    homeCubit = BlocProvider.of<HomeCubit>(context);
    homeCubit.getsubcategorydetails(widget.subid);
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
          BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) =>
                current is GetSubCategoryDetailScreenSuccessState ||
                current is GetSubCategoryDetailScreenFailedState ||
                current is GetSubCategoryDetailScreenLoadingState,
            builder: (context, state) {
              if (state is GetSubCategoryDetailScreenLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is GetSubCategoryDetailScreenFailedState) {
                return Center(
                    child: Text(
                  state.message,
                  style: AppTextStyle.f12OutfitBlackW500,
                ));
              }
              if (state is GetSubCategoryDetailScreenSuccessState) {
                return Container(
                  height: 100,
                  width: double.maxFinite,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.organization.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.only(top: 20, left: 48),
                        width: 327,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            const BoxShadow(
                              color: Color(0x1F000000),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Organization>(
                            hint: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text('Select an organization'),
                            ),
                            value: selectedOrganization,
                            items: state.organization.map((Organization org) {
                              return DropdownMenuItem<Organization>(
                                value: org,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Text(org
                                      .name), // Assuming Organization has a 'name' property
                                ),
                              );
                            }).toList(),
                            onChanged: (Organization? newValue) {
                              setState(() {
                                selectedOrganization = newValue;
                              });
                            },
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.black),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return const Center(
                child: Text(
                  'No Data',
                  style: AppTextStyle.f16BlackW400,
                ),
              );
            },
          ),
          const Footer(),
        ],
      ),
    );
  }
}
