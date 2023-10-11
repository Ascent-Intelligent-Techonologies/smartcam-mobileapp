import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smartcam_dashboard/blocs/alerts/alerts_bloc.dart';
import 'package:smartcam_dashboard/data/models/alert.dart';
import 'package:smartcam_dashboard/main.dart';
import 'package:smartcam_dashboard/navigation/args.dart';
import 'package:smartcam_dashboard/utils/utils.dart';
import 'package:smartcam_dashboard/views/alert_details_screen/alert_detail_screen.dart';
import 'package:smartcam_dashboard/data/api/api_client.dart';
import 'package:smartcam_dashboard/data/repositories/auth_repository.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:developer';

class FCMHandler {
  static final FCMHandler _instance = FCMHandler._internal();
  static FCMHandler get instance => _instance;
  late final AuthRepository _cognitoAuthRepo;
  FCMHandler._internal();
  AlertsBloc? _alertsBloc;
  void init() async {
    try {
      FirebaseMessaging.instance.getToken();
    } catch (e) {
      logging(e.toString());
    }

    final tok = await FirebaseMessaging.instance.getToken();
    // print('token: $tok');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      logging('Got a message whilst in the foreground!');
      logging('Message data: ${message.data}');
      refreshAlerts();
      if (message.notification != null) {
        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        
        // Download the large icon from the S3 URL
        var s3_key = ApiClient.pathToKey(s3Path:message.notification!.face_crop_path!);
        var jwtToken = await _cognitoAuthRepo.getJwtToken();
        var url = ApiClient.getJWTQuery(token:jwtToken,s3Key:s3_key);
        print(url);
        logging(url);        
        log(url);

        // var response = await http.get(Uri.parse(url));
        // var largeIconBitmap = response.bodyBytes;
        // 2. Convert Uint8List to AndroidBitmap
        // final AndroidBitmap androidBitmap = ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.bodyBytes));
        // const androidBitmap = ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.bodyBytes)) as AndroidBitmap<Object>;
        // final AndroidBitmap androidBitmap = ByteArrayAndroidBitmap.fromBase64String(base64.encode(largeIconBitmap)) as AndroidBitmap<Object>;
        // Create an image file in the documents directory
        // final directory = await getApplicationDocumentsDirectory();
        // final String filepath = '${directory}/temp.png';
        // final File file = File(filepath);
         
        // Write the image bytes to the file
        // await file.writeAsBytes(largeIconBitmap);
        Future<String> _downloadAndSaveFile(String url, String fileName) async {
          final Directory directory = await getApplicationDocumentsDirectory();
          final String filePath = '${directory.path}/$fileName';
          final http.Response response = await http.get(Uri.parse(url));
          final File file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);
          return filePath;
        }
        final String largeIconPath = await _downloadAndSaveFile('${url}', 'largeIcon.png');
        print(largeIconPath);
        print("------------------");
        logging(largeIconPath);
        logging("------------------");
        final AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'default_channel',
          'Exwzd Foreground Channel',
          channelDescription: 'Foreground channel for all the notifications',
          icon: 'ic_launcher',
          largeIcon: FilePathAndroidBitmap(largeIconPath),
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

        

        NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
          1,
          message.notification!.title,
          message.notification!.body,
          platformChannelSpecifics,
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['screen'] == AlertDetailScreen.routeName) {
        navigatorKey.currentState!.pushNamed(AlertDetailScreen.routeName,
            arguments: AlertDetailScreenArguments(
                alert: Alert.fromEntity(AlertEntity(
              datetime: message.data['datetime'],
              s3Path: message.data['s3_path'],
              category: message.data['category'],
            ))));
      }
    });
    // FirebaseMessaging.onBackgroundMessage(
    //     (message) => _backgroundHandler(message));
  }

  void initAlertsBloc(AlertsBloc bloc) {
    _alertsBloc = bloc;
  }

  void refreshAlerts() {
    if (_alertsBloc != null) {
      _alertsBloc!.add(GetAlertsEvent());
    }
  }

  // _backgroundHandler(RemoteMessage message) {
  //   logging("background handler: $message");
  // }

  subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }
}
