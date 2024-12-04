import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/login_screen.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/sign_up_screen.dart';
import 'package:mafatlal_ecommerce/features/checkout/presentation/checkout_screen.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/presentation/subcategory_detail.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/cart_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/home_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/order_details_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/order_history.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/order_success_widget.dart';
import 'package:mafatlal_ecommerce/features/product_details/presentaion/product_details.dart';
import 'package:mafatlal_ecommerce/features/search/presentation/search_screen.dart';
import 'package:mafatlal_ecommerce/routes/auto_route/mf_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Route')
class MfRouter extends $MfRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: "/",
          page: SplashScreenRoute.page,
          initial: true,
        ),
        AutoRoute(path: LoginScreen.route, page: LoginScreenRoute.page),
        AutoRoute(
            path: RegistrationScreen.route, page: RegistrationScreenRoute.page),
        AutoRoute(
          path: HomeScreen.route,
          page: HomeScreenRoute.page,
        ),

        AutoRoute(
            path: SubCategoryDetail.route, page: SubCategoryDetailRoute.page),
        AutoRoute(
            path: "${ProductDetails.route}/:productId",
            page: ProductDetailsRoute.page),
        AutoRoute(path: SearchScreen.route, page: SearchScreenRoute.page),
        AutoRoute(path: CartScreen.route, page: CartScreenRoute.page),
        AutoRoute(path: CheckoutScreen.route, page: CheckoutScreenRoute.page),
        AutoRoute(path: OrderSuccess.route, page: OrderSuccessRoute.page),
        AutoRoute(
          path: OrdersHistory.route,
          page: OrdersHistoryRoute.page,
        ),
        AutoRoute(
          path: "${OrderDetailsScreen.route}/:orderId",
          page: OrderDetailsScreenRoute.page,
        ),

        // //admin
        // AutoRoute(path: AdminHome.route, page: AdminHomeRoute.page, children: [
        //   AutoRoute(path: '', page: AdminDashboardRoute.page),
        //   AutoRoute(
        //       path: OrdersPage.route,
        //       page: OrdersPageRoute.page,
        //       children: [
        //         AutoRoute(path: '', page: AdminOrdersHistoryScreenRoute.page),
        //         AutoRoute(
        //             path: "${AdminOrderDetailsScreen.route}/:orderId",
        //             page: AdminOrderDetailsScreenRoute.page),
        //       ]),
        //   AutoRoute(
        //       path: AdminProductsPage.route,
        //       page: AdminProductsPageRoute.page,
        //       children: [
        //         AutoRoute(path: '', page: ProductListScreenRoute.page),
        //         AutoRoute(
        //             path: ProductAddUpdateScreen.route,
        //             page: ProductAddUpdateScreenRoute.page),
        //       ]),
        //   AutoRoute(
        //       path: AdminCategoryPage.route,
        //       page: AdminCategoryPageRoute.page,
        //       children: [
        //         AutoRoute(path: '', page: AdminCategoryListScreenRoute.page),
        //         AutoRoute(
        //             path: AdminCategoryDetailPage.route,
        //             page: AdminCategoryDetailPageRoute.page),
        //       ]),
        //   AutoRoute(
        //       path: AdminOrganisationScreen.route,
        //       page: AdminOrganisationScreenRoute.page,
        //       children: [
        //         AutoRoute(path: '', page: OrganisationListScreenRoute.page),
        //       ]),
        // ]),
      ];
}

class TransparentRoutePage<T> extends Page<T> {
  final Widget child;

  const TransparentRoutePage({
    required this.child,
    super.key,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      opaque: false,
      barrierDismissible: false,
    );
  }
}
