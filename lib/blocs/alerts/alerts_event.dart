part of 'alerts_bloc.dart';

@immutable
abstract class AlertsEvent extends Equatable {}

class GetAlertsEvent extends AlertsEvent {
  @override
  List<Object?> get props => [];
}

class ChangeAlertFilter extends AlertsEvent {
  final AppiliedFilters filters;
  ChangeAlertFilter({required this.filters});

  @override
  List<Object?> get props => [];
}
