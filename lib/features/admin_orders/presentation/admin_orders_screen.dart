import 'package:auto_route/auto_route.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/custom_dropdown.dart';
import 'package:mafatlal_ecommerce/components/date_filter_btn.dart';
import 'package:mafatlal_ecommerce/components/elevated_btn_with_icon.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/bloc/admin_orders_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/bloc/admin_orders_state.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/model/order_model.dart';
import 'package:mafatlal_ecommerce/helper/enums.dart';
import 'package:mafatlal_ecommerce/helper/utils.dart';
import 'package:mafatlal_ecommerce/routes/auto_route/mf_router.gr.dart';

@RoutePage()
class AdminOrdersHistoryScreen extends StatefulWidget {
  static const String route = "";
  const AdminOrdersHistoryScreen({super.key});

  @override
  State<AdminOrdersHistoryScreen> createState() =>
      _AdminOrdersHistoryScreenState();
}

class _AdminOrdersHistoryScreenState extends State<AdminOrdersHistoryScreen> {
  final List<OrderModel> orders = [];
  int page = 1;
  int totalPage = 1;
  DateTime? selectedFromDate;
  DateTime? selectedToDate;

  OrderStatus orderStatus = OrderStatus.all;

  @override
  void initState() {
    context
        .read<AdminOrderCubit>()
        .fetchOrders(page, fromDate: Utils.getTodayDate(), status: orderStatus);
    super.initState();
  }

  void fetchOrders({int? fetchPage}) {
    context.read<AdminOrderCubit>().fetchOrders(fetchPage ?? page,
        fromDate: selectedFromDate ?? Utils.getTodayDate(),
        toDate: selectedToDate?.add(const Duration(days: 1)),
        status: orderStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.fromLTRB(12, 30, 12, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Orders",
            style: AppTextStyle.f18OutfitBlackW500,
          ),
          const SizedBox(
            height: 15,
          ),
          BlocBuilder<AdminOrderCubit, AdminOrderState>(
            buildWhen: (previous, current) => current is UpdateSelectedDate,
            builder: (context, state) {
              return Row(
                children: [
                  DateFilterButton(
                      selectedDate: selectedFromDate,
                      onDateSelected: (selectedDate) {
                        selectedFromDate = selectedDate;
                        context.read<AdminOrderCubit>().updateSelectedDate();
                        if (selectedFromDate != null &&
                            selectedToDate != null) {
                          page = 1;
                          fetchOrders();
                        }
                      },
                      dateValidator: (selectedDate) {
                        if (selectedToDate == null) return true;
                        return selectedDate.isBefore(selectedToDate!);
                      },
                      label: "From Date"),
                  const SizedBox(
                    width: 15,
                  ),
                  DateFilterButton(
                      selectedDate: selectedToDate,
                      onDateSelected: (selectedDate) {
                        selectedToDate = selectedDate;
                        context.read<AdminOrderCubit>().updateSelectedDate();
                        if (selectedFromDate != null &&
                            selectedToDate != null) {
                          page = 1;
                          fetchOrders();
                        }
                      },
                      dateValidator: (selectedDate) {
                        if (selectedFromDate == null) return true;
                        return selectedDate.isAfter(selectedFromDate!);
                      },
                      label: "To Date"),
                  const Spacer(),
                  CustomDropDown<OrderStatus>(
                      width: 150,
                      label: "Order Status",
                      selectedValue: orderStatus,
                      items: OrderStatus.values,
                      labelFormat: (e) => e.value,
                      onChanged: (value) {
                        orderStatus = value!;
                        context
                            .read<AdminOrderCubit>()
                            .updateDropDownOrderStatus();
                        page = 1;
                        fetchOrders();
                      }),
                  if (selectedFromDate != null || selectedToDate != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextButton(
                          onPressed: () {
                            selectedFromDate = null;
                            selectedToDate = null;
                            orderStatus = OrderStatus.all;
                            page = 1;
                            context
                                .read<AdminOrderCubit>()
                                .updateSelectedDate();
                            context
                                .read<AdminOrderCubit>()
                                .updateDropDownOrderStatus();
                            fetchOrders();
                          },
                          child: Text(
                            "Reset",
                            style: AppTextStyle.f18PoppinsBlackw400
                                .copyWith(decoration: TextDecoration.underline),
                          )),
                    )
                ],
              );
            },
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: AppColors.kWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey
                            .withOpacity(0.7), // Shadow color with opacity
                        spreadRadius: 3, // How much the shadow spreads
                        blurRadius: 5, // Blurring effect
                        offset: const Offset(0, 3), // Shadow position (x, y)
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12)),
                // constraints: const BoxConstraints(minHeight: 200, maxHeight: 700),
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
          ),
          const SizedBox(
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
                              fetchOrders(fetchPage: page - 1);
                            }
                          : null,
                      icon: Icons.arrow_back_ios),
                  const SizedBox(
                    width: 50,
                  ),
                  ElevatedButtonWithIcon(
                      onPressed: page < totalPage
                          ? () {
                              fetchOrders(fetchPage: page + 1);
                            }
                          : null,
                      icon: Icons.arrow_forward_ios),
                ],
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
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
          const DataColumn2(
            label: Text('Order'),
            size: ColumnSize.S,
          ),
          const DataColumn2(
            label: Text('Date'),
            size: ColumnSize.S,
          ),
          const DataColumn2(
            label: Text('Customer Name'),
            size: ColumnSize.S,
          ),
          const DataColumn2(
            label: Text('Contact'),
            size: ColumnSize.S,
          ),
          const DataColumn2(
            label: Text('Total'),
            size: ColumnSize.S,
          ),
          const DataColumn2(
            label: Text('Payment Status'),
            size: ColumnSize.S,
          ),
          const DataColumn2(
            label: Text('Order Status'),
            size: ColumnSize.S,
          ),
          const DataColumn2(
            label: Text('Items'),
            size: ColumnSize.S,
          )
        ],
        rows: List<DataRow2>.generate(
            orders.length,
            (index) => DataRow2(
                    onTap: () async {
                      await context.router.push(AdminOrderDetailsScreenRoute(
                          orderId: orders[index].orderId));

                      fetchOrders();
                    },
                    cells: [
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
                        SelectableText(orders[index].shipping?.mobile ??
                            orders[index].billing?.mobile ??
                            ''),
                      ),
                      DataCell(
                        Text("₹${orders[index].price}"),
                      ),
                      DataCell(
                        Text(orders[index].paymentStatus ?? ''),
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
