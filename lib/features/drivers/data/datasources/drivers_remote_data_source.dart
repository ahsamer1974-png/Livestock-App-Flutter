import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/driver_model.dart';

class DriversRemoteDataSource {
  final http.Client client;

  DriversRemoteDataSource({required this.client});

  Future<List<DriverModel>> getDrivers({
    String? carType,
    String? region,
  }) async {
    final uri = Uri.parse(ApiConstants.drivers).replace(
      queryParameters: {
        if (carType != null && carType.isNotEmpty) 'carType': carType,
        if (region != null && region.isNotEmpty) 'region': region,
      },
    );

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];
      return data.map((e) => DriverModel.fromJson(e)).toList();
    }

    throw Exception('Failed to load drivers');
  }

  Future<String> addDriver({
    required String carType,
    required String region,
    required String token,
  }) async {
    final response = await client.post(
      Uri.parse(ApiConstants.drivers),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': token,
      },
      body: jsonEncode({
        'carType': carType,
        'region': region,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    }

    throw Exception('Failed to add driver');
  }
}