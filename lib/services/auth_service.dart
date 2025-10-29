import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// A service class to handle Firebase Authentication operations.
///
/// This class encapsulates the logic for various sign-in methods, signing out,
/// and provides a stream to listen for authentication state changes.
class AuthService {
  // Instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  /// Stream to listen for changes in the user's authentication state.
  ///
  /// You can use this stream in a StreamBuilder to automatically update the UI
  /// when a user logs in or out.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get the current user
  User? get currentUser => _auth.currentUser;

  /// Signs up a new user with the provided email and password.
  ///
  /// Returns the created [User] object on success, or `null` on failure.
  /// Errors are printed to the debug console.
  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // Use Firebase to create a new user with email and password
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Return the newly created user
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Using kDebugMode to ensure error messages are only printed in development
      if (kDebugMode) {
        print('Failed to sign up with error code: ${e.code}');
        print(e.message);
      }
      rethrow; // Rethrow to allow UI to handle the error
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      rethrow;
    }
  }

  /// Signs in an existing user with the provided email and password.
  ///
  /// Returns the signed-in [User] object on success, or `null` on failure.
  /// Errors are printed to the debug console.
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // Use Firebase to sign in the user
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Return the user object
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Failed to sign in with error code: ${e.code}');
        print(e.message);
      }
      rethrow; // Rethrow to allow UI to handle the error
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      rethrow;
    }
  }

  /// Signs in a user using their Google account.
  ///
  /// Triggers the Google Sign-In flow, and upon success, signs the user into
  /// Firebase with the obtained credentials. Returns the [User] object on
  /// success, or `null` on failure (e.g., if the user cancels the flow).
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If the user cancels the sign-in flow, googleUser will be null
      if (googleUser == null) {
        if (kDebugMode) {
          print('Google Sign-In was cancelled by user');
        }
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential for Firebase using OAuthCredential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Firebase Auth Exception: ${e.code} - ${e.message}');
      }
      rethrow; // Rethrow to allow UI to handle the error
    } catch (e) {
      if (kDebugMode) {
        print('An unexpected error occurred during Google Sign-In: $e');
      }
      rethrow;
    }
  }

  /// Signs out the currently authenticated user from Firebase and Google.
  Future<void> signOut() async {
    try {
      // Sign out from both Firebase and Google
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
      rethrow;
    }
  }

  /// Disconnect Google account (removes access completely)
  Future<void> disconnectGoogle() async {
    try {
      await _googleSignIn.disconnect();
    } catch (e) {
      if (kDebugMode) {
        print('Error disconnecting Google account: $e');
      }
      rethrow;
    }
  }
}
