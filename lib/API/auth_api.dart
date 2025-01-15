  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

  class AuthApi {
    static final FirebaseAuth auth = FirebaseAuth.instance;
    static CollectionReference admins =
        FirebaseFirestore.instance.collection('admins');
        static CollectionReference catogories =
        FirebaseFirestore.instance.collection('catogories');
        static final FirebaseStorage storage = FirebaseStorage.instance;
    static DocumentReference documentRef = FirebaseFirestore.instance
        .collection('admins')
        .doc(auth.currentUser!.uid);
  }
