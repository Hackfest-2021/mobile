import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class SocketIOWrapper {
  var channel;
  SocketIOWrapper() {
     channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.78.186:8000/ws/'),
    );

    channel.sink.add(json.encode({
      "action": "subscribe_to_DeviceSettings",
      "request_id": "sssdfk",
    }));
  }

  sendData(bytes) {
    String base64Image = base64Encode(bytes);
    print("sending data");
    this.channel.sink.add(
      json.encode({
        "action": "subscribe_to_DeviceSettings",
        "request_id": "sssdfk",
        "data": "${base64Image}"
      })
    );
  }
}
