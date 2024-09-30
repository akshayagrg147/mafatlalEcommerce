import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_category/bloc/admin_category_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_category/model/admin_org-model.dart';
import 'package:mafatlal_ecommerce/features/admin_category/presentation/widgets/add_update_organisation.dart';
import 'package:mafatlal_ecommerce/features/admin_category/presentation/widgets/show_delete_confirmation_dialog.dart';

class OrganisationGridTile extends StatelessWidget {
  final AdminOrganisation data;

  const OrganisationGridTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        border: Border.all(color: AppColors.kGrey200),
      ),
      child: SizedBox.expand(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 25, 12, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 2,
                      child: CachedNetworkImage(
                        imageUrl: data.image ?? '',
                        errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.error, color: AppColors.kBlack)),
                      )),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.name ?? '',
                          maxLines: 2,
                          style: AppTextStyle.f16OutfitBlackW500,
                        ),
                        if (data.stateName != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              'State :- ${data.stateName}',
                              style: AppTextStyle.f16OutfitBlackW500,
                            ),
                          ),
                        if (data.districtName != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              'District :- ${data.districtName}',
                              style: AppTextStyle.f16OutfitBlackW500,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      final bloc = BlocProvider.of<AdminCategoryCubit>(context);

                      showDialog(
                          context: context,
                          builder: (_) {
                            return Center(
                              child: AddUpdateorganisation(
                                bloc: bloc,
                                organisation: data,
                              ),
                            );
                          });
                    },
                    icon: const Icon(Icons.edit),
                    color: AppColors.kGreen,
                  ),
                  IconButton(
                    onPressed: () {
                      ShowDeleteOrgConfirmation.show(context,
                          data: data, onDeleteTap: () {});
                    },
                    icon: const Icon(Icons.delete),
                    color: AppColors.kRed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
