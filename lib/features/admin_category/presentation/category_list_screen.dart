import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_category/bloc/admin_category_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_category/bloc/admin_category_state.dart';
import 'package:mafatlal_ecommerce/features/admin_category/model/admin_cat_model.dart';
import 'package:mafatlal_ecommerce/features/admin_category/presentation/admin_category_details.dart';
import 'package:mafatlal_ecommerce/features/admin_category/presentation/widgets/add_update_cat.dart';
import 'package:mafatlal_ecommerce/features/admin_category/presentation/widgets/category_grid_tile.dart';

class AdminCategoryListScreen extends StatefulWidget {
  const AdminCategoryListScreen({super.key});

  @override
  State<AdminCategoryListScreen> createState() =>
      _AdminCategoryListScreenState();
}

class _AdminCategoryListScreenState extends State<AdminCategoryListScreen> {
  final List<AdminCategory> categories = [];
  late AdminCategoryCubit adminCategoryCubit;

  @override
  void initState() {
    adminCategoryCubit = BlocProvider.of<AdminCategoryCubit>(context);
    fetchCategories();
    super.initState();
  }

  void fetchCategories() {
    context.read<AdminCategoryCubit>().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminCategoryCubit, AdminCategoryState>(
      listener: (context, state) {
        if (state is FetchCategoriesSuccessState) {
          categories.clear();
          categories.addAll(state.categories);
        }
        if (state is AddCategorySuccessState) {
          fetchCategories();
        }
      },
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.fromLTRB(12, 30, 12, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Categories",
                  style: AppTextStyle.f18OutfitBlackW500,
                ),
                const Spacer(),
                CustomElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return Center(
                                child: AddUpdateCat.category(
                                    bloc: adminCategoryCubit));
                          });
                    },
                    width: 120,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    label: "Add +",
                    backgroundColor: AppColors.kBlack,
                    textColor: AppColors.kWhite),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: BlocBuilder<AdminCategoryCubit, AdminCategoryState>(
                buildWhen: (previous, current) =>
                    current is FetchCategoriesSuccessState ||
                    current is FetchCategoriesFailedState ||
                    current is FetchCategoriesLoadingState,
                builder: (context, state) {
                  if (state is FetchCategoriesLoadingState) {
                    return LoadingAnimation();
                  }
                  if (categories.isEmpty) {
                    return Center(
                      child: Text(
                        "No Categories Added Yet",
                        style: AppTextStyle.f18OutfitBlackW500,
                      ),
                    );
                  }
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      crossAxisCount:
                          ResponsiveWidget.getCategoryGridCount(context),
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AdminCategoryDetailPage(
                                          category: categories[index],
                                        )));
                          },
                          child: CategoryGridTile.category(
                              data: categories[index]));
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
