import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smartcam_dashboard/data/models/filter_data.dart';
import 'package:smartcam_dashboard/data/repositories/repository.dart';

part 'filter_data_event.dart';
part 'filter_data_state.dart';

class FilterDataBloc extends Bloc<FilterDataEvent, FilterDataState> {
  final Repository repository;
  FilterDataBloc({required this.repository}) : super(FilterDataInitial()) {
    on<FilterDataEvent>((event, emit) async {
      if (event is GetFilterData) {
        await _mapGetFilterDataToState(emit);
      }
    });
  }

  FutureOr<void> _mapGetFilterDataToState(Emitter<FilterDataState> emit) async {
    try {
      final filter = await repository.getFilters();
      emit(FilterDataLoaded(filterData: filter));
    } catch (e) {
      emit(FilterDataError(message: e.toString()));
    }
  }
}
