import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcam_dashboard/blocs/session_cubit/session_cubit.dart';
import 'package:smartcam_dashboard/data/repositories/auth_repository.dart';

part 'confirmation_event.dart';
part 'confirmation_state.dart';

class ConfirmationBloc extends Bloc<ConfirmationEvent, ConfirmationState> {
  final AuthRepository authRepository;
  final SessionCubit sessionCubit;
  ConfirmationBloc({required this.authRepository, required this.sessionCubit})
      : super(ConfirmationInitial()) {
    on<ConfirmationEvent>((event, emit) async {
      if (event is ConfirmationCodeSubmitPressed) {
        await _mapConfirmationWithCodePressedToState(
            username: event.username, code: event.code, emit: emit);
      }
    });
  }

  FutureOr<void> _mapConfirmationWithCodePressedToState(
      {required username,
      required code,
      required Emitter<ConfirmationState> emit}) async {
    emit(ConfirmationLoading());
    try {
      SignUpResult result =
          await authRepository.confirmUser(username: username, code: code);
      if (result.isSignUpComplete) {
        sessionCubit.showSession();
        emit(const ConfirmationSuccess(message: 'Confirmation Successful'));
      } else {
        emit(const ConfirmationError(message: 'Confirmation Failed'));
      }
    } catch (e) {
      emit(ConfirmationError(message: e.toString()));
    }
  }
}
