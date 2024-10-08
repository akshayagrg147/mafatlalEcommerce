import 'package:mafatlal_ecommerce/features/admin_home/model/graph_model.dart';

abstract class AdminHomeState {}

class AdminHomeInitial extends AdminHomeState {}

class UpdateDrawerPage extends AdminHomeState {
  final int page;

  UpdateDrawerPage({required this.page});
}

class GetGraphDataLoadingState extends AdminHomeState {}

class GetGraphDataFailedState extends AdminHomeState {
  String message;

  GetGraphDataFailedState({required this.message});
}

class GetGraphDataSuccessState extends AdminHomeState {
  GraphModel graphModel;

  GetGraphDataSuccessState({required this.graphModel});
}
