import '../../domain/entities/listing.dart';

class ListingModel extends Listing {
  ListingModel({
    required super.id,
    required super.title,
    required super.price,
    required super.city,
    super.age,
    required super.categoryName,
    required super.dateAdded,
    required super.coverImage,
  });

  // هذه الدالة السحرية تأخذ الـ JSON من السيرفر وتحوله إلى كائن ListingModel
  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      // استخدمنا toDouble() لضمان عدم حدوث خطأ إذا أرسل السيرفر السعر كرقم صحيح (int)
      price: (json['price'] ?? 0).toDouble(),
      city: json['city'] ?? '',
      age: json['age'],
      categoryName: json['categoryName'] ?? 'غير محدد',
      dateAdded: json['dateAdded'] ?? '',
      coverImage: json['coverImage'] ?? '',
    );
  }
}