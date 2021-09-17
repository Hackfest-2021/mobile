import 'package:dio/dio.dart';

class UserService {
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://www.xx.com/api',
    connectTimeout: 3000,
    receiveTimeout: 5000,
  ));

  login(String email, String password) async {
    return;
    Response<LoginResponse> response = await dio.post('/test', data: {'id': 12, 'name': 'wendu'});
  }
}

class LoginResponse {

}