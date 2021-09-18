import 'dart:convert';

class NotificationPayload {

  final String type;
  final int alertId;
  final String alertName;
  final String driverName;

  NotificationPayload({required this.type, required this.alertId, required this.alertName, required this.driverName});

  factory NotificationPayload.fromJsonString(String str) => NotificationPayload.fromJson(jsonDecode(str));

  String toJsonString() => jsonEncode(_toJson());

  factory NotificationPayload.fromJson(Map<String, dynamic> json) => NotificationPayload(
    type: json['type'] ?? "",
    alertId: json['alertId'] ?? 0,
    alertName: json['alertName'] ?? "",
    driverName: json['driverName'] ?? "",
  );


  Map<String, dynamic> _toJson() => {
    'type': type,
    'alertId': alertId,
    'alertName': alertName,
    'driverName': driverName,
  };
}