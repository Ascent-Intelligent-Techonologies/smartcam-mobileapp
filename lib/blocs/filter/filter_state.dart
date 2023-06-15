part of 'filter_bloc.dart';

abstract class FilterState extends Equatable {
  const FilterState();
}

class FilterInitial extends FilterState {
  @override
  List<Object?> get props => [];
}

class FilterChanged extends FilterState {
  final AppiliedFilters filters;
  const FilterChanged({required this.filters});

  @override
  List<Object?> get props => [filters];
}
