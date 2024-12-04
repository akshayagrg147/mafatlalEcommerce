import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/features/product_details/bloc/product_detail_cubit.dart';
import 'package:mafatlal_ecommerce/features/product_details/presentaion/product_detail_screen.dart';

@RoutePage()
class ProductDetails extends StatelessWidget {
  static const String route = "/productDetails";
  final int productId;
  const ProductDetails({super.key, @PathParam() required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductDetailsCubit>(
      create: (_) => ProductDetailsCubit(),
      child: ProductDetailsScreen(
        productId: productId,
      ),
    );
  }
}
