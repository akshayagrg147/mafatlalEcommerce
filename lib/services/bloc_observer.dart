import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class DringDongObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // Called whenever the state of any bloc is changed.
    log('Bloc $bloc has changed state to $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // Called whenever an error is thrown in any bloc.
    log('An error occurred in bloc $bloc: $error');
  }
}
