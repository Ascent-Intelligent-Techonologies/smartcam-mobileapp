import 'package:flutter/foundation.dart';
import 'package:smartcam_dashboard/data/models/user.dart';

abstract class SessionState {}

class UnknownSessionState extends SessionState {}

class Unauthenticated extends SessionState {}

class Authenticated extends SessionState {
  final UserModel user;

  Authenticated({required this.user});
}
