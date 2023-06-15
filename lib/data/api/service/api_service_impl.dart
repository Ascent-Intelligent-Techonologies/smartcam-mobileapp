import 'package:smartcam_dashboard/data/api/api_client.dart';
import 'package:smartcam_dashboard/data/api/service/api_service.dart';
import 'package:smartcam_dashboard/data/models/alert.dart';
import 'package:smartcam_dashboard/data/models/filter_data.dart';
import 'package:smartcam_dashboard/data/models/filter_option.dart';
import 'package:smartcam_dashboard/data/models/update_alert_state.dart';

class ApiServiceImpl extends ApiService {
  ApiServiceImpl(this.apiClient);
  final ApiClient apiClient;
  @override
  Future<List<AlertEntity>> getAlerts() async {
    final response = await apiClient.client.get(apiClient.getAlertEndpoint());
    return (response.data as List)
        .map<AlertEntity>((e) => AlertEntity.fromJson(e))
        .toList();
  }

  @override
  Future<FilterDataEntity> getFilters() async {
    final response = await apiClient.client.get(apiClient.getFiltersEndpoint());
    // print()
    List<FilterOptionEntity> entities = (response.data as List<dynamic>)
        .map((e) => FilterOptionEntity.fromJson(e))
        .toList();
    return FilterDataEntity(availableFilters: entities);
  }

  @override
  Future<void> updateAlertState(UpdateAlertStateEntity updateAlertState) async {
    final response = await apiClient.client.post(
        apiClient.updateAlertStateEndpoint(),
        data: updateAlertState.toJson());
  }
}
