import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

enum AuthStatus { uninitialized, authenticated, authenticating, unauthenticated }

class SignupViewModel with ChangeNotifier {
  final AuthRepository _authRepository;

  AuthStatus _status = AuthStatus.uninitialized;
  User? _user;
  String? _errorMessage;

  SignupViewModel(this._authRepository) {
    _authRepository.authStateChanges.listen((User? user) {
      if (user == null) {
        _status = AuthStatus.unauthenticated;
      } else {
        _user = user;
        _status = AuthStatus.authenticated;
      }
      notifyListeners();
    });
  }

  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authRepository.signUpWithEmailAndPassword(email, password);
      _status = AuthStatus.authenticated;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _errorMessage = 'An unknown error occurred.';
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authRepository.signInWithGoogle();
      _status = AuthStatus.authenticated;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _errorMessage = 'An unknown error occurred.';
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }
}
