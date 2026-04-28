import '../../domain/entities/contact.dart';

class ContactModel extends Contact {
  ContactModel({
    required super.contactId,
    required super.contactName,
    required super.lastMessage,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      contactId: json['contactId'] ?? json['ContactId'] ?? 0,
      contactName: json['contactName'] ?? json['ContactName'] ?? 'غير معروف',
      lastMessage: json['lastMessage'] ?? json['LastMessage'] ?? '...',
    );
  }
}