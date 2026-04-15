class UserModel {
  final String id;
  final String email;
  final String token;
  final DateTime tokenExpiry;

  UserModel({
    required this.id,
    required this.email,
    required this.token,
    required this.tokenExpiry,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      token: json['token'],
      tokenExpiry: DateTime.parse(json['tokenExpiry']),
    );
  }

  bool get isTokenExpired => DateTime.now().isAfter(tokenExpiry);

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "token": token,
    "tokenExpiry": tokenExpiry.toIso8601String(),
  };
}
