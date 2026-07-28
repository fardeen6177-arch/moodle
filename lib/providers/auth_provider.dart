import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthStatus _status = AuthStatus.uninitialized;
  UserModel? _userModel;
  String? _errorMessage;

  AuthProvider(this._authRepository) {
    _authRepository.authStateChanges.listen(
      _onAuthStateChanged,
    );
  }

  AuthStatus get status => _status;

  UserModel? get user => _userModel;

  String? get errorMessage => _errorMessage;

  bool get isAuthenticated =>
      _status == AuthStatus.authenticated;

  Future<void> _onAuthStateChanged(
      auth.User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = AuthStatus.unauthenticated;
      _userModel = null;
    } else {
      _status = AuthStatus.authenticated;

      _userModel = UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? "Student",
        email: firebaseUser.email ?? "",
        profileImageUrl: firebaseUser.photoURL,
      );
    }

    notifyListeners();
  }

  /// Login
  Future<bool> loginWithEmail(
    String email,
    String password,
  ) async {
    try {
      _status = AuthStatus.authenticating;
      _errorMessage = null;
      notifyListeners();

      _userModel = await _authRepository
          .signInWithEmailAndPassword(
        email,
        password,
      );

      _status = AuthStatus.authenticated;
      notifyListeners();

      return true;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage =
          e.toString().replaceAll("Exception: ", "");
      notifyListeners();

      return false;
    }
  }

  /// Register
  Future<bool> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      _status = AuthStatus.authenticating;
      _errorMessage = null;
      notifyListeners();

      _userModel =
          await _authRepository.registerWithEmailAndPassword(
        name,
        email,
        password,
      );

      _status = AuthStatus.authenticated;
      notifyListeners();

      return true;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage =
          e.toString().replaceAll("Exception: ", "");
      notifyListeners();

      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _authRepository.signOut();

    _status = AuthStatus.unauthenticated;
    _userModel = null;
    _errorMessage = null;

    notifyListeners();
  }

  void clearErrors() {
    _errorMessage = null;
    notifyListeners();
  }
}