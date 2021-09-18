import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PollScreen extends StatelessWidget {
  const PollScreen({Key? key}) : super(key: key);

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
              const Expanded(
                  child: Padding(
                padding: EdgeInsets.only(
                    top: 100.0, bottom: 100.0, right: 50.0, left: 50.0),
                child: Text(
                    "We have noticed that Mr. Ali Ahmed is violating for alert type: DROWSY, do you think it is true?",
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 30)),
              )),
              Padding(
                  padding:
                      EdgeInsets.only(bottom: 100.0, right: 50.0, left: 50.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          flex: 4,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 40)),
                            onPressed: () => print("Yes"),
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
                            onPressed: () => print("No"),
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
