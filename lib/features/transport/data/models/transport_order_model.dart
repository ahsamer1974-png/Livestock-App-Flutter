import '../../domain/entities/transport_order.dart';

class TransportOrderModel extends TransportOrder {
  TransportOrderModel({
    required super.id,
    required super.listingId,
    required super.listingTitle,
    super.listingImage,
    super.buyerId,
    required super.deliveryAddress,
    required super.fee,
    required super.status,
    required super.createdAt,
  });

  factory TransportOrderModel.fromJson(Map<String, dynamic> json) {
    return TransportOrderModel(
      id: json['id'] ?? 0,
      listingId: json['listingId'] ?? 0,
      listingTitle: json['listingTitle'] ?? '',
      listingImage: json['listingImage'],
      buyerId: json['buyerId'],
      deliveryAddress: json['deliveryAddress'] ?? '',
      fee: (json['fee'] ?? 0).toDouble(),
      status: json['status'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listingId': listingId,
      'listingTitle': listingTitle,
      'listingImage': listingImage,
      'buyerId': buyerId,
      'deliveryAddress': deliveryAddress,
      'fee': fee,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}