import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/features/admin_home/bloc/admin_home_state.dart';
import 'package:mafatlal_ecommerce/features/admin_home/repo/admin_home_repo.dart';

class AdminHomeCubit extends Cubit<AdminHomeState> {
  AdminHomeCubit() : super(AdminHomeInitial());

  final PageController homePageController =
      PageController(initialPage: 0, keepPage: false);

  void updatePageIndex(int page) {
    if (homePageController.page == page) {
      return;
    }
    homePageController.animateToPage(page,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);

    emit(UpdateDrawerPage(page: page));
  }

  getGraphdata() async {
    try {
      emit(GetGraphDataLoadingState());
      final result = await AdminHomeRepository.fetchOrderStats(
          '2024-07-25 13:17:44.0150', 15);
      emit(GetGraphDataSuccessState(graphModel: result.data!));
    } on Exception catch (e) {
      emit(GetGraphDataFailedState(message: e.toString()));
    }
  }
}
