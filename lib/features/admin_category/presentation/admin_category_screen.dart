import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/features/admin_category/bloc/admin_category_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_category/presentation/category_list_screen.dart';

class AdminCategoryScreen extends StatelessWidget {
  const AdminCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(largeScreen: largeScreen());
  }

  Widget largeScreen() {
    return BlocProvider<AdminCategoryCubit>(
      create: (context) => AdminCategoryCubit(),
      child: Navigator(
        initialRoute: "/",
        onGenerateRoute: (settings) {
          if (settings.name == "/") {
            return MaterialPageRoute(
                builder: (_) => const AdminCategoryListScreen());
          }
        },
      ),
    );
  }
}
