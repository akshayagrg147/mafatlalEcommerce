import 'package:mafatlal_ecommerce/features/home/model/searchmodel.dart';

abstract class SearchState {}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchSuccessState extends SearchState {
  final List<ProductSearch> organisations;

  SearchSuccessState({required this.organisations});
}

class SearchFailedState extends SearchState {
  final String message;

  SearchFailedState({required this.message});
}
