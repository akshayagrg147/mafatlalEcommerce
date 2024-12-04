import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/features/admin_category/bloc/admin_category_cubit.dart';

@RoutePage()
class AdminCategoryPage extends StatelessWidget {
  static const String route = "categories";
  const AdminCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminCategoryCubit>(
        create: (context) => AdminCategoryCubit(), child: const AutoRouter());
  }
}
