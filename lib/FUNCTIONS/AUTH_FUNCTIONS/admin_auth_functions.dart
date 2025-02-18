import 'dart:developer';
import 'package:drawer_panel/HELPERS/CONSTANTS/show_toast.dart';
import 'package:drawer_panel/ROUTER/page_routers.dart';
import 'package:drawer_panel/SERVICES/notification_service.dart';
import 'package:drawer_panel/STORAGE/app_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationFn {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<String> googleLogin({required BuildContext context}) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return "Google Sign-In cancelled by the user.";
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // if (userCredential.additionalUserInfo?.isNewUser ?? false) {

      var adminDoc = await _firestore
          .collection('admins')
          .doc(userCredential.user?.uid)
          .get();

      if (adminDoc.exists) {
        log("User is an existing admin.");
      } else {
        await _firestore
            .collection('admins')
            .doc(userCredential.user?.uid)
            .set({
          'fullName': userCredential.user?.displayName,
          'email': userCredential.user?.email,
          'uid': userCredential.user?.uid,
          'profile': userCredential.user?.photoURL,
          'createdAt': Timestamp.now(),
          'total_earned': 0,
        });
      }
      showToast("Google sign-up successful!");
      return "Google sign-up successful!";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        showToast("Account exists with a different credential.");
        return "Account exists with a different credential.";
      } else if (e.code == 'invalid-credential') {
        showToast("Invalid credential.");

        return "Invalid credential.";
      } else {
        return e.message ?? "An error occurred during Google login.";
      }
    } catch (e) {
      log(e.toString());
      showToast("An unknown error occurred. Please try again.");
      return "An unknown error occurred. Please try again.";
    }
  }

  static Future<void> logout(BuildContext context) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        for (var provider in user.providerData) {
          if (provider.providerId == 'google.com') {
            await _googleSignIn.signOut();
            break;
          }
        }
      }

      await _auth.signOut();
      await PerfectStateManager.saveState('isAuthenticated', false);
      await PerfectStateManager.remove('isAuthenticated');
      isAuthenticatedNotifier.value = false;

      await NotificationService.showLogoutNotification(
        title: "Logged Out",
        body: "You have been logged out of your account.",
        payload: "logout_event",
      );

      if (context.mounted) {
        showToast("Logged out successfully!");
      }
    } catch (e) {
      if (context.mounted) {
        showToast("An unknown error occurred. Please try again.");
      }
    }
  }
}
