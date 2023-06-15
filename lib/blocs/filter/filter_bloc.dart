import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smartcam_dashboard/blocs/alerts/alerts_bloc.dart';
import 'package:smartcam_dashboard/data/models/alert.dart';
import 'package:smartcam_dashboard/data/models/appilied_filters.dart';
import 'package:smartcam_dashboard/data/models/filter_data.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final AlertsBloc alertsBloc;

  FilterBloc({required this.alertsBloc}) : super(FilterInitial()) {
    on<FilterEvent>((event, emit) {
      if (event is ChangeFilter) {
        alertsBloc.add(ChangeAlertFilter(filters: event.filters));
        emit(FilterChanged(filters: event.filters));
      }
    });
  }
}
