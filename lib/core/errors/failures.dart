abstract class Failure {}

// خطأ بسبب السيرفر أو الـ API
class ServerFailure extends Failure {}

// خطأ بسبب انقطاع الإنترنت في الجوال
class OfflineFailure extends Failure {}