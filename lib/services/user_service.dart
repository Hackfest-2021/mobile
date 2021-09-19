import 'package:dio/dio.dart';
import 'package:driver/constants.dart';

class UserService {
  final Dio dio = Dio(BaseOptions(
    baseUrl: Constants.baseURL,
    connectTimeout: 3000,
    receiveTimeout: 5000,
  ));

  Future<dynamic> login(String email, String password, String token) async {
    print("$email,$password,$token");
    Response response = await dio.post('account/login/', data: {
      'username': email,
      'password': password,
      "fcm_token":token

    });
    print(" api response ${response.statusCode}");
  return response.data;
  }
}

class LoginResponse {}
