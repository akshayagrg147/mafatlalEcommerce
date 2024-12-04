import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/bloc/admin_orders_cubit.dart';

@RoutePage()
class OrdersPage extends StatelessWidget {
  static const String route = "orders";
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminOrderCubit>(
      create: (_) => AdminOrderCubit(),
      child: const AutoRouter(),
    );
  }
}
