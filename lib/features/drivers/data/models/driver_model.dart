class DriverModel {
  final int id;
  final int userId;
  final String fullName;
  final String carType;
  final String region;

  DriverModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.carType,
    required this.region,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'],
      userId: json['userId'],
      fullName: json['fullName'] ?? '',
      carType: json['carType'] ?? '',
      region: json['region'] ?? '',
    );
  }
}