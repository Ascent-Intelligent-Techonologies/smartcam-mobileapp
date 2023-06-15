import 'package:json_annotation/json_annotation.dart';
part 'alert.g.dart';

class Alert {
  final DateTime datetime;
  final String? s3Path;
  final String category;
  final String? deviceId;
  final bool? isNew;
  final String? uid;
  final String? deviceName;
  final String? classname;

  Alert(
      {required this.datetime,
      required this.s3Path,
      required this.category,
      this.deviceId,
      this.isNew,
      this.uid,
      this.deviceName,
      this.classname});

  factory Alert.fromEntity(AlertEntity entity) {
    return Alert(
        datetime: DateTime.tryParse(entity.datetime) ?? DateTime.now(),
        s3Path: entity.s3Path,
        category: entity.category,
        deviceId: entity.deviceId,
        isNew: entity.isNew == 1,
        uid: entity.uid,
        deviceName: entity.deviceName,
        classname: entity.classname);
  }
}

@JsonSerializable()
class AlertEntity {
  final String datetime;
  @JsonKey(name: 's3_path')
  final String? s3Path;
  final String category;
  @JsonKey(name: 'device-id')
  final String? deviceId;
  @JsonKey(name: 'is_new')
  final int? isNew;
  final String? uid;
  @JsonKey(name: 'device_name')
  final String? deviceName;

  @JsonKey(name: 'class_name')
  final String? classname;
  AlertEntity(
      {required this.datetime,
      required this.s3Path,
      required this.category,
      this.deviceId,
      this.isNew,
      this.uid,
      this.deviceName,
      this.classname});

  factory AlertEntity.fromJson(Map<String, dynamic> json) =>
      _$AlertEntityFromJson(json);

  Map<String, dynamic> toJson() => _$AlertEntityToJson(this);
}
