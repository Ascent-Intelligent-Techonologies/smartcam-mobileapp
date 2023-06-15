part of 'update_alert_state_cubit.dart';

abstract class UpdateAlertStateState extends Equatable {
  const UpdateAlertStateState();
}

class UpdateAlertStateInitial extends UpdateAlertStateState {
  @override
  List<Object> get props => [];
}

class UpdateAlertStateLoading extends UpdateAlertStateState {
  @override
  List<Object> get props => [];
}

class UpdateAlertStateSuccess extends UpdateAlertStateState {
  @override
  List<Object> get props => [];
}

class UpdateAlertStateError extends UpdateAlertStateState {
  final String message;

  UpdateAlertStateError({required this.message});

  @override
  List<Object> get props => [message];
}
