import 'package:flutter/material.dart';
import 'package:mafatlal_ecommerce/features/admin_home/presentation/admin_home.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/forgot_password_screen.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/login_screen.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/sign_up_screen.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/splash_screen.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/presentation/subcategory_detail.dart';
import 'package:mafatlal_ecommerce/features/home/model/searchmodel.dart';
import 'package:mafatlal_ecommerce/features/home/model/store_new_model.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/cart_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/category_product_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/home_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/order_details_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/order_history.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/product_details.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/search_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/order_success_widget.dart';

class GenerateRoute {
  static Route<dynamic>? Function(RouteSettings)? onGenerateRoute =
      (RouteSettings settings) {
    if (settings.name?.startsWith(ProductDetailsScreen.route) ?? false) {
      return MaterialPageRoute(
          settings: settings,
          builder: (_) => ProductDetailsScreen(
                productId: settings.arguments as int,
              ));
    }

    switch (settings.name) {
      //Before Login
      case SplashScreen.route:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const SplashScreen());
      case LoginScreen.route:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const LoginScreen());
      case RegistrationScreen.route:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const RegistrationScreen());
      case ForgotPwdScreen.route:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ForgotPwdScreen());
      case HomeScreen.route:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const HomeScreen());
      case ProductDetailsScreen.route:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => ProductDetailsScreen(
                  productId: settings.arguments as int,
                ));
      case SearchScreen.route:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => SearchScreen(
                  products: settings.arguments as List<ProductSearch>?,
                ));
      case CategoryProductScreen.route:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => CategoryProductScreen(
                  category: settings.arguments as Category_new,
                ));

      case SubCategoryDetail.route:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            settings: settings,
            builder: (_) {
              return SubCategoryDetail(
                subcategories:
                    arguments['subcategories'] as List<SubCategory_new>,
                selectedname: arguments['name'] as String,
              );
            });
      case CartScreen.route:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const CartScreen());
      // return TransparentRouteBuilder(
      //     settings: settings, builder: (_) => const CartScreen());
      case OrderSuccess.route:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const OrderSuccess());
      // return TransparentRouteBuilder(
      //     settings: settings, builder: (_) => const OrderSuccess());
      case OrdersHistory.route:
        return TransparentRouteBuilder(
            settings: settings, builder: (_) => const OrdersHistory());
      case OrderDetailsScreen.route:
        return TransparentRouteBuilder(
            settings: settings,
            builder: (_) => OrderDetailsScreen(
                  orderId: settings.arguments as int,
                ));
      //admin
      case AdminHome.route:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const AdminHome());
      default:
        return null;
    }
  };
}

class TransparentRouteBuilder extends PageRoute<void> {
  final WidgetBuilder builder;

  TransparentRouteBuilder({
    required this.builder,
    RouteSettings? settings,
  }) : super(settings: settings, fullscreenDialog: false);

  @override
  bool get opaque => false; // Make the route transparent

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Color? get barrierColor =>
      Colors.black.withOpacity(0.5); // Semi-transparent background

  @override
  String? get barrierLabel => 'Transparent Route';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context); // Build the widget using the builder function
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation, // Fade transition
      child: child,
    );
  }

  @override
  bool get maintainState => true;
}
