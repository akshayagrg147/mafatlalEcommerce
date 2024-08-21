import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/category_product_screen.dart';
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
    return ResponsiveWidget(
      largeScreen: largeScreen(),
      smallScreen: smallScreen(),
    );
  }

  Widget largeScreen() {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: const Header(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {},
          buildWhen: (previous, current) =>
              current is UpdateHomeWidgetState || current is ShowHomeWidget,
          builder: (context, state) {
            if (state is UpdateHomeWidgetState) {
              return Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 1280,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                CubitsInjector.homeCubit.showHomeWidget();
                              },
                              icon: Icon(Icons.arrow_back)),
                          SizedBox(
                            width: 50,
                          ),
                          Text(
                            state.category.name,
                            style: AppTextStyle.f16OutfitBlackW500,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: CategoryProductScreen(
                          category: state.category,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return HomeBody(
              isWeb: true,
            );
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
          _homeKey.currentState?.openDrawer();
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
