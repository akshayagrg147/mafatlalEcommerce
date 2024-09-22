import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/admin_home/presentation/admin_home_screen.dart';
import 'package:mafatlal_ecommerce/features/admin_home/presentation/widgets/admin_header.dart';
import 'package:mafatlal_ecommerce/features/admin_home/presentation/widgets/admin_home_drawer.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/presentation/order_history_screen.dart';
import 'package:mafatlal_ecommerce/features/admin_products/presentation/product_add_update_screen.dart';
import 'package:mafatlal_ecommerce/features/admin_products/presentation/products_home.dart';

class AdminHome extends StatelessWidget {
  static const String route = "/adminHomeScreen";
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(largeScreen: largeScreen(context));
  }

  Widget largeScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kGrey100,
      body: SizedBox.expand(
        child: Column(
          children: [
            AdminHeader(),
            Expanded(
                child: Row(
              children: [
                SizedBox(width: 250, child: AdminHomeDrawer()),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: PageView(
                    scrollDirection: Axis.vertical,
                    controller:
                        CubitsInjector.adminHomeCubit.homePageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      AdminHomeScreen(),
                      OrderHistoryScreen(),
                      ProductHomeScreen(),
                      ProductAddUpdateScreen(),
                    ],
                  ),
                ))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
