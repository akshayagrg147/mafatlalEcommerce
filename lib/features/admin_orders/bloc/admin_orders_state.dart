import 'package:mafatlal_ecommerce/features/admin_orders/model/order_detail.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/model/order_model.dart';

abstract class AdminOrderState {}

class AdminOrderInitialState extends AdminOrderState {}

class FetchOrdersLoadingState extends AdminOrderState {}

class FetchOrdersSuccessState extends AdminOrderState {
  final List<OrderModel> orderList;
  final int totalPage;
  final int currentPage;

  FetchOrdersSuccessState(
      {required this.orderList,
      required this.totalPage,
      required this.currentPage});
}

class FetchOrdersFailedState extends AdminOrderState {}

class FetchOrderDetailsLoadingState extends AdminOrderState {}

class FetchOrderDetailsSuccessState extends AdminOrderState {
  final OrderDetailModel orderDetails;

  FetchOrderDetailsSuccessState({required this.orderDetails});
}

class FetchOrderDetailsFailedState extends AdminOrderState {}

class UpdateSelectedDate extends AdminOrderState {}

class ShowDispatchFormState extends AdminOrderState {}

class HideDispatchFormState extends AdminOrderState {}

class UpdateOrderStatusLoadingState extends AdminOrderState {}

class UpdateOrderStatusSuccessState extends AdminOrderState {}

class UpdateOrderStatusFailedState extends AdminOrderState {
  UpdateOrderStatusFailedState({required this.message});

  final String message;
}
