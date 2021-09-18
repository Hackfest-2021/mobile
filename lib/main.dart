import 'package:flutter/material.dart';

import 'screens/login.dart';
// @dart=2.9

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const primaryColorHex = 0xFFee424a;

  const MyApp({Key? key}) : super(key: key);

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
      home: LoginScreen(),
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
