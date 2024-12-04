import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/features/home/repo/home_repo.dart';
import 'package:mafatlal_ecommerce/features/search/bloc/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitialState());

  void searchOrganisation(String searchText) async {
    try {
      emit(SearchLoadingState());

      final response = await HomeRepo.search(searchText);
      emit(SearchSuccessState(
        organisations: response.data ?? [],
      ));
    } on DioException catch (e) {
      emit(SearchFailedState(
          message: e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(SearchFailedState(message: AppStrings.somethingWentWrong));
    }
  }
}
