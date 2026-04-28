class User {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final String? city;
  final String? birthDate;
  final String? joinedDate;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.city,
    this.birthDate,
    this.joinedDate,
  });
}