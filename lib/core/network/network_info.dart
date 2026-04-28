import 'package:internet_connection_checker/internet_connection_checker.dart';

// الواجهة التي استخدمناها في المستودع (Repository)
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

// التنفيذ الفعلي باستخدام المكتبة
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}