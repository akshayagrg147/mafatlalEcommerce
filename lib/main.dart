import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/splash_screen.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/helper/shared_preference_helper.dart';
import 'package:mafatlal_ecommerce/routes/app_routes.dart';

void main() async {
  CubitsInjector();
  WidgetsFlutterBinding.ensureInitialized();

  CartHelper.init();
  await SharedPreferencesHelper.instance.init();
  CubitsInjector.authCubit.getCurrentUser();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: CubitsInjector.blocProviders,
        child: MaterialApp(
          title: 'Mafatlal Store',
          theme: ThemeData(
            textTheme: GoogleFonts.robotoTextTheme(
              Theme.of(context).textTheme,
            ),
            scaffoldBackgroundColor: AppColors.kGrey50,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: SplashScreen.route,
          onGenerateRoute: GenerateRoute.onGenerateRoute,
        ));
  }
}
