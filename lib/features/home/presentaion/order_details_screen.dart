import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/model/order_detail.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/presentation/widgets/customer_details.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/presentation/widgets/order_bill_details.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/presentation/widgets/ordered_productlist.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const route = '/order_details_screen';
  final int orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  OrderDetailModel? order;

  @override
  void initState() {
    context.read<HomeCubit>().fetchOrderDetails(widget.orderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: size.width > 800 ? 500 : double.maxFinite,
          child: Scaffold(
              appBar: AppBar(
                elevation: 5,
                backgroundColor: AppColors.kWhite,
                surfaceTintColor: AppColors.kWhite,
                title: Text("ORD${widget.orderId}",
                    style: AppTextStyle.f16BlackW400),
              ),
              body: BlocConsumer<HomeCubit, HomeState>(
                listener: (context, state) {
                  if (state is FetchOrderDetailsSuccessState) {
                    order = state.orderDetails;
                  }
                },
                buildWhen: (previous, current) =>
                    current is FetchOrderDetailsSuccessState ||
                    current is FetchOrderDetailsLoadingState ||
                    current is FetchOrderDetailsFailedState,
                builder: (context, state) {
                  if (state is FetchOrderDetailsLoadingState) {
                    return const LoadingAnimation();
                  }
                  if (order == null) {
                    return const Center(
                      child: Text(
                        "Order not Found",
                        style: AppTextStyle.f16BlackW600,
                      ),
                    );
                  }
                  return ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      OrderedProductList(
                        orderDetails: order!,
                        showDispatchOrder: false,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomerDetailis(
                          shippingAddress: order!.shipping,
                          billingAddress: order!.billing,
                          customerName: order!.customerName,
                          customerEmail: order!.customerEmail),
                      SizedBox(
                        height: 20,
                      ),
                      OrderBillDetails(
                        orderDetails: order!,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  );
                },
              )),
        ));
  }
}
