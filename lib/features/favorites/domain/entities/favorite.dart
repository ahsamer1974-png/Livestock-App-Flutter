class Favorite {
  final int favoriteId;
  final int listingId;
  final String title;
  final double price;
  final String city;
  final String categoryName;
  final String coverImage;
  final String dateAdded;

  Favorite({
    required this.favoriteId,
    required this.listingId,
    required this.title,
    required this.price,
    required this.city,
    required this.categoryName,
    required this.coverImage,
    required this.dateAdded,
  });
}