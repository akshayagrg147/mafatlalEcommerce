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
import 'package:mafatlal_ecommerce/features/admin_category/model/admin_org-model.dart';
import 'package:mafatlal_ecommerce/features/admin_category/presentation/widgets/add_update_organisation.dart';
import 'package:mafatlal_ecommerce/features/admin_category/presentation/widgets/show_delete_confirmation_dialog.dart';

class OrganisationListScreen extends StatefulWidget {
  const OrganisationListScreen({super.key});

  @override
  State<OrganisationListScreen> createState() => _OrganisationListScreenState();
}

class _OrganisationListScreenState extends State<OrganisationListScreen> {
  final List<AdminOrganisation> organisation = [];
  late AdminCategoryCubit adminCategoryCubit;

  @override
  void initState() {
    adminCategoryCubit = BlocProvider.of<AdminCategoryCubit>(context);
    fetchOrganisations();
    super.initState();
  }

  void fetchOrganisations() {
    context.read<AdminCategoryCubit>().fetchOrganisation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminCategoryCubit, AdminCategoryState>(
      listener: (context, state) {
        if (state is FetchOrganisationSuccessState) {
          organisation.clear();
          organisation.addAll(state.organisations);
        }
        if (state is AddOrganisationSuccessState) {
          fetchOrganisations();
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
                  "Organisations",
                  style: AppTextStyle.f18OutfitBlackW500,
                ),
                const Spacer(),
                CustomElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return Center(
                                child: AddUpdateorganisation(
                                    bloc: adminCategoryCubit));
                          });
                    },
                    width: 120,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
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
                    current is FetchOrganisationSuccessState ||
                    current is FetchOrganisationFailedState ||
                    current is FetchOrganisationLoadingState,
                builder: (context, state) {
                  if (state is FetchOrganisationLoadingState) {
                    return const LoadingAnimation();
                  }
                  if (organisation.isEmpty) {
                    return Center(
                      child: Text(
                        "No Organisations Added Yet",
                        style: AppTextStyle.f18OutfitBlackW500,
                      ),
                    );
                  }
                  return LayoutBuilder(builder: (context, constraints) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        height: organisation.length * 60 > constraints.maxHeight
                            ? constraints.maxHeight
                            : organisation.length * 60,
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
                                    "Organization Name",
                                    style: AppTextStyle.f14OutfitBlackW500,
                                  )),
                              DataColumn2(
                                  size: ColumnSize.M,
                                  label: Text(
                                    "State",
                                    style: AppTextStyle.f14OutfitBlackW500,
                                  )),
                              DataColumn2(
                                  size: ColumnSize.M,
                                  label: Text(
                                    "District",
                                    style: AppTextStyle.f14OutfitBlackW500,
                                  )),
                              DataColumn2(
                                  size: ColumnSize.M,
                                  label: Text(
                                    "Actions",
                                    style: AppTextStyle.f14OutfitBlackW500,
                                  )),
                            ],
                            rows: organisation
                                .map((e) => DataRow2(cells: [
                                      DataCell(Text(
                                        e.name,
                                        style: AppTextStyle.f14OutfitBlackW500,
                                      )),
                                      DataCell(Text(
                                        e.stateName ?? "NA",
                                        style: AppTextStyle.f14OutfitBlackW500,
                                      )),
                                      DataCell(Text(
                                        e.districtName ?? "NA",
                                        style: AppTextStyle.f14OutfitBlackW500,
                                      )),
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
                                                        child:
                                                            AddUpdateorganisation(
                                                          bloc: bloc,
                                                          organisation: e,
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
                                              ShowDeleteOrgConfirmation.show(
                                                  context,
                                                  data: e, onDeleteTap: () {
                                                context
                                                    .read<AdminCategoryCubit>()
                                                    .deleteOrganisation(e.id);
                                              });
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
