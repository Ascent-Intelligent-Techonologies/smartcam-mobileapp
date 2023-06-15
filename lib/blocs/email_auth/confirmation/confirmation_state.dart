part of 'confirmation_bloc.dart';

abstract class ConfirmationState extends Equatable {
  const ConfirmationState();
}

class ConfirmationInitial extends ConfirmationState {
  @override
  List<Object> get props => [];
}

class ConfirmationLoading extends ConfirmationState {
  @override
  List<Object> get props => [];
}

class ConfirmationError extends ConfirmationState {
  final String message;
  const ConfirmationError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class ConfirmationSuccess extends ConfirmationState {
  final String message;
  const ConfirmationSuccess({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
