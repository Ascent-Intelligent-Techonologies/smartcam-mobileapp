part of 'filter_data_bloc.dart';

abstract class FilterDataEvent extends Equatable {
  const FilterDataEvent();
}

class GetFilterData extends FilterDataEvent {
  @override
  List<Object?> get props => [];
}
