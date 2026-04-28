import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/contact_model.dart';
import '../models/message_model.dart';

abstract class MessagesRemoteDataSource {
  Future<List<ContactModel>> getContacts();
  Future<List<MessageModel>> getChatHistory(int receiverId);
  Future<MessageModel> sendMessage(int receiverId, String content, {int? listingId});
}

class MessagesRemoteDataSourceImpl implements MessagesRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'http://10.0.2.2:5230/api/MessagesApi';

  MessagesRemoteDataSourceImpl({required this.client});

  // =========================================================
  // 🔐 دالة جلب الـ Headers (مع الكوكي المحفوظ)
  // =========================================================
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('auth_cookie') ?? '';

    return {
      'Content-Type': 'application/json',
      if (cookie.isNotEmpty) 'Cookie': cookie,
    };
  }

  // =========================================================
  // 📥 دالة جلب جهات الاتصال (مع الرادار)
  // =========================================================
  @override
  Future<List<ContactModel>> getContacts() async {
    final headers = await _getHeaders();

    // 💡 طباعة للتأكد من أن الكوكي يخرج من الجوال
    print('================= فحص قسم الرسائل =================');
    print('📡 الـ Headers اللي رايحة للسيرفر: $headers');

    final response = await client.get(
      Uri.parse('$baseUrl/Contacts'),
      headers: headers,
    );

    // 🔴 حط نقطة التوقف (Debug Breakpoint) في السطر اللي تحت هذا مباشرة 👇
    print('📥 كود استجابة السيرفر: ${response.statusCode}');
    print('📥 محتوى رد السيرفر: ${response.body}');
    print('==================================================');

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      if (decodedJson['success'] == true) {
        final List data = decodedJson['data'];
        return data.map((contact) => ContactModel.fromJson(contact)).toList();
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  // =========================================================
  // 📥 دالة جلب تاريخ المحادثة
  // =========================================================
  @override
  Future<List<MessageModel>> getChatHistory(int receiverId) async {
    final headers = await _getHeaders();
    final response = await client.get(
      Uri.parse('$baseUrl/Chat/$receiverId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      if (decodedJson['success'] == true) {
        final List data = decodedJson['data'];
        return data.map((msg) => MessageModel.fromJson(msg)).toList();
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  // =========================================================
  // 📤 دالة إرسال رسالة
  // =========================================================
  @override
  Future<MessageModel> sendMessage(int receiverId, String content, {int? listingId}) async {
    final headers = await _getHeaders();

    final body = json.encode({
      'ReceiverId': receiverId,
      'Content': content,
      'ListingId': listingId,
    });

    final response = await client.post(
      Uri.parse('$baseUrl/Send'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      if (decodedJson['success'] == true) {
        return MessageModel.fromJson(decodedJson['sentMessage']);
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }
}