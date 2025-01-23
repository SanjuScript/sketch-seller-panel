import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer_panel/API/auth_api.dart';
import 'package:drawer_panel/MODEL/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserData {
  static final uid = AuthApi.auth.currentUser!.uid;
  static Stream<UserDataModel?> getUserData() {
    try {
      return FirebaseFirestore.instance
          .collection('admins')
          .doc(uid)
          .snapshots()
          .map((docSnapshot) {
        if (docSnapshot.exists) {
          return UserDataModel.fromMap(
              docSnapshot.data() as Map<String, dynamic>);
        } else {
          return null;
        }
      });
    } catch (e) {
      log("Error fetching user data: $e");
      return Stream.value(null);
    }
  }

  static Future<void> updateUserName(String newName) async {
    final uid = AuthApi.auth.currentUser!.uid;

    if (newName.isEmpty) {
      log("New name cannot be empty.");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('admins').doc(uid).update({
        'fullName': newName,
      });

      log("Name updated successfully.");
    } catch (e) {
      log("Error updating name: $e");
    }
  }

  static Future<void> storeNotificationToken(String token) async {
    try {
      User? currentUser = AuthApi.auth.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('admins').doc(userId);

        await userDocRef.set({'nfToken': token}, SetOptions(merge: true));
      } else {
        log("User is not authenticated.");
      }
    } catch (e) {
      log('Error storing notification token: $e');
    }
  }

  static Future<void> updateProfilePicture(String filePath) async {
    final uid = AuthApi.auth.currentUser!.uid;

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final oldProfilePicRef =
          storageRef.child('profile_pictures/$uid/profile.jpg');

      try {
        await oldProfilePicRef.delete();
        log("Old profile picture deleted.");
      } catch (e) {
        log("No old profile picture to delete or error deleting: $e");
      }

      final newProfilePicRef =
          storageRef.child('profile_pictures/$uid/profile.jpg');
      final uploadTask = newProfilePicRef.putFile(File(filePath));
      final snapshot = await uploadTask.whenComplete(() => null);

      final downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('admins').doc(uid).update({
        'profile': downloadUrl,
      });

      log("Profile picture updated successfully.");
    } catch (e) {
      log("Error updating profile picture: $e");
    }
  }
}
