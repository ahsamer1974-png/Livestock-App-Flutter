import 'package:get/get.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/favorite.dart';
import '../../domain/usecases/get_my_favorites.dart';
import '../../domain/usecases/toggle_favorite.dart';

class FavoritesController extends GetxController {
  final GetMyFavoritesUseCase getMyFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  FavoritesController({
    required this.getMyFavoritesUseCase,
    required this.toggleFavoriteUseCase,
  });

  // 🔻 المتغيرات التفاعلية 🔻
  var isLoading = false.obs;
  var favorites = <Favorite>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // جلب الإعلانات المفضلة أول ما تفتح الشاشة
    fetchFavorites();
  }

  // 1. جلب المفضلة
  Future<void> fetchFavorites() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await getMyFavoritesUseCase();

    result.fold(
          (failure) {
        if (failure is OfflineFailure) {
          errorMessage.value = 'تأكد من اتصالك بالإنترنت';
        } else {
          errorMessage.value = 'حدث خطأ أثناء جلب المفضلة';
        }
      },
          (data) {
        favorites.value = data;
      },
    );

    isLoading.value = false;
  }

  // 2. حذف/إضافة للمفضلة
  Future<void> toggleFavorite(int listingId) async {
    final result = await toggleFavoriteUseCase(listingId);

    result.fold(
          (failure) {
        Get.snackbar('خطأ', 'حدث مشكلة في الاتصال، حاول مرة أخرى', snackPosition: SnackPosition.BOTTOM);
      },
          (isFavorited) {
        if (!isFavorited) {
          // 🔥 ميزة رهيبة: إذا انحذف من المفضلة، نزيله من الشاشة فوراً!
          favorites.removeWhere((fav) => fav.listingId == listingId);
          Get.snackbar('نجاح', 'تمت الإزالة من المفضلة', snackPosition: SnackPosition.BOTTOM);
        } else {
          // 🔥 التعديل هنا: إذا انضاف للمفضلة، نحدث القائمة فوراً من السيرفر!
          fetchFavorites();
          Get.snackbar('نجاح', 'تمت الإضافة للمفضلة', snackPosition: SnackPosition.BOTTOM);
        }
      },
    );
  }
}