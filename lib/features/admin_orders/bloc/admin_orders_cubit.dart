import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/bloc/admin_orders_state.dart';
import 'package:mafatlal_ecommerce/features/admin_orders/repo/admin_orders_repo.dart';
import 'package:mafatlal_ecommerce/services/dio_utils_service.dart';

class AdminOrderCubit extends Cubit<AdminOrderState> {
  AdminOrderCubit() : super(AdminOrderInitialState());

  void fetchOrders(int page, {DateTime? fromDate, DateTime? toDate}) async {
    try {
      emit(FetchOrdersLoadingState());
      final response = await AdminOrderRepo.fetchOrder(
          CubitsInjector.authCubit.currentUser!.id,
          fromDate: fromDate,
          toDate: toDate,
          page: page);
      emit(FetchOrdersSuccessState(
          orderList: response.data ?? [],
          totalPage: response.totalPages,
          currentPage: page));
    } on DioException catch (e) {
      emit(FetchOrdersFailedState());
    } catch (e) {
      emit(FetchOrdersFailedState());
    }
  }

  void fetchOrderDetails(int orderId) async {
    try {
      emit(FetchOrderDetailsLoadingState());
      final response = await AdminOrderRepo.fetchOrderDetails(orderId);
      emit(FetchOrderDetailsSuccessState(orderDetails: response.data!));
    } on DioException catch (e) {
      emit(FetchOrderDetailsFailedState());
    } catch (e) {
      emit(FetchOrderDetailsFailedState());
    }
  }

  void updateSelectedDate() {
    emit(UpdateSelectedDate());
  }

  void showDispatchForm() {
    emit(ShowDispatchFormState());
  }

  void hideDispatchForm() {
    emit(HideDispatchFormState());
  }

  void updateOrderStatus(int orderId,
      {String? trackingUrl, required String status}) async {
    try {
      emit(UpdateOrderStatusLoadingState());
      await AdminOrderRepo.updateOrderStatus(orderId,
          trackingUrl: trackingUrl, status: status);

      emit(UpdateOrderStatusSuccessState());

      fetchOrderDetails(orderId);
    } on DioException catch (e) {
      emit(UpdateOrderStatusFailedState(
          message: e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(
          UpdateOrderStatusFailedState(message: AppStrings.somethingWentWrong));
    }
  }
}
