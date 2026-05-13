class ApiConstants {
  static const String baseUrl = "https://10.0.2.2:7229/api";
  // static const String baseUrl = "http://10.0.2.2:5230/api";

  // ==================== الإعلانات ====================
  static const String listings = "$baseUrl/ListingsApi";

  // ==================== السائقين ====================
  static const String drivers = "$baseUrl/DriversApi";

  // ==================== المستخدمين ====================
  static const String login = "$baseUrl/SettingsApi/Login";
  static const String register = "$baseUrl/SettingsApi/Register";
  static const String editProfile = "$baseUrl/SettingsApi/EditProfile";

  // ==================== المفضلة ====================
  static const String favorites = "$baseUrl/FavoritesApi";
  static const String toggleFavorite = "$baseUrl/FavoritesApi/Toggle";

  // ==================== الرسائل ====================
  static const String contacts = "$baseUrl/MessagesApi/Contacts";
  static const String chat = "$baseUrl/MessagesApi/Chat";
  static const String sendMessage = "$baseUrl/MessagesApi/Send";

  // ==================== الأقسام ====================
  static const String categories = "$baseUrl/CategoriesApi";
}