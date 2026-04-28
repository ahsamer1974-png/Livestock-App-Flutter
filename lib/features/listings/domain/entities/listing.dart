// lib/features/listings/domain/entities/listing.dart

class Listing {
  final int id;
  final String title;
  final double price; // السعر قد يكون فيه كسور (أو int إذا كان دائماً صحيحاً)
  final String city;
  final String? age; // العمر اختياري بناءً على الموديل السابق
  final String categoryName;
  final String dateAdded;
  final String coverImage; // صورة الغلاف

  Listing({
    required this.id,
    required this.title,
    required this.price,
    required this.city,
    this.age,
    required this.categoryName,
    required this.dateAdded,
    required this.coverImage,
  });
}