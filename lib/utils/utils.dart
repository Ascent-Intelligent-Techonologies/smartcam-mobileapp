import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

extension ReadableString on DateTime {
  String readableString() {
    return DateFormat('yyyy-MM-dd – kk:mm').format(this);
  }
}

String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'Email cannot be empty';
  }
  if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
    return 'Email is not valid';
  }
  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'Password cannot be empty';
  }
  if (password.length < 8) {
    return 'Password must be at least 8 characters';
  }
  return null;
}

String? validateUsername(String? username) {
  if (username == null || username.isEmpty) {
    return 'Username cannot be empty';
  }
  if (username.length < 3) {
    return 'Username must be at least 3 characters';
  }
  return null;
}

void logging(object) {
  if (kDebugMode) {
    print(object);
  }
}
