abstract class AdminHomeState {}

class AdminHomeInitial extends AdminHomeState {}

class UpdateDrawerPage extends AdminHomeState {
  final int page;

  UpdateDrawerPage({required this.page});
}
