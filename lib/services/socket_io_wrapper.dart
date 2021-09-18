import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:websocket_channel_wrapper/websocket_channel_wrapper.dart';
// import 'package:websocket/websocket.dart';

class SocketIOWrapper {
  var channel;
  SocketIOWrapper() {


     channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.100.53:8000/ws/'),
    );

    channel.sink.add(json.encode({
      "action": "subscribe_to_DeviceSettings",
      "request_id": "sssdfk",
    }));
  }

  sendData(bytes){
    String base64Image = base64Encode(bytes);
    print("sending data");
    // print(base64Image);
    this.channel.sink.add(
      json.encode({
        "action": "subscribe_to_DeviceSettings",
        "request_id": "sssdfk",
        "data": "${base64Image}"
      })
    );
  }


  }

