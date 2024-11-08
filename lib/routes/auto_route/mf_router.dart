import 'package:auto_route/auto_route.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/login_screen.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/sign_up_screen.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/home_screen.dart';
import 'package:mafatlal_ecommerce/routes/auto_route/mf_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Route')
class MfRouter extends $MfRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: "/",
          page: SplashRoute.page,
          initial: true,
        ),
        AutoRoute(
          path: HomeScreen.route,
          page: HomeRoute.page,
        ),
        AutoRoute(path: LoginScreen.route, page: LoginRoute.page),
        AutoRoute(path: RegistrationScreen.route, page: RegistrationRoute.page),
      ];
}
