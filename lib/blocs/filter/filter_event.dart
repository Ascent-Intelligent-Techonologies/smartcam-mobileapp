part of 'filter_bloc.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();
}

class ChangeFilter extends FilterEvent {
  final AppiliedFilters filters;
  const ChangeFilter(this.filters);

  @override
  List<Object?> get props => [];
}
