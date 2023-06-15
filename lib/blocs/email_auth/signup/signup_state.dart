part of 'signup_bloc.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupError extends SignupState {
  final String message;
  const SignupError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class SignupSuccess extends SignupState {
  final String message;
  const SignupSuccess({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
