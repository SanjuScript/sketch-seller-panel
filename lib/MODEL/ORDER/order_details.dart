import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer_panel/MODEL/ORDER/address_model.dart';
import 'package:drawer_panel/MODEL/ORDER/payment_model.dart';
import 'package:drawer_panel/MODEL/ORDER/product_details.dart';
import 'package:drawer_panel/MODEL/ORDER/tracking_details.dart';
import 'package:drawer_panel/MODEL/ORDER/transaction_model.dart';
import 'package:drawer_panel/MODEL/user_model.dart';

class OrderDetailModel {
  OrderDetailModel({
    required this.orderTime,
    required this.paymentModel,
    required this.transactionModel,
    required this.address,
    required this.orderId,
    required this.selectedImage,
    required this.ownerId,
    required this.userID,
    required this.productDetails,
    required this.adminToken,
    required this.userDetails,
    required this.tracking,
    required this.deliveryWithin,
    required this.problem,
    required this.status,
    required this.estimatedDelivery,
  });

  final DateTime? orderTime;
  static const String orderTimeKey = "orderTime";

  final AddressModel? address;
  static const String addressKey = "address";

  final String orderId;
  static const String orderIdKey = "orderID";

  final DateTime? estimatedDelivery;
  static const String estimatedDeliveryKey = "estimatedDelivery";

  final String adminToken;
  static const String adminTokenKey = "adminToken";

  final String userID;
  static const String userIDKey = "userID";

  final String problem;
  static const String problemKey = "problem";

  final int deliveryWithin;
  static const String deliveryWithinKey = "deliveryWithin";

  final String selectedImage;
  static const String selectedImageKey = "selectedImage";

  final String ownerId;
  static const String ownerIdKey = "ownerID";

  final ProductDetailsModel? productDetails;
  static const String productDetailsKey = "productDetails";

  final PaymentModel? paymentModel;
  static const String paymentModelKey = "paymentModel";

  final TransactionModel? transactionModel;
  static const String transactionModelKey = "transactionModel";

  final UserDataModel? userDetails;
  static const String userDetailsKey = "userDetails";

  final TrackingModel? tracking;
  static const String trackingKey = "tracking";

  final String status;
  static const String statusKey = "status";

  OrderDetailModel copyWith({
    DateTime? orderTime,
    AddressModel? address,
    String? orderId,
    String? problem,
    int? deliveryWithin,
    String? userID,
    DateTime? estimatedDelivery,
    String? selectedImage,
    String? ownerId,
    String? adminToken,
    ProductDetailsModel? productDetails,
    UserDataModel? userDetails,
    TrackingModel? tracking,
    PaymentModel? paymentModel,
    TransactionModel? transactionModel,
    String? status,
  }) {
    return OrderDetailModel(
      orderTime: orderTime ?? this.orderTime,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      address: address ?? this.address,
      adminToken: adminToken ?? this.adminToken,
      userID: userID ?? this.userID,
      orderId: orderId ?? this.orderId,
      problem: problem ?? this.problem,
      deliveryWithin: deliveryWithin ?? this.deliveryWithin,
      transactionModel: transactionModel ?? this.transactionModel,
      paymentModel: paymentModel ?? this.paymentModel,
      selectedImage: selectedImage ?? this.selectedImage,
      ownerId: ownerId ?? this.ownerId,
      productDetails: productDetails ?? this.productDetails,
      userDetails: userDetails ?? this.userDetails,
      tracking: tracking ?? this.tracking,
      status: status ?? this.status,
    );
  }

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      orderTime: json["orderTime"] != null
          ? (json["orderTime"] as Timestamp).toDate()
          : null,
      estimatedDelivery: json["estimated_delivery"] != null
          ? (json["estimated_delivery"] as Timestamp).toDate()
          : null,
      address: json["address"] == null
          ? null
          : AddressModel.fromMap(json["address"]),
      orderId: json["orderID"] ?? "",
      userID: json["userID"] ?? "",
      selectedImage: json["selectedImage"] ?? "",
      adminToken: json["adminToken"] ?? "",
      problem: json["problem"] ?? "",
      deliveryWithin: json['delivery_within'] ?? 0,
      ownerId: json["ownerID"] ?? "",
      productDetails: json["productDetails"] == null
          ? null
          : ProductDetailsModel.fromJson(json["productDetails"]),
      paymentModel: json['payment'] == null
          ? null
          : PaymentModel.fromJson(json['payment']),
      transactionModel: json['transaction'] == null
          ? null
          : TransactionModel.fromJson(json['transaction']),
      userDetails: json["userDetails"] == null
          ? null
          : UserDataModel.fromMap(json["userDetails"]),
      tracking: json["tracking"] == null
          ? null
          : TrackingModel.fromJson(json["tracking"]),
      status: json["status"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "orderTime": orderTime?.toIso8601String(),
        "address": address?.toMap(),
        "orderID": orderId,
        "userID": userID,
        "estimated_delivery":estimatedDelivery?.toIso8601String(),
        "problem":problem,
        "adminToken":adminToken,
        "delivery_within":deliveryWithin,
        "transaction": transactionModel!.toJson(),
        "payment": paymentModel!.toMap(),
        "selectedImage": selectedImage,
        "ownerID": ownerId,
        "productDetails": productDetails?.toJson(),
        "userDetails": userDetails?.toMap(),
        "tracking": tracking?.toJson(),
        "status": status,
      };

  @override
  String toString() {
    return "$orderTime, $address, $orderId, $selectedImage, $ownerId, $productDetails, $userDetails, $tracking, $status, ";
  }
}
