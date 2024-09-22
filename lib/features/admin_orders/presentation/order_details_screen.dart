import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/components/responsive_screen.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/bloc/admin_orders_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/bloc/admin_orders_state.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/model/order_detail.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/presentation/widgets/customer_details.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/presentation/widgets/order_bill_details.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/presentation/widgets/ordered_productlist.dart';
import 'package:mafatlal_ecommerce/helper/utils.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  OrderDetailModel? orderDetails;

  @override
  void initState() {
    context.read<AdminOrderCubit>().fetchOrderDetails(widget.orderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminOrderCubit, AdminOrderState>(
      listener: (context, state) {
        if (state is FetchOrderDetailsSuccessState) {
          orderDetails = state.orderDetails;
        }
      },
      child: ResponsiveWidget(largeScreen: largeScreen()),
    );
  }

  Widget largeScreen() {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        width: size.width > 1000 ? 1000 : double.maxFinite,
        height: double.maxFinite,
        child: Column(
          children: [
            const SizedBox(
              height: 35,
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "#ORD${widget.orderId}",
                  style: AppTextStyle.f18OutfitBlackW500,
                )
              ],
            ),
            Expanded(
              child: BlocBuilder<AdminOrderCubit, AdminOrderState>(
                  buildWhen: (previous, current) =>
                      current is FetchOrderDetailsLoadingState ||
                      current is FetchOrderDetailsSuccessState ||
                      current is FetchOrderDetailsFailedState,
                  builder: (context, state) {
                    if (state is FetchOrderDetailsLoadingState) {
                      return const LoadingAnimation();
                    }

                    return ListView(
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 40,
                            ),
                            Text(
                              Utils.formatDateTime(orderDetails!.orderPlaced),
                              style: AppTextStyle.f12outfitGreyW600,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 7,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    OrderedProductList(
                                      orderDetails: orderDetails!,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    OrderBillDetails(
                                      orderDetails: orderDetails!,
                                    )
                                  ],
                                )),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 3,
                              child: CustomerDetailis(
                                  shippingAddress: orderDetails!.shipping,
                                  billingAddress: orderDetails!.billing,
                                  customerName: orderDetails!.customerName,
                                  customerEmail: orderDetails!.customerEmail),
                            ),
                          ],
                        )
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
