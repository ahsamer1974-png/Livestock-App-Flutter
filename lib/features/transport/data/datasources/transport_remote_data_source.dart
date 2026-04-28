import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/transport_order_model.dart';

abstract class TransportRemoteDataSource {
  Future<String> requestTransport(int listingId, String address, double fee, String token);
  Future<List<TransportOrderModel>> getMyOrders(String token);
  Future<List<TransportOrderModel>> getIncomingOrders(String token);
  Future<String> startDelivery(int orderId, String token);
}

class TransportRemoteDataSourceImpl implements TransportRemoteDataSource {
  final http.Client client;

  TransportRemoteDataSourceImpl({required this.client});

  final String _baseUrl = '${ApiConstants.baseUrl}/TransportApi';

  @override
  Future<String> requestTransport(int listingId, String address, double fee, String token) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/request'),
      // ✅ التعديل هنا: استخدام Cookie بدلاً من Authorization
      headers: {'Content-Type': 'application/json', 'Cookie': token},
      body: json.encode({'listingId': listingId, 'address': address, 'fee': fee}),
    );
    print("📦 Status (Request): ${response.statusCode} | Body: ${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body)['message'];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TransportOrderModel>> getMyOrders(String token) async {
    print("🌐 GET: $_baseUrl/my-orders");
    final response = await client.get(
      Uri.parse('$_baseUrl/my-orders'),
      // ✅ التعديل هنا
      headers: {'Content-Type': 'application/json', 'Cookie': token},
    );
    print("📦 Status (MyOrders): ${response.statusCode} | Body: ${response.body}");
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((json) => TransportOrderModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TransportOrderModel>> getIncomingOrders(String token) async {
    print("🌐 GET: $_baseUrl/incoming-orders");
    final response = await client.get(
      Uri.parse('$_baseUrl/incoming-orders'),
      // ✅ التعديل هنا
      headers: {'Content-Type': 'application/json', 'Cookie': token},
    );
    print("📦 Status (Incoming): ${response.statusCode} | Body: ${response.body}");
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((json) => TransportOrderModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> startDelivery(int orderId, String token) async {
    final response = await client.put(
      Uri.parse('$_baseUrl/start-delivery/$orderId'),
      // ✅ التعديل هنا
      headers: {'Content-Type': 'application/json', 'Cookie': token},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['message'];
    } else {
      throw ServerException();
    }
  }
}