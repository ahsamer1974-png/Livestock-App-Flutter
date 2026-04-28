import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/favorite_model.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<FavoriteModel>> getMyFavorites();
  Future<bool> toggleFavorite(int listingId);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'http://10.0.2.2:5230/api/FavoritesApi';

  FavoritesRemoteDataSourceImpl({required this.client});

  // =========================================================
  // 🔐 دالة جلب الـ Headers (مع الكوكي المحفوظ)
  // =========================================================
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('auth_cookie') ?? '';

    return {
      'Content-Type': 'application/json',
      // 🔥 نرسل الكوكي ليسمح لنا السيرفر بالدخول
      if (cookie.isNotEmpty) 'Cookie': cookie,
    };
  }

  @override
  Future<List<FavoriteModel>> getMyFavorites() async {
    final headers = await _getHeaders();
    final response = await client.get(
      Uri.parse(baseUrl), // يستدعي دالة GetMyFavorites
      headers: headers,
    );

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      if (decodedJson['success'] == true) {
        final List data = decodedJson['data'];
        return data.map((fav) => FavoriteModel.fromJson(fav)).toList();
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> toggleFavorite(int listingId) async {
    final headers = await _getHeaders();
    final response = await client.post(
      Uri.parse('$baseUrl/Toggle/$listingId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      if (decodedJson['success'] == true) {
        // نرجع true إذا صار مفضل، و false إذا انحذف
        return decodedJson['isFavorited'];
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }
}