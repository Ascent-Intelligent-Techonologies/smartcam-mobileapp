import 'package:flutter/foundation.dart';

class AuthCredentials {
  final String? username;
  final String? email;
  final String? password;
  String? userId;

  AuthCredentials({
    this.username,
    this.email,
    this.password,
    this.userId,
  });
}
