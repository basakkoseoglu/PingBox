
import 'package:pingbox/Models/QuietHours.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final String? fcmToken;
  final String avatarPath;
  final QuietHours quietHours;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
     this.fcmToken,
     this.avatarPath = 'assets/avatars/avatar_default.png',
      required this.quietHours,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      fcmToken: map['fcmToken'],
      avatarPath: map['avatarPath'] ?? 'assets/avatars/avatar_default.png',
      quietHours: QuietHours.fromMap(map['quietHours']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'fcmToken': fcmToken,
      'avatarPath': avatarPath,
      'quietHours': quietHours.toMap(),
    };
  }
}
