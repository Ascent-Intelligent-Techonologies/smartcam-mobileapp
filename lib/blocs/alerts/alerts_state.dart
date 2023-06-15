part of 'alerts_bloc.dart';

@immutable
abstract class AlertsState extends Equatable {}

class AlertsInitial extends AlertsState {
  @override
  List<Object?> get props => [];
}

class AlertsLoadingState extends AlertsState {
  @override
  List<Object?> get props => [];
}

class AlertsLoadedState extends AlertsState {
  AlertsLoadedState(this.alerts);
  final List<Alert> alerts;
  @override
  List<Object?> get props => [alerts];
}

class AlertsErrorState extends AlertsState {
  AlertsErrorState(this.error);
  final String error;
  @override
  List<Object?> get props => [error];
}
