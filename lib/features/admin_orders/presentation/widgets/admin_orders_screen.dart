import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/elevated_btn_with_icon.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/bloc/admin_orders_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/bloc/admin_orders_state.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/model/order_model.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/presentation/order_details_screen.dart';
import 'package:mafatlal_ecommerce/helper/utils.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final List<OrderModel> orders = [];
  int page = 1;
  int totalPage = 1;

  @override
  void initState() {
    context.read<AdminOrderCubit>().fetchOrders(page);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(12, 30, 12, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Orders",
            style: AppTextStyle.f18OutfitBlackW500,
          ),
          SizedBox(
            height: 35,
          ),
          Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: AppColors.kWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(0.7), // Shadow color with opacity
                      spreadRadius: 3, // How much the shadow spreads
                      blurRadius: 5, // Blurring effect
                      offset: Offset(0, 3), // Shadow position (x, y)
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12)),
              constraints: const BoxConstraints(minHeight: 200, maxHeight: 700),
              child: BlocConsumer<AdminOrderCubit, AdminOrderState>(
                listener: (context, state) {
                  if (state is FetchOrdersSuccessState) {
                    orders.clear();
                    orders.addAll(state.orderList);
                    page = state.currentPage;
                    totalPage = state.totalPage;
                  }
                },
                buildWhen: (previous, current) =>
                    current is FetchOrdersLoadingState ||
                    current is FetchOrdersSuccessState ||
                    current is FetchOrdersFailedState,
                builder: (context, state) {
                  if (state is FetchOrdersLoadingState) {
                    return const LoadingAnimation();
                  }
                  return orderTable();
                },
              )),
          SizedBox(
            height: 20,
          ),
          BlocBuilder<AdminOrderCubit, AdminOrderState>(
            buildWhen: (previous, current) =>
                current is FetchOrdersSuccessState ||
                current is FetchOrdersFailedState,
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButtonWithIcon(
                      onPressed: page > 1
                          ? () {
                              context
                                  .read<AdminOrderCubit>()
                                  .fetchOrders(page - 1);
                            }
                          : null,
                      icon: Icons.arrow_back_ios),
                  SizedBox(
                    width: 50,
                  ),
                  ElevatedButtonWithIcon(
                      onPressed: page < totalPage
                          ? () {
                              context
                                  .read<AdminOrderCubit>()
                                  .fetchOrders(page + 1);
                            }
                          : null,
                      icon: Icons.arrow_forward_ios),
                ],
              );
            },
          )
        ],
      ),
    );
  }

  Widget orderTable() {
    return DataTable2(
        headingRowColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return AppColors.kGrey200; // Customize heading row color here
          },
        ),
        minWidth: 1000,
        fixedLeftColumns: 2,
        columns: [
          DataColumn2(
            label: Checkbox(
              value: false,
              onChanged: (bool? value) {},
            ),
            size: ColumnSize.S,
            fixedWidth: 30,
          ),
          DataColumn2(
            label: Text('Order'),
            size: ColumnSize.S,
          ),
          DataColumn2(
            label: Text('Date'),
            size: ColumnSize.S,
          ),
          DataColumn2(
            label: Text('Customer'),
            size: ColumnSize.S,
          ),
          DataColumn2(
            label: Text('Channel'),
            size: ColumnSize.S,
          ),
          DataColumn2(
            label: Text('Total'),
            size: ColumnSize.S,
          ),
          DataColumn2(
            label: Text('Payment Status'),
            size: ColumnSize.S,
          ),
          DataColumn2(
            label: Text('Order Status'),
            size: ColumnSize.S,
          ),
          DataColumn2(
            label: Text('Items'),
            size: ColumnSize.S,
          )
        ],
        rows: List<DataRow2>.generate(
            orders.length,
            (index) => DataRow2(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => OrderDetailsScreen(
                                  orderId: orders[index].orderId)));
                    },
                    cells: [
                      DataCell(
                        Checkbox(
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                      ),
                      DataCell(
                        Text(
                          "#ORD${orders[index].orderId}",
                          style: AppTextStyle.f14OutfitBlackW500,
                        ),
                      ),
                      DataCell(
                        Text(
                          Utils.formatDate(orders[index].createdOn),
                          style: AppTextStyle.f12outfitGreyW600,
                        ),
                      ),
                      DataCell(
                        Text(orders[index].customerName),
                      ),
                      DataCell(
                        Text(orders[index].channel),
                      ),
                      DataCell(
                        Text("₹${orders[index].price}"),
                      ),
                      DataCell(
                        Text('Not Paid'),
                      ),
                      DataCell(
                        Text(orders[index].orderStatus),
                      ),
                      DataCell(
                        Text('${orders[index].productQuantity} Items'),
                      )
                    ])));
  }
}
