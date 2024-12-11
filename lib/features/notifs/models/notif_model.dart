
class NotificationModel {
  final int recipient;
  final String type;
  final String content;
  final DateTime timestamp;
  final String token;

  NotificationModel({
    required this.recipient,
    required this.type,
    required this.content,
    required this.timestamp,
    required this.token,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      recipient: json['recipient'],
      type: json['type'],
      content: json['content'],
      timestamp: DateTime.tryParse(json['timestamp']) ?? DateTime.now(),
      token: json['token'],
    );
  }
}