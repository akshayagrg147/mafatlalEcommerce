import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_state.dart';
import 'package:mafatlal_ecommerce/features/home/model/order.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/delivery_status.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/rounded_shoppingbag.dart';
import 'package:mafatlal_ecommerce/helper/utils.dart';

class OrdersHistory extends StatefulWidget {
  static const String route = "/ordersHistory";
  const OrdersHistory({super.key});

  @override
  State<OrdersHistory> createState() => _OrdersHistoryState();
}

class _OrdersHistoryState extends State<OrdersHistory> {
  final List<Order> orders = [];

  @override
  void initState() {
    CubitsInjector.homeCubit.fetchOrderhistory();
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
                title:
                    const Text("Your Orders", style: AppTextStyle.f16BlackW400),
              ),
              body: BlocConsumer<HomeCubit, HomeState>(
                listener: (context, state) {
                  if (state is FetchOrdersSuccessState) {
                    orders.clear();
                    orders.addAll(state.orders);
                  }
                },
                buildWhen: (previous, current) =>
                    current is FetchOrdersSuccessState ||
                    current is FetchOrdersLoadingState ||
                    current is FetchOrdersFailedState,
                builder: (context, state) {
                  if (state is FetchOrdersLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.kOrange,
                      ),
                    );
                  }
                  if (orders.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Orders Placed",
                        style: AppTextStyle.f16BlackW600,
                      ),
                    );
                  }
                  return ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const RoundedShoppingBag(),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "ORD${order.orderId} . ₹${order.price}",
                                    style: AppTextStyle.f16OutfitBlackW500,
                                  ),
                                  Text(
                                    "Placed on ${Utils.formatDateTime(order.createdOn)}",
                                    style: AppTextStyle.f10outfitGreyW500,
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              DeliveryStatus(status: order.orderStatus),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.kGrey),
                                    color: AppColors.kWhite,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    'View Details',
                                    style: AppTextStyle.f14OutfitGreyW500,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Divider(
                            height: 50,
                            thickness: 2,
                            color: AppColors.kGrey200,
                          ),
                        );
                      },
                      itemCount: orders.length);
                },
              )),
        ));
  }
}
