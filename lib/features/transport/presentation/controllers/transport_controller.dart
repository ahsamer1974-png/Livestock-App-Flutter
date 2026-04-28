import 'package:get/get.dart';
import '../../domain/usecases/get_my_orders_usecase.dart';
import '../../domain/usecases/get_incoming_orders_usecase.dart';
import '../../domain/usecases/start_delivery_usecase.dart';
import '../../domain/usecases/request_transport_usecase.dart';

class TransportController extends GetxController {
  final GetMyOrdersUseCase getMyOrdersUseCase;
  final GetIncomingOrdersUseCase getIncomingOrdersUseCase;
  final StartDeliveryUseCase startDeliveryUseCase;
  final RequestTransportUseCase requestTransportUseCase;

  TransportController({
    required this.getMyOrdersUseCase,
    required this.getIncomingOrdersUseCase,
    required this.startDeliveryUseCase,
    required this.requestTransportUseCase,
  });

  var isLoading = false.obs;
  var myOrders = [].obs;
  var incomingOrders = [].obs;

  Future<void> requestTransport(int listingId, String address, double fee) async {
    isLoading.value = true;
    final result = await requestTransportUseCase(listingId, address, fee);
    result.fold(
          (failure) => Get.snackbar("خطأ", "لم يتم إرسال الطلب، تأكد من الاتصال"),
          (message) {
        Get.snackbar("نجاح", message);
        getMyOrders();
      },
    );
    isLoading.value = false;
  }

  Future<void> getMyOrders() async {
    isLoading.value = true;
    final result = await getMyOrdersUseCase();
    result.fold(
          (failure) {
        Get.snackbar("تنبيه", "فشل جلب مشترياتي، راجع الكونسول");
        myOrders.clear();
      },
          (orders) => myOrders.value = orders,
    );
    isLoading.value = false;
  }

  Future<void> getIncomingOrders() async {
    isLoading.value = true;
    final result = await getIncomingOrdersUseCase();
    result.fold(
          (failure) {
        Get.snackbar("تنبيه", "فشل جلب الطلبات الواردة، راجع الكونسول");
        incomingOrders.clear();
      },
          (orders) => incomingOrders.value = orders,
    );
    isLoading.value = false;
  }

  Future<void> acceptOrder(int orderId) async {
    isLoading.value = true;
    final result = await startDeliveryUseCase(orderId);
    result.fold(
            (f) => Get.snackbar("خطأ", "فشل تحديث الحالة"),
            (msg) {
          Get.snackbar("نجاح", msg);
          getIncomingOrders();
        }
    );
    isLoading.value = false;
  }
}