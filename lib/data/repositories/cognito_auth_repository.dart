import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:smartcam_dashboard/data/models/user.dart';
import 'package:smartcam_dashboard/data/repositories/auth_repository.dart';
import 'package:smartcam_dashboard/utils/utils.dart';

class CognitoAuthRepository extends AuthRepository {
  @override
  Future<SignInResult> signInUser(String email, String password) async {
    final result = await Amplify.Auth.signIn(
      username: email,
      password: password,
    );
    return result;
  }

  @override
  Future<SignOutResult> signOutUser() async {
    final result = await Amplify.Auth.signOut();
    return result;
  }

  @override
  Future<bool> isSignedIn() async {
    try {
      final result = await Amplify.Auth.fetchAuthSession();
      return result.isSignedIn;
    } on AuthException catch (e) {
      logging(e.message);
    }
    return false;
  }

  @override
  Future<String> getJwtToken() async {
    try {
      AuthSession res = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true));
      String token = (res as CognitoAuthSession).userPoolTokens!.idToken;
      // final result = await Amplify.Auth.fetchAuthSession();
      return token;
    } on AuthException catch (e) {
      logging(e.message);
    }
    return "";
  }

  @override
  Future<SignUpResult> signUpUser(
      {required String username,
      required String email,
      required String password}) async {
    SignUpResult result = await Amplify.Auth.signUp(
      username: username,
      password: password,
      options: CognitoSignUpOptions(
        userAttributes: {
          CognitoUserAttributeKey.email: email,
        },
      ),
    );

    return result;
  }

  @override
  Future<String?> attemptAutoLogin() async {
    final session = await Amplify.Auth.fetchAuthSession();

    return session.isSignedIn ? (await _getUserIdFromAttributes()) : null;
  }

  Future<String?> _getUserIdFromAttributes() async {
    final attributes = await Amplify.Auth.fetchUserAttributes();

    final userId = attributes
        .firstWhere((element) => element.userAttributeKey == 'sub')
        .value;
    return userId;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    AuthUser user = await Amplify.Auth.getCurrentUser();
    String token = await getJwtToken();
    return UserModel(
      userId: user.userId,
      username: user.username,
      email: user.username,
      token: token,
    );
  }

  @override
  Future<SignUpResult> confirmUser(
      {required String username, required String code}) async {
    final result = await Amplify.Auth.confirmSignUp(
      username: username.trim(),
      confirmationCode: code.trim(),
    );
    return result;
  }
}
