import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (_) {
      throw Exception(
        'An unexpected error occurred during login.',
      );
    }
  }

  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (_) {
      throw Exception(
        'An unexpected error occurred during registration.',
      );
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _handleAuthException(
    FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';

      case 'wrong-password':
        return 'Wrong password provided.';

      case 'invalid-email':
        return 'Invalid email address.';

      case 'email-already-in-use':
        return 'Email already exists.';

      case 'weak-password':
        return 'Password is too weak.';

      case 'user-disabled':
        return 'User account has been disabled.';

      default:
        return e.message ??
            'Authentication failed.';
    }
  }
}