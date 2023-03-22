class ChatMessage {
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  String type;
  String url;

  @override
  String toString() {
    return 'ChatMessage{idFrom: $idFrom, idTo: $idTo, timestamp: $timestamp, content: $content, type: $type, url: $url}';
  }

  ChatMessage({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.type,
    required this.url,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      idFrom: map['idFrom'] as String,
      idTo: map['idTo'] as String,
      timestamp: map['timestamp'] as String,
      content: map['content'] as String,
      type: map['type'] as String,
      url: map['url'] ?? '',
    );
  }
}
