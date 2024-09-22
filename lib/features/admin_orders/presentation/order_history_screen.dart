import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/bloc/admin_orders_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/presentation/widgets/admin_orders_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(largeScreen: largeScreen());
  }

  Widget largeScreen() {
    return BlocProvider<AdminOrderCubit>(
      create: (context) => AdminOrderCubit(),
      child: Navigator(
        initialRoute: "/",
        onGenerateRoute: (settings) {
          if (settings.name == "/") {
            return MaterialPageRoute(builder: (_) => const AdminOrdersScreen());
          }
        },
      ),
    );
  }
}
