import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthApi {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static User? get currentAdmin => auth.currentUser;
  static bool get isAuthenticated => currentAdmin != null;

  static CollectionReference admins =
      FirebaseFirestore.instance.collection('admins');

  static CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  static CollectionReference catogories =
      FirebaseFirestore.instance.collection('catogories');

  static DocumentReference get currentAdminDoc {
    if (!isAuthenticated) {
      throw FirebaseAuthException(
          code: 'no-current-user', message: 'No authenticated user found.');
    }
    return admins.doc(currentAdmin!.uid);
  }

  static CollectionReference get orders {
    if (!isAuthenticated) {
      throw FirebaseAuthException(
          code: 'no-current-user', message: 'No authenticated user found.');
    }
    return FirebaseFirestore.instance.collection('Orders');
  }
  static CollectionReference get reviews {
    if (!isAuthenticated) {
      throw FirebaseAuthException(
          code: 'no-current-user', message: 'No authenticated user found.');
    }
    return FirebaseFirestore.instance.collection('Reviews');
  }



  static final FirebaseStorage storage = FirebaseStorage.instance;
  static DocumentReference documentRef = FirebaseFirestore.instance
      .collection('admins')
      .doc(auth.currentUser!.uid);
}
