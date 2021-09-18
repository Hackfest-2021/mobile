import 'dart:convert';

class NotificationPayload {

  final int alertId;
  final String alertName;
  final String driverName;

  NotificationPayload({required this.alertId, required this.alertName, required this.driverName});

  factory NotificationPayload.fromJsonString(String str) => NotificationPayload.fromJson(jsonDecode(str));

  String toJsonString() => jsonEncode(_toJson());

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    int alertId;
    if (json['alertId'] is int) {
      alertId = json['alertId'];
    } else {
      alertId = int.parse(json['alertId'] ?? "0");
    }

    return NotificationPayload(
      alertId: alertId,
      alertName: json['alertName'] ?? "",
      driverName: json['driverName'] ?? "",
    );
  }


  Map<String, dynamic> _toJson() => {
    'alertId': alertId,
    'alertName': alertName,
    'driverName': driverName,
  };
}