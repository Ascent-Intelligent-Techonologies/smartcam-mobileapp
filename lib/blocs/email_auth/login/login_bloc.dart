import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcam_dashboard/blocs/session_cubit/session_cubit.dart';
import 'package:smartcam_dashboard/data/repositories/auth_repository.dart';
import 'package:smartcam_dashboard/utils/utils.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repository;
  final SessionCubit sessionCubit;
  LoginBloc({required this.repository, required this.sessionCubit})
      : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is LoginWithCredentialsPressed) {
        await _mapLoginWithCredentialsPressedToState(
            email: event.email, password: event.password, emit: emit);
      }
    });
  }

  FutureOr<void> _mapLoginWithCredentialsPressedToState(
      {required String email,
      required String password,
      required Emitter<LoginState> emit}) async {
    emit(LoginLoading());
    try {
      final SignInResult result = await repository.signInUser(email, password);
      logging(result);
      if (result.isSignedIn) {
        sessionCubit.showSession();
        emit(const LoginSuccess(message: 'Login Successful'));
      } else {
        emit(const LoginError(message: 'Login Failed'));
      }
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }
}
