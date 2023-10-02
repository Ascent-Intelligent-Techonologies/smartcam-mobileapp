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

class FCMHandler {
  static final FCMHandler _instance = FCMHandler._internal();
  static FCMHandler get instance => _instance;
  FCMHandler._internal();
  AlertsBloc? _alertsBloc;
  void init() async {
    try {
      FirebaseMessaging.instance.getToken();
    } catch (e) {
      logging(e.toString());
    }

    final tok = await FirebaseMessaging.instance.getToken();
    print('token: $tok');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      logging('Got a message whilst in the foreground!');
      logging('Message data: ${message.data}');
      refreshAlerts();
      if (message.notification != null) {
        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();

        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'default_channel',
          'Exwzd Foreground Channel',
          channelDescription: 'Foreground channel for all the notifications',
          icon: 'ic_launcher',
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
