import 'package:smartcam_dashboard/data/models/alert.dart';
import 'package:smartcam_dashboard/data/models/filter_data.dart';
import 'package:smartcam_dashboard/data/models/update_alert_state.dart';

abstract class ApiService {
  Future<List<AlertEntity>> getAlerts();
  Future<FilterDataEntity> getFilters();
  Future<void> updateAlertState(UpdateAlertStateEntity updateAlertState);
}
