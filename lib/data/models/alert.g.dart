// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlertEntity _$AlertEntityFromJson(Map<String, dynamic> json) => AlertEntity(
      datetime: json['datetime'] as String,
      s3Path: json['s3_path'] as String?,
      category: json['category'] as String,
      deviceId: json['device-id'] as String?,
      isNew: json['is_new'] as int?,
      uid: json['uid'] as String?,
      deviceName: json['device_name'] as String?,
      classname: json['class_name'] as String?,
    );

Map<String, dynamic> _$AlertEntityToJson(AlertEntity instance) =>
    <String, dynamic>{
      'datetime': instance.datetime,
      's3_path': instance.s3Path,
      'category': instance.category,
      'device-id': instance.deviceId,
      'is_new': instance.isNew,
      'uid': instance.uid,
      'device_name': instance.deviceName,
      'class_name': instance.classname,
    };
