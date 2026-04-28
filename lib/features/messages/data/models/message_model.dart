import '../../domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    required super.id,
    required super.content,
    required super.sentAt,
    required super.isMine,
    super.relatedListingId,
    super.relatedListingTitle,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? json['Id'] ?? 0,
      content: json['content'] ?? json['Content'] ?? '',
      sentAt: json['sentAt'] ?? json['SentAt'] ?? '',
      isMine: json['isMine'] ?? json['IsMine'] ?? false,
      relatedListingId: json['relatedListingId'] ?? json['RelatedListingId'],
      relatedListingTitle: json['relatedListingTitle'] ?? json['RelatedListingTitle'],
    );
  }
}