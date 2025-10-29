import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  User? get currentUser => _authService.currentUser;

  Future<User?> signUpWithEmailAndPassword(String email, String password) {
    return _authService.signUpWithEmailAndPassword(email, password);
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) {
    return _authService.signInWithEmailAndPassword(email, password);
  }

  Future<void> signOut() {
    return _authService.signOut();
  }

  Future<User?> signInWithGoogle() {
    return _authService.signInWithGoogle();
  }
}
