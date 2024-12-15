import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _storage = GetStorage();

  Future<UserCredential?> loginWithGoogle() async {
    try {
      // Trigger the Google Sign-In process
      final googleUser = await GoogleSignIn().signIn();

      // Check if the user canceled the sign-in
      if (googleUser == null) {
        log("Google Sign-In a user.");
        return null;
      }

      // Get the authentication details from the Google Sign-In process
      final googleAuth = await googleUser.authentication;

      // Create a credential from the Google Sign-In details
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Use the credential to sign in with Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        log("Firebase user successfully signed in:");
        log("Username: ${user.displayName ?? "No display name"}");
        log("User Email: ${user.email ?? "No email provided"}");

        // Save user name and email to GetStorage
        _storage.write('username', user.displayName ?? "No display name");
        _storage.write('useremail', user.email ?? "No email provided");

        log("User data saved.");
      }

      return userCredential;
    } catch (e) {
      log("Error d: $e");
      return null;
    }
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Error");
    }
    return null;
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut(); // Sign out from Google

      // Clear user data from GetStorage
      _storage.remove('username');
      _storage.remove('useremail');
      log("User data cleared from GetStorage and signed out successfully.");
    } catch (e) {
      log("Error during signout: $e");
    }
  }
}
