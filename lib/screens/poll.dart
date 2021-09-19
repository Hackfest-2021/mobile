import 'package:driver/models/notification_payload.dart';
import 'package:driver/services/poll_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PollScreen extends StatefulWidget {
  late NotificationPayload payload;

  PollScreen({Key? key, required this.payload}) : super(key: key);

  @override
  _PollScreenState createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  final PollService service = PollService();

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).splashColor;

    String driverName = widget.payload.driverName;
    String alertName = widget.payload.alertName;

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
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30)),
              )),
              Padding(
                  padding: const EdgeInsets.only(
                      bottom: 100.0, right: 50.0, left: 50.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          flex: 4,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 40)),
                            onPressed: () => vote(true),
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
                            onPressed: () => vote(false),
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

  vote(bool isTrue) {
    service.poll(widget.payload.alertId, isTrue);
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
  }
}
