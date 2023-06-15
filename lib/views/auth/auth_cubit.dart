import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcam_dashboard/data/models/auth_credentials.dart';

enum AuthState { login, signUp, confirmSignUp }

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.login);
  late AuthCredentials credentials;

  void showLogin() => emit(AuthState.login);
  void showSignUp() => emit(AuthState.signUp);
  void showConfirmSignUp({
    required String username,
    required String email,
    required String password,
  }) {
    credentials = AuthCredentials(
      username: username,
      email: email,
      password: password,
    );
    emit(AuthState.confirmSignUp);
  }

  // void launchSession(AuthCredentials credentials) =>
  //     sessionCubit.showSession(credentials);
}
