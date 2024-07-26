import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/splash_screen.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/routes/app_routes.dart';

import 'core/size_config.dart';

void main() {
  CubitsInjector();
  WidgetsFlutterBinding.ensureInitialized();

  CartHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: CubitsInjector.blocProviders,
      child: ScreenUtilInit(
          designSize: SizeConfig.screenSize(context),
          builder: (context, child) {
            return LayoutBuilder(builder: (context, constraints) {
              return OrientationBuilder(builder: (context, orientation) {
                SizeConfig().init(constraints, orientation);
                return MaterialApp(
                  title: 'Mafatlal Store',
                  theme: ThemeData(
                    scaffoldBackgroundColor: AppColors.kGrey50,
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                    useMaterial3: true,
                  ),
                  initialRoute: SplashScreen.route,
                  onGenerateRoute: GenerateRoute.onGenerateRoute,
                );
              });
            });
          }),
    );
  }
}
