class Message {
  final int id;
  final String content;
  final String sentAt;
  final bool isMine;
  final int? relatedListingId;
  final String? relatedListingTitle;

  Message({
    required this.id,
    required this.content,
    required this.sentAt,
    required this.isMine,
    this.relatedListingId,
    this.relatedListingTitle,
  });
}