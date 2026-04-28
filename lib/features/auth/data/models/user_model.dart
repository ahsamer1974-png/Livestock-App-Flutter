import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    required super.password, // تمت الإضافة ليطابق الأب
    super.city,
    super.birthDate,
    super.joinedDate, // تمت الإضافة ليطابق الأب
  });

  // دالة قراءة البيانات (من السيرفر إلى التطبيق)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // 🔥 التعديل هنا: محقق الأرقام يجيب الـ ID بجميع أشكاله الممكنة من السيرفر
    dynamic idData = json['id'] ?? json['Id'] ?? json['userId'] ?? json['UserId'];
    int parsedId = 0;
    if (idData != null) {
      parsedId = int.tryParse(idData.toString()) ?? 0;
    }

    return UserModel(
      id: parsedId,
      fullName: json['fullName'] ?? json['FullName'] ?? '',
      email: json['email'] ?? json['Email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['PhoneNumber'] ?? '',
      password: '', // نضع قيمة فارغة لأن السيرفر لا يرجع الباسورد
      city: json['city'] ?? json['City'],
      birthDate: json['birthDate'] ?? json['BirthDate'],
      joinedDate: json['joinedDate'] ?? json['JoinedDate'],
    );
  }

  // دالة إرسال البيانات (من التطبيق إلى السيرفر)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password, // نرسل الباسورد للسيرفر عند التسجيل
      'city': city ?? "غير محدد",
      'birthDate': birthDate,
    };
  }
}