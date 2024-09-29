import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafatlal_ecommerce/constants/app_strings.dart';
import 'package:mafatlal_ecommerce/constants/state_district.dart';
import 'package:mafatlal_ecommerce/core/dependency_injection.dart';
import 'package:mafatlal_ecommerce/features/auth/bloc/auth_state.dart';
import 'package:mafatlal_ecommerce/features/auth/model/user_model.dart';
import 'package:mafatlal_ecommerce/features/auth/repo/auth_repo.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/cart_helper.dart';
import 'package:mafatlal_ecommerce/helper/shared_preference_helper.dart';
import 'package:mafatlal_ecommerce/services/dio_utils_service.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

  User? _currentUser;

  User? get currentUser => _currentUser;

  void getCurrentUser() {
    try {
      _currentUser = SharedPreferencesHelper.instance.getCurrentUser();
      if (currentUser != null) {
        emit(GetCurrentUserSuccessState());
      } else {
        emit(GetCurrentUserFailedState());
      }
    } catch (e) {
      emit(GetCurrentUserFailedState());
    }
  }

  void fetchCurrentUser() async {
    try {
      emit(FetchCurrentUserLoadingState());
      final response = await AuthRepo.fetchCurrentUser(userId: currentUser!.id);
      _currentUser = response.data!;
      SharedPreferencesHelper.instance.setCurrentUser(response.data!);
      emit(FetchCurrentUserSuccessState());
    } on DioException catch (e) {
      emit(FetchCurrentUserFailedState());
    } catch (e) {
      emit(FetchCurrentUserFailedState());
    }
  }

  void updateState(String state) {
    final districtList = StateDistricts.getDistrictList(state);
    emit(GetDistrictListState(districtList));
  }

  void updateDistrict(String district) {
    emit(UpdateDistrictState(district));
  }

  void loginUser({required String email, required String pwd}) async {
    try {
      if (state is LoginLoadingState) {
        return;
      }
      emit(LoginLoadingState());
      final response = await AuthRepo.login(email: email, pwd: pwd);
      if (response.data != null) {
        _currentUser = response.data;
        SharedPreferencesHelper.instance.setCurrentUser(response.data!);
        emit(LoginSuccessState());
      } else {
        emit(LoginFailedState(response.message));
      }
    } on DioException catch (e) {
      emit(LoginFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(LoginFailedState(AppStrings.somethingWentWrong));
    }
  }

  void registerUser(
      {required String email,
      required String pwd,
      required String name,
      required String state,
      required String district,
      required String gstNo,
      required String pincode}) async {
    try {
      if (state is RegisterUserLoadingState) {
        return;
      }
      emit(RegisterUserLoadingState());
      final response = await AuthRepo.registerUser(
          email: email,
          pwd: pwd,
          name: name,
          state: state,
          district: district,
          gstNo: gstNo,
          pinCode: pincode);
      if (response.data != null) {
        _currentUser = response.data;
        SharedPreferencesHelper.instance.setCurrentUser(response.data!);
        emit(RegisterUserSuccessState());
      } else {
        emit(RegisterUserFailedState(response.message));
      }
    } on DioException catch (e) {
      emit(RegisterUserFailedState(
          e.response?.statusMessage ?? AppStrings.somethingWentWrong));
    } catch (e) {
      emit(RegisterUserFailedState(AppStrings.somethingWentWrong));
    }
  }

  void logOut() {
    SharedPreferencesHelper.instance.clearPrefs();
    CartHelper.clear();
    _currentUser = null;
    CubitsInjector.homeCubit.clear();
    emit(LogoutState());
  }
}
