import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/features/admin_products/bloc/admin_product_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_products/presentation/product_list_screen.dart';

class ProductHomeScreen extends StatelessWidget {
  const ProductHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(largeScreen: largeScreen());
  }

  Widget largeScreen() {
    return BlocProvider<AdminProductCubit>(
      create: (context) => AdminProductCubit(),
      child: Navigator(
        initialRoute: "/",
        onGenerateRoute: (settings) {
          if (settings.name == "/") {
            return MaterialPageRoute(builder: (_) => const ProductListScreen());
          }
        },
      ),
    );
  }
}
