import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/features/admin_products/bloc/admin_product_cubit.dart';

@RoutePage()
class AdminProductsPage extends StatelessWidget {
  static const String route = "products";
  const AdminProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminProductCubit>(
        create: (context) => AdminProductCubit(), child: const AutoRouter());
  }
}
