import 'dart:convert';

import 'package:driver/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  String token;
  SplashScreen({Key? key, required this.token}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controller2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: (10)),
      vsync: this,
    );
    _controller2 = AnimationController(
      duration: Duration(seconds: (10)),
      vsync: this,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Lottie.asset(
            'assets/lottie/ai.json',
            controller: _controller,
            height: MediaQuery.of(context).size.height * 1,
            animate: true,
            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..repeat()
                ..forward().whenComplete(() async {
                  // var data = await getUserData();
                  // print(data);
                  // (data=={})?
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => Container())):
                  //
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => LoginScreen(token: widget.token)));
                });
            },
          ),
          Lottie.asset(
            'assets/lottie/lottie_shieldv.json',
            controller: _controller2,
            height: MediaQuery.of(context).size.height * 1,
            animate: true,
            onLoaded: (composition) {
              _controller2
                ..duration = composition.duration
                ..repeat()
                ..forward().whenComplete(() async {
                  var data = await getUserData();
                  print(data);
                  (data == {})
                      ? Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Container()))
                      : Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginScreen(token: widget.token)));
                });
            },
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? user = sharedPreferences.get("user") as String?;
    var userData = json.decode(user ?? "{}");
    return userData;
  }
}
