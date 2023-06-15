import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smartcam_dashboard/amplifyconfiguration.dart';
import 'package:smartcam_dashboard/blocs/session_cubit/session_cubit.dart';
import 'package:smartcam_dashboard/blocs/session_cubit/session_state.dart';
import 'package:smartcam_dashboard/data/fcm_handler.dart';
import 'package:smartcam_dashboard/data/repositories/auth_repository.dart';
import 'package:smartcam_dashboard/data/repositories/cognito_auth_repository.dart';
import 'package:smartcam_dashboard/firebase_options.dart';
import 'package:smartcam_dashboard/navigation/args.dart';
import 'package:smartcam_dashboard/simple_bloc_observer.dart';
import 'package:smartcam_dashboard/utils/utils.dart';
import 'package:smartcam_dashboard/views/alert_details_screen/alert_detail_screen.dart';
import 'package:smartcam_dashboard/views/all_alerts_screen/alerts_screen.dart';
import 'package:smartcam_dashboard/views/auth/auth_screen.dart';
import 'package:permission_handler/permission_handler.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _configureAmplify();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  if (Platform.isAndroid) {
    try {
      //TODO : Implement FCM and Local Notification for iOS
      const channel = AndroidNotificationChannel(
        'default_channel', // id
        'High Importance Notifications', // title
        description:
            'This channel is used for important notifications.', // description
        importance: Importance.high,
        playSound: true,

        sound: RawResourceAndroidNotificationSound('turbo'),
      );

      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    } on Exception catch (e) {
      logging(e.toString());
    }
  } else if (Platform.isIOS) {
    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  Bloc.observer = SimpleBlocObserver();
  Bloc.transformer = sequential();
  runApp(const MyApp());
}

Future<void> _configureAmplify() async {
  try {
    final auth = AmplifyAuthCognito();
    await Amplify.addPlugin(auth);

    // call Amplify.configure to use the initialized categories in your app
    await Amplify.configure(amplifyconfig);

    logging('Amplify configured');
  } on Exception catch (e) {
    logging('An error occurred configuring Amplify: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthRepository _authRepository;
  late final SessionCubit _sessionCubit;
  @override
  void initState() {
    super.initState();
    FCMHandler.instance.init();

    _authRepository = CognitoAuthRepository();
    _sessionCubit = SessionCubit(authRepo: _authRepository);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
      create: (context) => _authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SessionCubit>(
            create: (context) => _sessionCubit,
          ),
        ],
        child: BlocListener<SessionCubit, SessionState>(
          listener: (context, state) {
            if (state is Authenticated) {
              FCMHandler.instance.subscribeToTopic('exwzd');
            } else if (state is Unauthenticated) {
              FCMHandler.instance.unsubscribeFromTopic('exwzd');
            }
          },
          child: MaterialApp(
            navigatorKey: navigatorKey,
            theme: ThemeData(primaryColor: const Color(0xff1400C8)),
            home: Scaffold(body: BlocBuilder<SessionCubit, SessionState>(
              builder: (context, state) {
                if (state is Authenticated)
                  return AlertsScreen();
                else if (state is Unauthenticated)
                  return AuthScreen();
                else
                  return const Center(child: CircularProgressIndicator());
              },
            )),
            onGenerateRoute: (settings) {
              if (settings.name == AlertDetailScreen.routeName) {
                final args = settings.arguments as AlertDetailScreenArguments;
                return MaterialPageRoute(
                    builder: (context) => AlertDetailScreen(
                          alert: args.alert,
                        ));
              }

              return null;
            },
          ),
        ),
      ),
    );
  }
}
