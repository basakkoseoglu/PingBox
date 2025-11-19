import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiyatalarm/Models/UserModel.dart';
import 'package:fiyatalarm/services/AuthService.dart';
import 'package:fiyatalarm/services/UserService.dart';
import 'package:flutter/material.dart';


class UserAuthProvider extends ChangeNotifier {  
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  // Kullanıcı bilgileri
  User? _firebaseUser;
  UserModel? _userModel;
  
  // Loading states
  bool _isLoading = false;
  bool _isInitializing = true;

  // Getters
  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool get isInitializing => _isInitializing;
  bool get isAuthenticated => _firebaseUser != null;
  String get username => _userModel?.username ?? 'Misafir';
  String get email => _userModel?.email ?? '';

  // ✅ Uygulama başlarken kullanıcıyı yükle
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

  // ✅ Kullanıcı verilerini yükle
  Future<void> _loadUserData() async {
    try {
      _userModel = await _userService.loadUser();
      notifyListeners();
    } catch (e) {
      print('Kullanıcı verisi yüklenemedi: $e');
    }
  }

  // ✅ Giriş yap
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

  // ✅ Kayıt ol
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

  // ✅ Çıkış yap
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await _authService.signOut();
    
    _firebaseUser = null;
    _userModel = null;
    
    _isLoading = false;
    notifyListeners();
  }

  // ✅ Kullanıcı adını güncelle
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
}

// ✅ Auth sonuç sınıfı
class AuthResult {
  final bool isSuccess;
  final String? errorMessage;

  AuthResult.success()
      : isSuccess = true,
        errorMessage = null;

  AuthResult.error(this.errorMessage) : isSuccess = false;
}