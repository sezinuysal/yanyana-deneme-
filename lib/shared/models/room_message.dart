class RoomMessage {
  final String id;
  final String roomId;
  final String authorName;
  final String text;
  final DateTime sentAt;
  final bool isFromMe;

  const RoomMessage({
    required this.id,
    required this.roomId,
    required this.authorName,
    required this.text,
    required this.sentAt,
    this.isFromMe = false,
  });

  RoomMessage copyWith({
    String? text,
    bool? isFromMe,
  }) {
    return RoomMessage(
      id: id,
      roomId: roomId,
      authorName: authorName,
      text: text ?? this.text,
      sentAt: sentAt,
      isFromMe: isFromMe ?? this.isFromMe,
    );
  }
}
