import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:smartcam_dashboard/data/models/user.dart';

abstract class AuthRepository {
  Future<SignInResult> signInUser(String email, String password);
  Future<SignOutResult> signOutUser();
  Future<bool> isSignedIn();
  Future<String> getJwtToken();
  Future<SignUpResult> signUpUser(
      {required String username,
      required String email,
      required String password});

  Future<String?> attemptAutoLogin();
  Future<UserModel?> getCurrentUser();

  Future<SignUpResult> confirmUser(
      {required String username, required String code});
}
