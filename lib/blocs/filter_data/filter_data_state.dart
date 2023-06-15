part of 'filter_data_bloc.dart';

abstract class FilterDataState extends Equatable {
  const FilterDataState();
}

class FilterDataInitial extends FilterDataState {
  @override
  List<Object> get props => [];
}

class FilterDataLoaded extends FilterDataState {
  final FilterData filterData;
  const FilterDataLoaded({required this.filterData});

  @override
  List<Object> get props => [filterData];
}

class FilterDataLoading extends FilterDataState {
  @override
  List<Object> get props => [];
}

class FilterDataError extends FilterDataState {
  final String message;
  const FilterDataError({required this.message});

  @override
  List<Object> get props => [message];
}
