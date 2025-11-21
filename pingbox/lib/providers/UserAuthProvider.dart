import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pingbox/Models/QuietHours.dart';
import 'package:pingbox/Models/UserModel.dart';
import 'package:pingbox/services/AuthService.dart';
import 'package:pingbox/services/UserService.dart';

class UserAuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  // Kullanıcı bilgileri
  User? _firebaseUser;
  UserModel? _userModel;

  // Loading states
  bool _isLoading = false;  //işlem sırasında
  bool _isInitializing = true;  //kullanıcı verilerini yüklerken

  // UI kısmında kullanılır
  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool get isInitializing => _isInitializing;
  bool get isAuthenticated => _firebaseUser != null;
  String get username => _userModel?.username ?? 'Misafir';
  String get email => _userModel?.email ?? '';
  String get avatarPath => _userModel?.avatarPath ?? 'assets/avatars/avatar_default.png';
  QuietHours get quietHours => _userModel?.quietHours ?? QuietHours();

  //  Uygulama başlarken kullanıcıyı yükle
  Future<void> initialize() async {
    _isInitializing = true;
    notifyListeners();

    _firebaseUser = FirebaseAuth.instance.currentUser;

    if (_firebaseUser != null) {
      await _loadUserData();
    }

    _isInitializing = false;
    notifyListeners();
  }

  // Kullanıcı verilerini yükle
  Future<void> _loadUserData() async {
    try {
      _userModel = await _userService.loadUser();
      notifyListeners();
    } catch (e) {
      print('Kullanıcı verisi yüklenemedi: $e');
    }
  }

  // Giriş yap
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _authService.signIn(email, password);

      if (user != null) {
        _firebaseUser = user;
        await _userService.updateFcmToken(); // FCM token güncelle
        await _loadUserData();

        _isLoading = false;
        notifyListeners();
        return AuthResult.success();
      }

      _isLoading = false;
      notifyListeners();
      return AuthResult.error('Giriş başarısız');
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return AuthResult.error(e.toString());
    }
  }

  //  Kayıt ol
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Kullanıcı oluştur
      final user = await _authService.signUp(email, password, username);

      if (user != null) {
        _firebaseUser = user;

        // Kullanıcı verilerini kaydet
        await _userService.saveUser(username);
        await _loadUserData();

        _isLoading = false;
        notifyListeners();
        return AuthResult.success();
      }

      _isLoading = false;
      notifyListeners();
      return AuthResult.error('Kayıt başarısız');
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return AuthResult.error(e.toString());
    }
  }

  // Çıkış yap
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await _authService.signOut();

    _firebaseUser = null;
    _userModel = null;

    _isLoading = false;
    notifyListeners();
  }

  //  Kullanıcı adını güncelle
  Future<bool> updateUsername(String newUsername) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _userService.saveUser(newUsername);
      await _loadUserData();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Username güncelleme hatası: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateAvatar(String newAvatarPath) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _userService.updateAvatar(newAvatarPath);
      await _loadUserData();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Avatar güncelleme hatası: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateQuietHours(QuietHours quietHours) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _userService.updateQuietHours(quietHours);
      await _loadUserData();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Sessiz saatler güncelleme hatası: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

// Auth sonuç sınıfı
class AuthResult {
  final bool isSuccess;
  final String? errorMessage;

  AuthResult.success() : isSuccess = true, errorMessage = null;

  AuthResult.error(this.errorMessage) : isSuccess = false;
}
