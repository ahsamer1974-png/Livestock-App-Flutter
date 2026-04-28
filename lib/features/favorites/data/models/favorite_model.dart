import '../../domain/entities/favorite.dart';

class FavoriteModel extends Favorite {
  FavoriteModel({
    required super.favoriteId,
    required super.listingId,
    required super.title,
    required super.price,
    required super.city,
    required super.categoryName,
    required super.coverImage,
    required super.dateAdded,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    // السيرفر يرسل كائن Listing داخله البيانات
    final listingJson = json['listing'] ?? json['Listing'] ?? {};

    return FavoriteModel(
      favoriteId: json['favoriteId'] ?? json['FavoriteId'] ?? 0,
      listingId: listingJson['id'] ?? listingJson['Id'] ?? 0,
      title: listingJson['title'] ?? listingJson['Title'] ?? 'بدون عنوان',
      price: (listingJson['price'] ?? listingJson['Price'] ?? 0).toDouble(),
      city: listingJson['city'] ?? listingJson['City'] ?? 'غير محدد',
      categoryName: listingJson['categoryName'] ?? listingJson['CategoryName'] ?? 'غير محدد',
      coverImage: listingJson['coverImage'] ?? listingJson['CoverImage'] ?? '',
      dateAdded: listingJson['dateAdded'] ?? listingJson['DateAdded'] ?? '',
    );
  }
}