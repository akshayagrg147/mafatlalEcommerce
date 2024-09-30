import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_category/model/admin_cat_model.dart';
import 'package:mafatlal_ecommerce/features/admin_category/model/admin_org-model.dart';

class ShowDeleteCatConfirmation extends StatelessWidget {
  final AdminCategory data;
  final bool isCategory;
  final VoidCallback onDeleteTap;
  static void show(BuildContext context,
      {required AdminCategory data,
      required bool isCategory,
      required VoidCallback onDeleteTap}) {
    showDialog(
        context: context,
        builder: (_) {
          return Center(
            child: ShowDeleteCatConfirmation(
              data: data,
              isCategory: isCategory,
              onDeleteTap: onDeleteTap,
            ),
          );
        });
  }

  const ShowDeleteCatConfirmation(
      {super.key,
      required this.data,
      required this.isCategory,
      required this.onDeleteTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Are you sure you want to delete ${data.name} ${isCategory ? 'Category' : 'SubCategory'}',
            style: AppTextStyle.f14BlackW500,
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  width: 100,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  label: "Cancel",
                  backgroundColor: AppColors.kGrey,
                  textColor: AppColors.kWhite),
              SizedBox(
                width: 20,
              ),
              CustomElevatedButton(
                  onPressed: () {
                    onDeleteTap.call();
                    Navigator.pop(context);
                  },
                  width: 100,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  label: "Delete",
                  backgroundColor: AppColors.kRed,
                  textColor: AppColors.kWhite),
            ],
          )
        ],
      ),
    );
  }
}

class ShowDeleteOrgConfirmation extends StatelessWidget {
  final AdminOrganisation data;
  final VoidCallback onDeleteTap;
  static void show(BuildContext context,
      {required AdminOrganisation data, required VoidCallback onDeleteTap}) {
    showDialog(
        context: context,
        builder: (_) {
          return Center(
            child: ShowDeleteOrgConfirmation(
              data: data,
              onDeleteTap: onDeleteTap,
            ),
          );
        });
  }

  const ShowDeleteOrgConfirmation(
      {super.key, required this.data, required this.onDeleteTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Are you sure you want to delete ${data.name}',
            style: AppTextStyle.f14BlackW500,
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  width: 100,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  label: "Cancel",
                  backgroundColor: AppColors.kGrey,
                  textColor: AppColors.kWhite),
              SizedBox(
                width: 20,
              ),
              CustomElevatedButton(
                  onPressed: () {
                    onDeleteTap.call();
                    Navigator.pop(context);
                  },
                  width: 100,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  label: "Delete",
                  backgroundColor: AppColors.kRed,
                  textColor: AppColors.kWhite),
            ],
          )
        ],
      ),
    );
  }
}
