import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_category/bloc/admin_category_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_category/bloc/admin_category_state.dart';
import 'package:mafatlal_ecommerce/features/admin_category/model/admin_cat_model.dart';
import 'package:mafatlal_ecommerce/features/admin_category/presentation/widgets/add_update_cat.dart';
import 'package:mafatlal_ecommerce/features/admin_category/presentation/widgets/category_grid_tile.dart';

class AdminCategoryDetailPage extends StatefulWidget {
  final AdminCategory category;

  const AdminCategoryDetailPage({super.key, required this.category});

  @override
  State<AdminCategoryDetailPage> createState() =>
      _AdminCategoryDetailPageState();
}

class _AdminCategoryDetailPageState extends State<AdminCategoryDetailPage> {
  late AdminCategoryCubit adminCategoryCubit;

  final List<AdminCategory> subCategories = [];

  fetchSubCategories() {
    adminCategoryCubit.fetchSubCategories(widget.category.id);
  }

  @override
  initState() {
    super.initState();
    adminCategoryCubit = BlocProvider.of<AdminCategoryCubit>(context);
    fetchSubCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminCategoryCubit, AdminCategoryState>(
      listener: (context, state) {
        if (state is FetchSubCategoriesSuccessState) {
          subCategories.clear();
          subCategories.addAll(state.subCategories);
        }
        if (state is AddSubCategorySuccessState) {
          fetchSubCategories();
        }
      },
      child: ResponsiveWidget(largeScreen: largeScreen()),
    );
  }

  Widget largeScreen() {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.fromLTRB(12, 30, 12, 5),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
                const SizedBox(
                  width: 10,
                ),
                CachedNetworkImage(
                  imageUrl: widget.category.image,
                  width: 50,
                  height: 50,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.category.name,
                  style: AppTextStyle.f18OutfitBlackW500,
                ),
                const Spacer(),
                CustomElevatedButton(
                  width: 120,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Center(
                              child: AddUpdateCat.subCategory(
                                  category: widget.category,
                                  bloc: adminCategoryCubit));
                        });
                  },
                  label: 'Add +',
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: BlocBuilder<AdminCategoryCubit, AdminCategoryState>(
                buildWhen: (previous, current) =>
                    current is FetchSubCategoriesSuccessState ||
                    current is FetchSubCategoriesFailedState ||
                    current is FetchSubCategoriesLoadingState,
                builder: (context, state) {
                  if (state is FetchSubCategoriesLoadingState) {
                    return LoadingAnimation();
                  }
                  if (subCategories.isEmpty) {
                    return Center(
                      child: Text(
                        "No Sub Categories Added Yet",
                        style: AppTextStyle.f18OutfitBlackW500,
                      ),
                    );
                  }
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      crossAxisCount:
                          ResponsiveWidget.getCategoryGridCount(context),
                    ),
                    itemCount: subCategories.length,
                    itemBuilder: (context, index) {
                      return CategoryGridTile.subCategory(
                          data: subCategories[index]);
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
