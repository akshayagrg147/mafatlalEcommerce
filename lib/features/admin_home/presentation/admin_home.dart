import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/features/admin_home/presentation/widgets/admin_header.dart';
import 'package:mafatlal_ecommerce/features/admin_home/presentation/widgets/admin_home_drawer.dart';
import 'package:mafatlal_ecommerce/features/auth/bloc/auth_cubit.dart';
import 'package:mafatlal_ecommerce/features/auth/bloc/auth_state.dart';
import 'package:mafatlal_ecommerce/routes/auto_route/mf_router.gr.dart';

@RoutePage()
class AdminHome extends StatelessWidget {
  static const String route = "/dashboard";

  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(largeScreen: largeScreen(context));
  }

  Widget largeScreen(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogoutState) {
          context.router.pushAndPopUntil(const LoginScreenRoute(),
              predicate: (route) => false);
        }
      },
      child: Scaffold(
          backgroundColor: AppColors.kGrey100,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: AdminHeader(),
          ),
          body: AutoTabsRouter(
            routes: [
              AdminDashboardRoute(),
              OrdersPageRoute(),
              AdminProductsPageRoute(),
              AdminCategoryPageRoute(),
              AdminOrganisationScreenRoute()
            ],
            builder: (context, child) {
              return Row(
                children: [
                  SizedBox(
                      width: 250,
                      child: AdminHomeDrawer(
                        activePageIndex: AutoTabsRouter.of(context).activeIndex,
                      )),
                  Expanded(child: child)
                  // Expanded(
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 12),
                  //       child: PageView(
                  //         scrollDirection: Axis.vertical,
                  //         controller: CubitsInjector.adminHomeCubit.homePageController,
                  //         physics: const NeverScrollableScrollPhysics(),
                  //         children: [
                  //           AdminDashboard(),
                  //           OrderHistoryScreen(),
                  //           ProductHomeScreen(),
                  //           AdminCategoryScreen(),
                  //           AdminOrganisationScreen()
                  //         ],
                  //       ),
                  //     ))
                ],
              );
            },
          )),
    );
  }
}
