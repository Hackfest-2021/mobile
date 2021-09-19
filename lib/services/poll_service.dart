import 'package:dio/dio.dart';
import 'package:driver/constants.dart';

class PollService {
  final Dio dio = Dio(BaseOptions(
    baseUrl: Constants.baseURL,
    connectTimeout: 3000,
    receiveTimeout: 5000,
  ));
  poll(int alertId, bool isTrue) async {
    Response response = await dio.patch('trips/passenger/alert/${alertId}/',
        data: {"is_alert_valid": isTrue});
    return response.data;
  }
}
