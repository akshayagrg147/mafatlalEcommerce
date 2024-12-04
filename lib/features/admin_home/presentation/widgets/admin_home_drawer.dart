import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';

class AdminHomeDrawer extends StatelessWidget {
  final int activePageIndex;
  const AdminHomeDrawer({super.key, required this.activePageIndex});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      backgroundColor: AppColors.kGrey200,
      surfaceTintColor: AppColors.kWhite,
      child: ListView(
        children: [
          ListTile(
            selected: activePageIndex == 0,
            selectedTileColor: AppColors.kWhite,
            onTap: () {
              if (activePageIndex != 0) {
                AutoTabsRouter.of(context).setActiveIndex(0);
              }
            },
            leading: const Icon(Icons.home),
            title: Text(
              "Home",
              style: AppTextStyle.f14OutfitBlackW500,
            ),
          ),
          ListTile(
            selected: activePageIndex == 1,
            selectedTileColor: AppColors.kWhite,
            onTap: () {
              if (activePageIndex != 1) {
                AutoTabsRouter.of(context).setActiveIndex(1);
              }
            },
            leading: const Icon(Icons.inbox),
            title: Text(
              "Orders",
              style: AppTextStyle.f14OutfitBlackW500,
            ),
          ),
          ListTile(
            selected: activePageIndex == 2,
            selectedTileColor: AppColors.kWhite,
            onTap: () async {
              if (activePageIndex != 2) {
                AutoTabsRouter.of(context).setActiveIndex(2);
              }
            },
            leading: const Icon(Icons.local_offer_rounded),
            title: Text(
              "Products",
              style: AppTextStyle.f14OutfitBlackW500,
            ),
          ),
          ListTile(
            selected: activePageIndex == 3,
            selectedTileColor: AppColors.kWhite,
            onTap: () {
              if (activePageIndex != 3) {
                AutoTabsRouter.of(context).setActiveIndex(3);
              }
            },
            leading: const Icon(Icons.group),
            title: Text(
              "Categories",
              style: AppTextStyle.f14OutfitBlackW500,
            ),
          ),
          ListTile(
            selected: activePageIndex == 4,
            selectedTileColor: AppColors.kWhite,
            onTap: () {
              if (activePageIndex != 4) {
                AutoTabsRouter.of(context).setActiveIndex(4);
              }
            },
            leading: const Icon(Icons.business),
            title: Text(
              "Organisation",
              style: AppTextStyle.f14OutfitBlackW500,
            ),
          ),
        ],
      ),
    );
  }
}
