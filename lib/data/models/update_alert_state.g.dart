// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_alert_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateAlertStateEntity _$UpdateAlertStateEntityFromJson(
        Map<String, dynamic> json) =>
    UpdateAlertStateEntity(
      uid: json['uid'] as String,
      updateKey: json['update_key'] as String,
      updateValue: json['update_value'] as String,
    );

Map<String, dynamic> _$UpdateAlertStateEntityToJson(
        UpdateAlertStateEntity instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'update_key': instance.updateKey,
      'update_value': instance.updateValue,
    };
