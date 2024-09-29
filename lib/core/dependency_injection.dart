import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mafatlal_ecommerce/features/admin_home/bloc/admin_home_cubit.dart';
import 'package:mafatlal_ecommerce/features/auth/bloc/auth_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/SubCategory/bloc/subcategory_cubit.dart';
import 'package:mafatlal_ecommerce/features/home/bloc/home_cubit.dart';

class CubitsInjector {
  // Singleton instance
  static final CubitsInjector _instance = CubitsInjector._internal();

  // Private constructor to prevent external instantiation
  CubitsInjector._internal() {
    _registerCubits();
  }

  void _registerCubits() {
    _getIt.registerLazySingleton<AuthCubit>(() => AuthCubit());
    _getIt.registerLazySingleton<HomeCubit>(() => HomeCubit());
    _getIt.registerLazySingleton<SubcategoryCubit>(() => SubcategoryCubit());
    _getIt.registerLazySingleton<AdminHomeCubit>(() => AdminHomeCubit());
  }

  // Clear and re-register cubits upon logout
  static void resetCubits() async {
    // Clear existing cubits
    await _getIt.reset();

    // Register new cubits
    _instance._registerCubits();
  }

  // Factory constructor to return the singleton instance
  factory CubitsInjector() => _instance;

  // GetIt instance for dependency injection
  static final GetIt _getIt = GetIt.instance;

  // Example static getter method to access CounterCubit
  static AuthCubit get authCubit => _getIt<AuthCubit>();

  static HomeCubit get homeCubit => _getIt<HomeCubit>();

  static SubcategoryCubit get subcategoryCubit =>
      _getIt<SubcategoryCubit>(); // Renamed here

  static AdminHomeCubit get adminHomeCubit => _getIt<AdminHomeCubit>();

  static List<BlocProvider> blocProviders = [
    BlocProvider<AuthCubit>(
      create: (context) => CubitsInjector.authCubit,
    ),
    BlocProvider<HomeCubit>(
      create: (context) => CubitsInjector.homeCubit,
    ),
    BlocProvider<AdminHomeCubit>(
      create: (context) => CubitsInjector.adminHomeCubit,
    ),
    BlocProvider<SubcategoryCubit>(
      create: (context) => CubitsInjector.subcategoryCubit, // Updated here
    ),
  ];
}
