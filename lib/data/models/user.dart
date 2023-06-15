class UserModel {
  final String username;
  final String email;
  final String userId;
  final String? token;

  UserModel(
      {required this.username,
      required this.email,
      required this.token,
      required this.userId});
}
