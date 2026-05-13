import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/api_constants.dart';
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

  MessagesRemoteDataSourceImpl({required this.client});

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('auth_cookie') ?? '';

    return {
      'Content-Type': 'application/json',
      if (cookie.isNotEmpty) 'Cookie': cookie,
    };
  }

  @override
  Future<List<ContactModel>> getContacts() async {
    final headers = await _getHeaders();

    final response = await client.get(
      Uri.parse(ApiConstants.contacts),
      headers: headers,
    );

    print('Contacts Status: ${response.statusCode}');
    print('Contacts Body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);

      if (decodedJson['success'] == true) {
        final List data = decodedJson['data'];
        return data.map((contact) => ContactModel.fromJson(contact)).toList();
      }
    }

    throw ServerException();
  }

  @override
  Future<List<MessageModel>> getChatHistory(int receiverId) async {
    final headers = await _getHeaders();

    final response = await client.get(
      Uri.parse('${ApiConstants.chat}/$receiverId'),
      headers: headers,
    );

    print('Chat Status: ${response.statusCode}');
    print('Chat Body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);

      if (decodedJson['success'] == true) {
        final List data = decodedJson['data'];
        return data.map((msg) => MessageModel.fromJson(msg)).toList();
      }
    }

    throw ServerException();
  }

  @override
  Future<MessageModel> sendMessage(
      int receiverId,
      String content, {
        int? listingId,
      }) async {
    final headers = await _getHeaders();

    final response = await client.post(
      Uri.parse(ApiConstants.sendMessage),
      headers: headers,
      body: json.encode({
        'receiverId': receiverId,
        'content': content,
        'listingId': listingId,
      }),
    );

    print('Send Message Status: ${response.statusCode}');
    print('Send Message Body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);

      if (decodedJson['success'] == true) {
        return MessageModel.fromJson(decodedJson['sentMessage']);
      }
    }

    throw ServerException();
  }
}