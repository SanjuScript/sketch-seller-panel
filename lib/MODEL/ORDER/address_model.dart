import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String? name;
  final String? phone;
  final String? alternatePhone;
  final String? house;
  final String? road;
  final String? addressID;
  final String? landmark;
  final String? pin;
  final String? city;
  final String? state;
  final String? addressType;
  final String? userID;
  final Timestamp? createdAt;
  final Timestamp? lastEditedOn;

  AddressModel({
    this.name,
    this.lastEditedOn,
    this.phone,
    this.alternatePhone,
    this.addressID,
    this.house,
    this.road,
    this.landmark,
    this.pin,
    this.city,
    this.state,
    this.addressType,
    this.userID,
    this.createdAt,
  });

  factory AddressModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AddressModel(
      name: data['name'],
      phone: data['phone'],
      alternatePhone: data['alternatePhone'],
      house: data['house'],
      road: data['road'],
      addressID: data['addressID'],
      landmark: data['landmark'],
      pin: data['pin'],
      city: data['city'],
      state: data['state'],
      addressType: data['addressType'],
      userID: data['userID'],
      createdAt: data['created_at'],
      lastEditedOn: data['last_edited_on'],
    );
  }
  factory AddressModel.fromMap(Map<String, dynamic> data) {
    return AddressModel(
      name: data['name'],
      phone: data['phone'],
      alternatePhone: data['alternatePhone'],
      house: data['house'],
      road: data['road'],
      addressID: data['addressID'],
      landmark: data['landmark'],
      pin: data['pin'],
      city: data['city'],
      state: data['state'],
      addressType: data['addressType'],
      userID: data['userID'],
      createdAt: data['created_at'],
      lastEditedOn: data['last_edited_on'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "addressID": addressID,
      "phone": phone,
      "alternatePhone": alternatePhone,
      "house": house,
      "road": road,
      "landmark": landmark,
      "pin": pin,
      "city": city,
      "state": state,
      "addressType": addressType,
      "userID": userID,
      "created_at": createdAt,
    };
  }
}
