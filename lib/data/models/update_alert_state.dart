import 'package:json_annotation/json_annotation.dart';
part 'update_alert_state.g.dart';

class UpdateAlertStateModel {
  final String uid;
  final String updateKey;
  final dynamic updateValue;

  UpdateAlertStateModel(
      {required this.uid, required this.updateKey, required this.updateValue});

  factory UpdateAlertStateModel.fromEntity(UpdateAlertStateEntity entity) {
    return UpdateAlertStateModel(
        uid: entity.uid,
        updateKey: entity.updateKey,
        updateValue: entity.updateValue);
  }

  UpdateAlertStateEntity toEntity() {
    return UpdateAlertStateEntity(
        uid: uid, updateKey: updateKey, updateValue: updateValue);
  }

  @override
  String toString() {
    return 'UpdateAlertState{uid: $uid, updateKey: $updateKey, updateValue: $updateValue}';
  }
}

@JsonSerializable()
class UpdateAlertStateEntity {
  final String uid;
  @JsonKey(name: 'update_key')
  final String updateKey;
  @JsonKey(name: 'update_value')
  final dynamic updateValue;

  UpdateAlertStateEntity(
      {required this.uid, required this.updateKey, required this.updateValue});

  factory UpdateAlertStateEntity.fromJson(Map<String, dynamic> json) =>
      _$UpdateAlertStateEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateAlertStateEntityToJson(this);
}
