import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/core/size_config.dart';
import 'package:mafatlal_ecommerce/features/auth/bloc/auth_cubit.dart';
import 'package:mafatlal_ecommerce/features/auth/bloc/auth_state.dart';
import 'package:mafatlal_ecommerce/features/auth/presentaion/login_screen.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/drawer.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/header.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/home_appbar.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/home_body.dart';

class HomeScreen extends StatefulWidget {
  static const String route = "/homeScreen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeKey = GlobalKey<ScaffoldState>();
  late HomeCubit homeCubit;

  @override
  void initState() {
    homeCubit = BlocProvider.of<HomeCubit>(context);
    homeCubit.fetchStoreData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogoutState) {
          Navigator.pushNamedAndRemoveUntil(
              context, LoginScreen.route, (route) => false);
        }
      },
      child: ResponsiveWidget(
        largeScreen: largeScreen(),
        smallScreen: smallScreen(),
      ),
    );
  }

  Widget largeScreen() {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: const Header(),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Navigator(
          key: CubitsInjector.homeCubit.homeNavigatorKey,
          initialRoute: "/",
          onGenerateRoute: (settings) {
            if (settings.name == "/") {
              return MaterialPageRoute(
                  builder: (_) => const HomeBody(isWeb: true));
            }
          },
        ),
      ),
    );
  }

  Widget smallScreen() {
    return SafeArea(
        child: Scaffold(
      key: _homeKey,
      appBar: HomeAppBar(
        onMenuTap: () {
          if (CubitsInjector.authCubit.currentUser != null) {
            _homeKey.currentState?.openDrawer();
          } else {
            Navigator.pushNamed(context, LoginScreen.route);
          }
        },
      ),
      drawer: const HomeDrawer(),
      body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: HomeBody(
            isWeb: false,
          )),
    ));
  }
}
