import '../../domain/entities/listing_details.dart';

class ListingDetailsModel extends ListingDetails {
  ListingDetailsModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.city,
    super.age,
    required super.categoryName,
    required super.sellerName,
    required super.sellerPhone,
    required super.sellerId,
    required super.dateAdded,
    required super.images,
  });

  factory ListingDetailsModel.fromJson(Map<String, dynamic> json) {
    return ListingDetailsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      city: json['city'] ?? '',
      age: json['age'],
      categoryName: json['categoryName'] ?? 'غير محدد',
      sellerName: json['sellerName'] ?? 'غير معروف',
      sellerPhone: json['sellerPhone'] ?? '',
      sellerId: json['sellerId'] ?? 0,
      dateAdded: json['dateAdded'] ?? '',
      // هنا نقوم بتحويل مصفوفة الصور القادمة من السيرفر إلى List<String> في فلاتر
      images: json['images'] != null ? List<String>.from(json['images']) : [],
    );
  }
}