import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/components/custom_btn.dart';
import 'package:mafatlal_ecommerce/components/loading_animation.dart';
import 'package:mafatlal_ecommerce/constants/colors.dart';
import 'package:mafatlal_ecommerce/constants/textstyles.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/bloc/admin_orders_cubit.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/bloc/admin_orders_state.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/model/order_detail.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/presentation/widgets/ordered_product_tile.dart';
import 'package:mafatlal_ecommerce/features/home/presentaion/widgets/delivery_status.dart';
import 'package:mafatlal_ecommerce/helper/enums.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderedProductList extends StatefulWidget {
  final OrderDetailModel orderDetails;
  final bool showDispatchOrder;

  const OrderedProductList(
      {super.key, required this.orderDetails, this.showDispatchOrder = true});

  @override
  State<OrderedProductList> createState() => _OrderedProductListState();
}

class _OrderedProductListState extends State<OrderedProductList> {
  TextEditingController _controller = TextEditingController();

  final _formFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kGrey200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey
                .withOpacity(0.2), // Light grey shadow with 20% opacity
            spreadRadius: 2, // Extent of the shadow
            blurRadius: 7, // Blurring effect
            offset: const Offset(
                0, 3), // Horizontal and Vertical displacement of the shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: DeliveryStatus(status: widget.orderDetails.orderStatus)),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.kGrey200),
            ),
            child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return OrderedProductTile(
                      product: widget.orderDetails.products[index]);
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: 1,
                    height: 0,
                    color: AppColors.kGrey200,
                  );
                },
                itemCount: widget.orderDetails.products.length),
          ),
          const SizedBox(
            height: 22,
          ),
          if (widget.orderDetails.orderStatus == 'Pending' &&
              CubitsInjector.authCubit.currentUser?.userType == UserType.admin)
            BlocBuilder<AdminOrderCubit, AdminOrderState>(
              buildWhen: (previous, current) =>
                  current is ShowDispatchFormState ||
                  current is HideDispatchFormState ||
                  current is UpdateOrderStatusLoadingState ||
                  current is UpdateOrderStatusFailedState ||
                  current is UpdateOrderStatusSuccessState,
              builder: (context, state) {
                if (state is UpdateOrderStatusLoadingState) {
                  return const LoadingAnimation();
                }
                if (state is ShowDispatchFormState ||
                    state is UpdateOrderStatusFailedState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              key: _formFieldKey,
                              controller: _controller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Tracking Url';
                                }
                                if (!value.startsWith('http://') &&
                                    !value.startsWith('https://')) {
                                  return 'Enter Valid Url';
                                }
                                return null;
                              },
                              style: AppTextStyle.f14OutfitBlackW500,
                              decoration: InputDecoration(
                                hintText: 'Enter Tracking Url',
                                hintStyle: AppTextStyle.f14OutfitGreyW500,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: AppColors.kGrey200,
                                      width: 1,
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            onPressed: () {
                              _controller.clear();
                              context
                                  .read<AdminOrderCubit>()
                                  .hideDispatchForm();
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 25,
                            ),
                            color: AppColors.kRed,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            onPressed: () {
                              if (_formFieldKey.currentState!.validate()) {
                                context
                                    .read<AdminOrderCubit>()
                                    .updateOrderStatus(
                                        widget.orderDetails.orderId,
                                        trackingUrl: _controller.text,
                                        status: 'Dispatched');
                              }
                            },
                            icon: const Icon(
                              Icons.check,
                              size: 25,
                            ),
                            color: AppColors.kGreen,
                          )
                        ],
                      ),
                      if (state is UpdateOrderStatusFailedState)
                        Text(
                          state.message,
                          style: AppTextStyle.f14KRedOutfitW500,
                        )
                    ],
                  );
                }

                return CustomElevatedButton(
                    width: 160,
                    onPressed: () {
                      context.read<AdminOrderCubit>().showDispatchForm();
                    },
                    label: "Dispatch Order");
              },
            ),
          if (widget.orderDetails.trackingUrl != null)
            TextButton(
                onPressed: () {
                  launchUrlString(widget.orderDetails.trackingUrl!);
                },
                child: Text(
                  'Track Order',
                  style: AppTextStyle.f18PoppinsBluew600.copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.kblue),
                ))
        ],
      ),
    );
  }
}
