import 'package:dio/dio.dart';
import 'package:driver/constants.dart';

class PollService {
  final Dio dio = Dio(BaseOptions(
    baseUrl: Constants.baseURL,
    connectTimeout: 3000,
    receiveTimeout: 5000,
  ));
  poll(int alertId, bool isTrue) async {
    Response response = await dio.post('trips/passenger/alert/${alertId}/', data: {
      "is_alert_valid":isTrue
    });
    print(" api response ${response.statusCode}");
    return response.data;
  }
}