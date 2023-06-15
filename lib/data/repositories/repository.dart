import 'package:smartcam_dashboard/data/models/alert.dart';
import 'package:smartcam_dashboard/data/models/filter_data.dart';
import 'package:smartcam_dashboard/data/models/update_alert_state.dart';

abstract class Repository {
  Future<List<Alert>> getAlerts();
  Future<FilterData> getFilters();
  Future<void> updateAlertState(UpdateAlertStateModel updateAlertState);
}
