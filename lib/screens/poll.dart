import 'package:driver/services/poll_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PollScreen extends StatelessWidget {
  final PollService service = PollService();

  late int alertId;
  late String alertName;
  late String driverName;

  // PollScreen({Key? key, required this.alertId, required this.alertName, required this.driverName}) : super(key: key);
  PollScreen({Key? key, this.alertId = 1, this.alertName = "DROWSY", this.driverName = "Mr. Shakeeb Siddiqui"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(
                    top: 100.0, bottom: 100.0, right: 50.0, left: 50.0),
                child: Text(
                    "We have noticed that $driverName is violating for alert type: $alertName, do you think it is true?",
                    style: const TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 30)),
              )),
              Padding(
                  padding:
                      const EdgeInsets.only(bottom: 100.0, right: 50.0, left: 50.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          flex: 4,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 40)),
                            onPressed: () => service.poll(alertId, true),
                            child: const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text('Yes')),
                          )),
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                          flex: 4,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 40)),
                            onPressed: () => service.poll(alertId, false),
                            child: const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text('No')),
                          )),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
