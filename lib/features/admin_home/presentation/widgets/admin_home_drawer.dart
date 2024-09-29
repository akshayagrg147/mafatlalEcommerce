import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/admin_home/bloc/admin_home_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_home/bloc/admin_home_state.dart';

class AdminHomeDrawer extends StatelessWidget {
  const AdminHomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminHomeCubit, AdminHomeState>(
      buildWhen: (previous, current) {
        return current is UpdateDrawerPage;
      },
      builder: (context, state) {
        return Drawer(
          backgroundColor: AppColors.kGrey200,
          surfaceTintColor: AppColors.kWhite,
          child: ListView(
            children: [
              ListTile(
                selected: state is UpdateDrawerPage ? state.page == 0 : true,
                selectedTileColor: AppColors.kWhite,
                onTap: () {
                  CubitsInjector.adminHomeCubit.updatePageIndex(0);
                },
                leading: const Icon(Icons.home),
                title: Text(
                  "Home",
                  style: AppTextStyle.f14OutfitBlackW500,
                ),
              ),
              ListTile(
                selected: state is UpdateDrawerPage ? state.page == 1 : false,
                selectedTileColor: AppColors.kWhite,
                onTap: () {
                  CubitsInjector.adminHomeCubit.updatePageIndex(1);
                },
                leading: const Icon(Icons.inbox),
                title: Text(
                  "Orders",
                  style: AppTextStyle.f14OutfitBlackW500,
                ),
              ),
              ListTile(
                selected: state is UpdateDrawerPage ? state.page == 2 : false,
                selectedTileColor: AppColors.kWhite,
                onTap: () async {
                  CubitsInjector.adminHomeCubit.updatePageIndex(2);
                },
                leading: const Icon(Icons.local_offer_rounded),
                title: Text(
                  "Products",
                  style: AppTextStyle.f14OutfitBlackW500,
                ),
              ),
              ListTile(
                selected: state is UpdateDrawerPage ? state.page == 3 : false,
                selectedTileColor: AppColors.kWhite,
                onTap: () {
                  CubitsInjector.adminHomeCubit.updatePageIndex(3);
                },
                leading: const Icon(Icons.group),
                title: Text(
                  "Categories",
                  style: AppTextStyle.f14OutfitBlackW500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
