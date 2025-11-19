class UserModel {
  final String uid;
  final String email;
  final String username;
  final String? fcmToken;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
     this.fcmToken,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      fcmToken: map['fcmToken'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'fcmToken': fcmToken,
    };
  }
}
