abstract class AuthState {}

class AuthInitialState extends AuthState {}

class GetCurrentUserSuccessState extends AuthState {}

class FetchCurrentUserSuccessState extends AuthState {}

class FetchCurrentUserLoadingState extends AuthState {}

class FetchCurrentUserFailedState extends AuthState {}

class GetCurrentUserFailedState extends AuthState {}

class LoginLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {}

class LoginFailedState extends AuthState {
  final String message;

  LoginFailedState(this.message);
}

class RegisterUserLoadingState extends AuthState {}

class RegisterUserSuccessState extends AuthState {}

class RegisterUserFailedState extends AuthState {
  final String message;

  RegisterUserFailedState(this.message);
}

class GetDistrictListState extends AuthState {
  final List<String> districts;

  GetDistrictListState(this.districts);
}

class UpdateDistrictState extends AuthState {
  final String district;

  UpdateDistrictState(this.district);
}

class LogoutState extends AuthState {}

class TogglePwdObsecureState extends AuthState {
  final bool isObsecure;

  TogglePwdObsecureState({required this.isObsecure});
}
