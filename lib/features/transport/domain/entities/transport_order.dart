class TransportOrder {
  final int id;
  final int listingId;
  final String listingTitle;
  final String? listingImage;
  final String? buyerId;
  final String deliveryAddress;
  final double fee;
  final int status;
  final DateTime createdAt;

  TransportOrder({
    required this.id,
    required this.listingId,
    required this.listingTitle,
    this.listingImage,
    this.buyerId,
    required this.deliveryAddress,
    required this.fee,
    required this.status,
    required this.createdAt,
  });
}