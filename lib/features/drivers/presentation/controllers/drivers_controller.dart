import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/drivers_remote_data_source.dart';

class DriversController extends GetxController {
  final DriversRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  DriversController({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  var isLoading = false.obs;
  var drivers = [].obs;

  Future<void> fetchDrivers({String? carType, String? region}) async {
    try {
      isLoading.value = true;
      final result = await remoteDataSource.getDrivers(
        carType: carType,
        region: region,
      );
      drivers.value = result;
    } catch (e) {
      Get.snackbar('خطأ', 'فشل جلب السائقين');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addDriver({
    required String carType,
    required String region,
  }) async {
    try {
      isLoading.value = true;

      final token = sharedPreferences.getString('token') ?? '';

      await remoteDataSource.addDriver(
        carType: carType,
        region: region,
        token: token,
      );

      Get.snackbar('نجاح', 'تمت إضافة السائق بنجاح');
      Get.back();
      fetchDrivers();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل إضافة السائق');
    } finally {
      isLoading.value = false;
    }
  }
}