part of 'confirmation_bloc.dart';

abstract class ConfirmationEvent extends Equatable {
  const ConfirmationEvent();
}

class ConfirmationCodeSubmitPressed extends ConfirmationEvent {
  final String code;
  final String username;

  const ConfirmationCodeSubmitPressed({
    required this.code,
    required this.username,
  });

  @override
  List<Object?> get props => [code, username];
}
