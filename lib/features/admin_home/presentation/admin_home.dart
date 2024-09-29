import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/admin_category/presentation/admin_category_screen.dart';
import 'package:mafatlal_ecommerce/features/admin_home/presentation/admin_home_screen.dart';
import 'package:mafatlal_ecommerce/features/admin_home/presentation/widgets/admin_header.dart';
import 'package:mafatlal_ecommerce/features/admin_home/presentation/widgets/admin_home_drawer.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/presentation/order_history_screen.dart';
import 'package:mafatlal_ecommerce/features/admin_products/presentation/products_home.dart';
import 'package:mafatlal_ecommerce/features/auth/bloc/auth_cubit.dart';
import 'package:mafatlal_ecommerce/features/auth/bloc/auth_state.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/login_screen.dart';

class AdminHome extends StatelessWidget {
  static const String route = "/adminHomeScreen";

  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(largeScreen: largeScreen(context));
  }

  Widget largeScreen(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogoutState) {
          Navigator.pushNamedAndRemoveUntil(
              context, LoginScreen.route, (route) => false);
        }
      },
      child: Scaffold(
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
                        AdminCategoryScreen()
                      ],
                    ),
                  ))
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
