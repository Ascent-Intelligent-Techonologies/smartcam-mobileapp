import 'package:json_annotation/json_annotation.dart';
import 'package:smartcam_dashboard/data/models/filter_option.dart';
part 'filter_data.g.dart';

class FilterData {
  final List<FilterOption> availableFilters;

  FilterData({required this.availableFilters});

  factory FilterData.fromEntity(FilterDataEntity entity) {
    return FilterData(
        availableFilters: entity.availableFilters
            .map((e) => FilterOption.fromEntity(e))
            .toList());
  }

  @override
  String toString() {
    return 'FilterData{filters: $availableFilters}';
  }
}

@JsonSerializable(explicitToJson: true)
class FilterDataEntity {
  final List<FilterOptionEntity> availableFilters;

  FilterDataEntity({required this.availableFilters});

  factory FilterDataEntity.fromJson(Map<String, dynamic> json) =>
      _$FilterDataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$FilterDataEntityToJson(this);
}
