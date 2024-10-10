import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_category/bloc/admin_category_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_category/bloc/admin_category_state.dart';
import 'package:mafatlal_ecommerce/features/admin_category/model/admin_org-model.dart';
import 'package:mafatlal_ecommerce/features/admin_category/presentation/widgets/add_update_organisation.dart';
import 'package:mafatlal_ecommerce/features/admin_category/presentation/widgets/organisation_grid_tile.dart';

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
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 2,
                      crossAxisCount:
                          ResponsiveWidget.getOrganisationGridCount(context),
                    ),
                    itemCount: organisation.length,
                    itemBuilder: (context, index) {
                      return OrganisationGridTile(data: organisation[index]);
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
