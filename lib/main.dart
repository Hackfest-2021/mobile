import 'package:driver/screens/poll.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'screens/login.dart';
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

  String? token;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(primaryColorHex);

    return MaterialApp(
      title: 'Safe Rides',
      theme: ThemeData(
          splashColor: primaryColor,
          primarySwatch: createMaterialColor(primaryColor)
          // Colors.blue,
          ),
      home: Scaffold(
        body: FutureBuilder(
          // Initialize FlutterFire:
          future: initializeFirebase(),
          builder: (context, snapshot) {
            // Check for errors
            // if (snapshot.hasError) {
            //   return SomethingWentWrong();
            // }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return LoginScreen(
                token: token ?? "dfds",
              );
            }

            return Container();

            // Otherwise, show something whilst waiting for initialization to complete
            // return Loading();
          },
        ),
      ),
    );
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    // if (message.data['type'] == 'alert') {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => PollScreen()));
    // }
  }

  initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    this.token = await FirebaseMessaging.instance.getToken();

    await setupInteractedMessage();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // other properties...
              ),
            ));
      }
    });

    return firebaseApp;
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
