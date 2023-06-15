import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcam_dashboard/data/fcm_handler.dart';
import 'package:smartcam_dashboard/data/repositories/auth_repository.dart';
import 'package:smartcam_dashboard/utils/utils.dart';

import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepo;
  // final DataRepository dataRepo;

  SessionCubit({required this.authRepo}) : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void attemptAutoLogin() async {
    try {
      // final userId = await authRepo.attemptAutoLogin();
      // if (userId == null) {
      //   throw Exception('User not logged in');
      // }
      logging('attemptAutoLogin()');

      final user = await authRepo.getCurrentUser();
      logging(user);
      if (user == null) {
        throw Exception('User not logged in');
      }

      emit(Authenticated(user: user));
    } on Exception catch (e) {
      logging(e);
      emit(Unauthenticated());
    }
  }

  void showAuth() => emit(Unauthenticated());

  void showSession() async {
    try {
      logging('showSession()');
      final user = await authRepo.getCurrentUser();
      logging(user);
      if (user == null) {
        throw Exception('User not logged in');
      }

      emit(Authenticated(user: user));
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  void signOut() async {
    await authRepo.signOutUser();
    emit(Unauthenticated());
  }
}
