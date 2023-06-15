part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupWithCredentialsPressed extends SignupEvent {
  final String username;
  final String email;
  final String password;

  const SignupWithCredentialsPressed({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password, username];

  @override
  String toString() =>
      'SignupWithCredentialsPressed { email: $email, password: $password }';
}
