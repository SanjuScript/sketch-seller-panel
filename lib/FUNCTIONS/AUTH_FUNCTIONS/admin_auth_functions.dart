import 'dart:developer';
import 'package:drawer_panel/HELPERS/custom_toast.dart';
import 'package:drawer_panel/ROUTER/page_routers.dart';
import 'package:drawer_panel/SERVICES/notification_service.dart';
import 'package:drawer_panel/STORAGE/app_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toastification/toastification.dart';

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
      log("New Login");
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
          'total_deliveries': 0,
          'pending': 0
        });
      }

      ShowCustomToast.showToast(
        context: context,
        msg: "Google sign-up successful!",
        type: ToastificationType.success,
      );
      return "Google sign-up successful!";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        ShowCustomToast.showToast(
            context: context,
            msg: "Account exists with a different credential.",
            type: ToastificationType.error,
            icon: Icon(
              Icons.error,
              color: Colors.red[300],
            ));
        return "Account exists with a different credential.";
      } else if (e.code == 'invalid-credential') {
        ShowCustomToast.showToast(
            context: context,
            msg: "Invalid credential.",
            type: ToastificationType.error,
            icon: Icon(
              Icons.error,
              color: Colors.red[300],
            ));
        return "Invalid credential.";
      } else {
        return e.message ?? "An error occurred during Google login.";
      }
    } catch (e) {
      log(e.toString());
      ShowCustomToast.showToast(
          context: context,
          msg: "An unknown error occurred. Please try again.",
          type: ToastificationType.error,
          icon: Icon(
            Icons.error,
            color: Colors.red[300],
          ));
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
        ShowCustomToast.showToast(
          context: context,
          msg: "Logged out successfully!",
          type: ToastificationType.success,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ShowCustomToast.showToast(
          context: context,
          msg: "An error occurred during logout. Please try again.",
          type: ToastificationType.error,
        );
      }
    }
  }
}
