import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcam_dashboard/data/repositories/auth_repository.dart';
import 'package:smartcam_dashboard/utils/utils.dart';
import 'package:smartcam_dashboard/views/auth/auth_cubit.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository authRepository;
  final AuthCubit authCubit;
  SignupBloc({required this.authRepository, required this.authCubit})
      : super(SignupInitial()) {
    on<SignupEvent>((event, emit) async {
      if (event is SignupWithCredentialsPressed) {
        await _mapSignupWithCredentialsPressedToState(
            email: event.email,
            password: event.password,
            username: event.username,
            emit: emit);
      }
    });
  }

  FutureOr<void> _mapSignupWithCredentialsPressedToState(
      {required String email,
      required String password,
      required String username,
      required Emitter<SignupState> emit}) async {
    emit(SignupLoading());
    try {
      logging('Signing up user: $email');
      final SignUpResult result = await authRepository.signUpUser(
          username: username, email: email, password: password);
      logging(result);
      authCubit.showConfirmSignUp(
        username: username,
        email: email,
        password: password,
      );
      if (result.nextStep.signUpStep == 'CONFIRM_SIGN_UP_STEP' ||
          result.isSignUpComplete) {
        emit(const SignupSuccess(message: 'Signup Successful'));
      } else {
        emit(const SignupError(message: 'Signup Failed'));
      }
    } catch (e) {
      emit(SignupError(message: e.toString()));
    }
  }
}
