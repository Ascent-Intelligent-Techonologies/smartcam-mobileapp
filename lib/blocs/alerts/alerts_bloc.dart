import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smartcam_dashboard/data/models/alert.dart';
import 'package:smartcam_dashboard/data/models/appilied_filters.dart';
import 'package:smartcam_dashboard/data/models/filter_option.dart';
import 'package:smartcam_dashboard/data/repositories/repository.dart';

part 'alerts_event.dart';
part 'alerts_state.dart';

class AlertsBloc extends Bloc<AlertsEvent, AlertsState> {
  final Repository alertRepository;
  AppiliedFilters currentFilter = AppiliedFilters.empty();
  List<Alert> allAlerts = [];
  AlertsBloc({required this.alertRepository}) : super(AlertsInitial()) {
    on<AlertsEvent>((event, emit) async {
      if (event is GetAlertsEvent) {
        await _mapGetAlertsEventToState(emit: emit);
      } else if (event is ChangeAlertFilter) {
        currentFilter = event.filters;
        await _mapChangeAlertFilterToState(emit: emit, filters: event.filters);
      }
    });
  }

  FutureOr<void> _mapGetAlertsEventToState(
      {required Emitter<AlertsState> emit}) async {
    emit(AlertsLoadingState());
    try {
      final alerts = await alertRepository.getAlerts();
      allAlerts = alerts;
      final filteredAlerts = filterAlerts(allAlerts);
      emit(AlertsLoadedState(filteredAlerts));
    } catch (e) {
      emit(AlertsErrorState(e.toString()));
    }
  }

  FutureOr<void> _mapChangeAlertFilterToState(
      {required Emitter<AlertsState> emit,
      required AppiliedFilters filters}) async {
    emit(AlertsLoadingState());
    currentFilter = filters;
    final alerts = filterAlerts(allAlerts);
    emit(AlertsLoadedState(alerts));
  }

  List<Alert> filterAlerts(List<Alert> alerts) {
    // if (currentFilter == null) return alerts;
    return alerts.where((alert) {
      bool result = true;
      for (var filter in currentFilter.selectedFilters) {
        if (filter.value == DefaultFilterOption.alertTypes) {
          String category = alert.category;
          if (filter.selectedFilters.isNotEmpty &&
              !filter.selectedFilters.contains(category)) {
            result = false;
          }
        } else if (filter.value == DefaultFilterOption.classnames) {
          String classname = alert.classname ?? "";
          if (filter.selectedFilters.isNotEmpty &&
              !filter.selectedFilters.contains(classname)) {
            result = false;
          }
        }
      }
      return result;
    }).toList();
  }
}
