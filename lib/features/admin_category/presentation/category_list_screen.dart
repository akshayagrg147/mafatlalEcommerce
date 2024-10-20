import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/components/text_btn.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_category/bloc/admin_category_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_category/bloc/admin_category_state.dart';
import 'package:mafatlal_ecommerce/features/admin_category/model/admin_cat_model.dart';
import 'package:mafatlal_ecommerce/features/admin_category/presentation/admin_category_details.dart';
import 'package:mafatlal_ecommerce/features/admin_category/presentation/widgets/add_update_cat.dart';
import 'package:mafatlal_ecommerce/features/admin_category/presentation/widgets/show_delete_confirmation_dialog.dart';

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
                  return LayoutBuilder(builder: (context, constraints) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: constraints.maxWidth > 800
                            ? 800
                            : constraints.maxWidth,
                        height: categories.length * 60 > constraints.maxHeight
                            ? constraints.maxHeight
                            : categories.length * 60,
                        child: DataTable2(
                            border: TableBorder(
                              horizontalInside: BorderSide(
                                  color: AppColors.kGrey200, width: 1),
                              verticalInside: BorderSide(
                                  color: AppColors.kGrey200, width: 1),
                            ),
                            headingRowColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              return AppColors.kGrey200;
                            }),
                            dataRowColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              return AppColors.kWhite;
                            }),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(
                                        0.2), // Light grey shadow with 20% opacity
                                    spreadRadius: 2, // Extent of the shadow
                                    blurRadius: 7, // Blurring effect
                                    offset: Offset(0,
                                        3), // Horizontal and Vertical displacement of the shadow
                                  ),
                                ]),
                            columns: [
                              DataColumn2(
                                  size: ColumnSize.L,
                                  label: Text(
                                    "Category Name",
                                    style: AppTextStyle.f14OutfitBlackW500,
                                  )),
                              DataColumn2(
                                  size: ColumnSize.S,
                                  label: Text(
                                    "SubCategories",
                                    style: AppTextStyle.f14OutfitBlackW500,
                                  )),
                              DataColumn2(
                                  size: ColumnSize.M,
                                  label: Text(
                                    "Actions",
                                    style: AppTextStyle.f14OutfitBlackW500,
                                  )),
                            ],
                            rows: categories
                                .map((e) => DataRow2(cells: [
                                      DataCell(Text(
                                        e.name,
                                        style: AppTextStyle.f14OutfitBlackW500,
                                      )),
                                      DataCell(
                                          TextBtn(
                                            label: "View >",
                                          ), onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    AdminCategoryDetailPage(
                                                      category: e,
                                                    )));
                                      }),
                                      DataCell(Row(
                                        children: [
                                          TextBtn(
                                              label: "Edit",
                                              onTap: () {
                                                final bloc = BlocProvider.of<
                                                        AdminCategoryCubit>(
                                                    context);

                                                showDialog(
                                                    context: context,
                                                    builder: (_) {
                                                      return Center(
                                                        child: AddUpdateCat
                                                            .category(
                                                          bloc: bloc,
                                                          category: e,
                                                        ),
                                                      );
                                                    });
                                              }),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          TextBtn(
                                            label: "Delete",
                                            onTap: () {
                                              ShowDeleteCatConfirmation.show(
                                                  context,
                                                  data: e, onDeleteTap: () {
                                                context
                                                    .read<AdminCategoryCubit>()
                                                    .deleteCategory(e.id);
                                              }, isCategory: true);
                                            },
                                          ),
                                        ],
                                      ))
                                    ]))
                                .toList()),
                      ),
                    );
                  });
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
