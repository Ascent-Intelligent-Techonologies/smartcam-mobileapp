// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterOptionEntity _$FilterOptionEntityFromJson(Map<String, dynamic> json) =>
    FilterOptionEntity(
      name: json['name'] as String,
      filterData:
          (json['data'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$FilterOptionEntityToJson(FilterOptionEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'data': instance.filterData,
    };
