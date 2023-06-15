import 'package:json_annotation/json_annotation.dart';

part 'filter_option.g.dart';

class FilterOption {
  final String name;
  final DefaultFilterOption value;
  final List<String> filterData;

  FilterOption(
      {required this.name, required this.value, required this.filterData});

  factory FilterOption.fromEntity(FilterOptionEntity entity) {
    return FilterOption(
      name: entity.name,
      value: DefaultFilterOption.enumFromName(entity.name),
      filterData: entity.filterData,
    );
  }
  @override
  String toString() {
    // TODO: implement toString
    return 'FilterOption{name: $name, value: $value, filterData: $filterData}';
  }
}

@JsonSerializable()
class FilterOptionEntity {
  final String name;
  @JsonKey(name: 'data')
  final List<String> filterData;

  FilterOptionEntity({required this.name, required this.filterData});

  factory FilterOptionEntity.fromJson(Map<String, dynamic> json) =>
      _$FilterOptionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$FilterOptionEntityToJson(this);
}

enum DefaultFilterOption {
  isNew,
  classnames,
  alertTypes,

  none;

  static DefaultFilterOption enumFromName(String name) {
    switch (name) {
      case 'new':
        return DefaultFilterOption.isNew;
      case 'Classnames':
        return DefaultFilterOption.classnames;
      case 'Alert Types':
        return DefaultFilterOption.alertTypes;
      default:
        return DefaultFilterOption.none;
    }
  }
}

class FilterOptionSelectedValues {
  final DefaultFilterOption value;
  final String name;
  final List<String> selectedFilters;

  FilterOptionSelectedValues(
      {required this.name, required this.value, required this.selectedFilters});
  @override
  String toString() {
    return 'FilterOptionSelectedValues{value: $value, name: $name, selectedFilters: $selectedFilters}';
  }
}
