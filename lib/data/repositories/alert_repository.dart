import 'package:smartcam_dashboard/data/api/service/api_service.dart';
import 'package:smartcam_dashboard/data/models/alert.dart';
import 'package:smartcam_dashboard/data/models/filter_data.dart';
import 'package:smartcam_dashboard/data/models/update_alert_state.dart';
import 'package:smartcam_dashboard/data/repositories/repository.dart';

class AlertRepository extends Repository {
  final ApiService apiService;

  AlertRepository(this.apiService);
  @override
  Future<List<Alert>> getAlerts() async {
    List<AlertEntity> alerts = await apiService.getAlerts();
    return alerts.map((e) => Alert.fromEntity(e)).toList();
  }

  @override
  Future<FilterData> getFilters() async {
    FilterDataEntity entity = await apiService.getFilters();
    return FilterData.fromEntity(entity);
  }

  @override
  Future<void> updateAlertState(UpdateAlertStateModel updateAlertState) async {
    await apiService.updateAlertState(updateAlertState.toEntity());
  }
}
