import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // 💡 استيراد الذاكرة المحلية
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> register(UserModel user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse(ApiConstants.login),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);

      if (decodedJson['success'] == true) {

        // 🔥 التعديل السحري هنا: التقاط الكوكي من السيرفر وحفظه في الجوال
        String? rawCookie = response.headers['set-cookie'];
        if (rawCookie != null) {
          final prefs = await SharedPreferences.getInstance();
          // السيرفر قد يرسل تفاصيل كثيرة في الكوكي، نحن نأخذ الجزء المهم فقط (نقسمه عند الفاصلة المنقوطة)
          final cookieValue = rawCookie.split(';').first;
          await prefs.setString('auth_cookie', cookieValue);
          print('✅ تم حفظ الكوكي بنجاح: $cookieValue'); // للطباعة والتأكد
        }

        return UserModel.fromJson(decodedJson['userData']);
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> register(UserModel user) async {
    final response = await client.post(
      Uri.parse(ApiConstants.register),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      if (decodedJson['success'] == false) {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }
}