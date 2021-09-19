import 'dart:math';

import 'package:driver/screens/poll.dart';
import 'package:driver/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'models/notification_payload.dart';
// @dart=2.9

// Future<void> saveTokenToDatabase(String token) async {
//
// }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const primaryColorHex = 0xFFee424a;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  String? token;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(primaryColorHex);

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Safe Rides',
      theme: ThemeData(
          splashColor: primaryColor,
          primarySwatch: createMaterialColor(primaryColor)
          // Colors.blue,
          ),
      home: Scaffold(
        body: MainScreen(navigatorKey: navigatorKey,),
      ),
    );
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

class MainScreen extends StatefulWidget {
  late GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  MainScreen({Key? key, required this.navigatorKey}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? token;

  @override
  void initState() {
    super.initState();
    if (!mounted) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeFirebase(),
      builder: (context, snapshot) {
        // Check for errors
        // if (snapshot.hasError) {
        //   return SomethingWentWrong();
        // }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            RemoteMessage message = snapshot.data as RemoteMessage;
            NotificationPayload payload = NotificationPayload.fromJson(message.data);
            return PollScreen(payload: payload);

          }
          return SplashScreen(token: token??"ssss",);
        }

        return Container();
      },
    );
  }

  Future<RemoteMessage?> initializeFirebase() async {
    await Firebase.initializeApp();
    this.token = await FirebaseMessaging.instance.getToken();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      Map<String, dynamic> data = message.data;
      NotificationPayload payload = NotificationPayload.fromJson(data);

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            Random().nextInt(10000),
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // other properties...
              ),
            ),
            payload: payload.toJsonString());
      }
    });

    return setupInteractedMessage();
  }

  Future onSelectNotification(String? data) async {
    if (data != null) {
      NotificationPayload payload = NotificationPayload.fromJsonString(data);
      Navigator.push(
          widget.navigatorKey.currentState!.context,
          MaterialPageRoute(
              builder: (context) => PollScreen(
                    payload: payload,
                  )));
    }
  }

  Future<RemoteMessage?> setupInteractedMessage() async {
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    return FirebaseMessaging.instance.getInitialMessage();
  }

  void _handleMessage(RemoteMessage message) {
    // if (message.data['type'] == 'alert') {
    NotificationPayload payload = NotificationPayload.fromJson(message.data);

    Navigator.pushReplacement(
        widget.navigatorKey.currentState!.context,
        MaterialPageRoute(
            builder: (context) => PollScreen(
                  payload: payload,
                )));
    // }
  }
}
