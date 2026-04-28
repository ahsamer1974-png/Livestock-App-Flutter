// lib/features/listings/domain/entities/listing_details.dart

class ListingDetails {
  final int id;
  final String title;
  final String description; // التفاصيل الإضافية
  final double price;
  final String city;
  final String? age;
  final String categoryName;
  final String sellerName; // اسم البائع
  final String sellerPhone; // رقم البائع للتواصل
  final int sellerId; // معرف البائع
  final String dateAdded;
  final List<String> images; // قائمة بكل صور الإعلان

  ListingDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.city,
    this.age,
    required this.categoryName,
    required this.sellerName,
    required this.sellerPhone,
    required this.sellerId,
    required this.dateAdded,
    required this.images,
  });
}