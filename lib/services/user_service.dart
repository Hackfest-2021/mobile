import 'package:dio/dio.dart';

String base_url = "http://192.168.100.53:8000/";

class UserService {
  final Dio dio = Dio(BaseOptions(
    baseUrl: base_url,
    connectTimeout: 3000,
    receiveTimeout: 5000,
  ));

  login(String email, String password, String token) async {
    print("$email,$password,$token");
    Response response = await dio.post('account/login/', data: {
      'username': email,
      'password': password,
      "fcm_token":token

    });
    print(" api response ${response.statusCode}");
  }
}

class LoginResponse {}
