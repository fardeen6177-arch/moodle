import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthRepository {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  AuthRepository(
    this._authService,
    this._firestoreService,
  );

  /// Firebase auth state stream
  Stream<auth.User?> get authStateChanges =>
      _authService.authStateChanges;

  /// Current logged-in Firebase user
  auth.User? get currentUser =>
      _authService.currentUser;

  /// Login with Email & Password
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential =
        await _authService.signInWithEmailAndPassword(
      email,
      password,
    );

    final firebaseUser = credential.user;

    if (firebaseUser == null) {
      throw Exception("Authentication failed.");
    }

    return await _getOrCreateUserDocument(
      firebaseUser,
    );
  }

  /// Register with Email & Password
  Future<UserModel> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    final credential =
        await _authService.registerWithEmailAndPassword(
      email,
      password,
    );

    final firebaseUser = credential.user;

    if (firebaseUser == null) {
      throw Exception("Registration failed.");
    }

    await firebaseUser.updateDisplayName(name);

    return await _getOrCreateUserDocument(
      firebaseUser,
    );
  }

  /// Logout
  Future<void> signOut() async {
    await _authService.signOut();
  }

  /// Create Firestore profile if it doesn't exist
  Future<UserModel> _getOrCreateUserDocument(
    auth.User firebaseUser,
  ) async {
    try {
      final users =
          await _firestoreService.getCollection<UserModel>(
        path: 'users',
        builder: (data, documentId) =>
            UserModel.fromMap(
          data,
          documentId,
        ),
      );

      final existingUser = users.where(
        (u) => u.id == firebaseUser.uid,
      );

      if (existingUser.isNotEmpty) {
        return existingUser.first;
      }

      final user = UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ??
            "Student",
        email: firebaseUser.email ?? "",
        profileImageUrl:
            firebaseUser.photoURL,
      );

      await _firestoreService.setDocument(
        path: "users/${firebaseUser.uid}",
        data: user.toMap(),
      );

      return user;
    } catch (e) {
      throw Exception(
        "Failed to load user profile: $e",
      );
    }
  }
}