import 'package:dio/dio.dart';

String base_url = "http://192.168.100.53:8000/";

class PollService {
  final Dio dio = Dio(BaseOptions(
    baseUrl: base_url,
    connectTimeout: 3000,
    receiveTimeout: 5000,
  ));
  poll(int alertId, bool isTrue) async {
    // print("$email,$password,$token");
    Response response = await dio.post('trips/passenger/alert/${alertId}/', data: {
      "is_alert_valid":isTrue
    });
    print(" api response ${response.statusCode}");
    return response.data;
  }
}