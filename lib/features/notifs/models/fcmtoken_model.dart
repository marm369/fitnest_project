class fcmtokenModel {
  final int recipient;
  final String token;

  fcmtokenModel({
    required this.recipient,
    required this.token,
  });

  factory fcmtokenModel.fromJson(Map<String, dynamic> json) {
    return fcmtokenModel(
      recipient: json['userid'],
      token: json['token'],
    );
  }
}
