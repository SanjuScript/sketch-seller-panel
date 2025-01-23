import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  final String? fullName;
  final String? profile;
  final String? email;
  final String? uid;
  final Timestamp? createdAt;
  final int? totalOders;
  final int? earning;
  final int? pending;
  final String? nfToken;

  UserDataModel({
    this.fullName,
    this.email,
    this.earning,
    this.pending,
    this.profile,
    this.totalOders,
    this.nfToken,
    this.uid,
    this.createdAt,
  });

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    return UserDataModel(
      fullName: map['fullName'],
      email: map['email'],
      nfToken: map['nfToken'],
      profile: map['profile'],
      pending: map['pending'],
      earning: map['total_earned'],
      totalOders: map['total_deliveries'],
      uid: map['uid'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'pending':pending,
      'total_earned': earning,
      'email': email,
      'nfToken':nfToken,
      'uid': uid,
      'total_deliveries':totalOders,
      'profile': profile,
      'createdAt': createdAt,
    };
  }
}
