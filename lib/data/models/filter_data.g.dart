// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterDataEntity _$FilterDataEntityFromJson(Map<String, dynamic> json) =>
    FilterDataEntity(
      availableFilters: (json['availableFilters'] as List<dynamic>)
          .map((e) => FilterOptionEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FilterDataEntityToJson(FilterDataEntity instance) =>
    <String, dynamic>{
      'availableFilters':
          instance.availableFilters.map((e) => e.toJson()).toList(),
    };
