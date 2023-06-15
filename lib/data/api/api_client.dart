import 'package:dio/dio.dart';
import 'package:smartcam_dashboard/env.dart';

class ApiClient {
  final Dio _dioClient = Dio();
  Dio get client => _dioClient;

  String baseUrl = BASEURL;
  String getAlertEndpoint() {
    return '$baseUrl/get_alerts';
  }

  String getFiltersEndpoint() {
    return '$baseUrl/filters';
  }

  String updateAlertStateEndpoint() {
    return '$baseUrl/update_alert_state';
  }

  static String cdnBaseUrl = CDN_BASEURL;

  static String getJWTQuery({required String token, required String s3Key}) {
    final url = '$cdnBaseUrl/$s3Key?jwt=$token';
    return url;
  }

  static String pathToKey({required String s3Path}) {
    // #slice 3 and join with /

    return s3Path.split("/").sublist(3).join("/");
    // .slice(3).join("/")
  }
}
