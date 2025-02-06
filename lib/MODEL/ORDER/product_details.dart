
import 'package:drawer_panel/MODEL/ORDER/size_details.dart';

class ProductDetailsModel {
  ProductDetailsModel({
    required this.msg,
    required this.drawingType,
    required this.offerPrice,
    required this.artTypeId,
    required this.productId,
    required this.paidAmount,
    required this.size,
    required this.price,
    required this.productImage,
    required this.catName,
    required this.inOffer,
  });

  final String msg;
  static const String msgKey = "msg";

  final String drawingType;
  static const String drawingTypeKey = "drawingType";

  final num paidAmount;
  static const String paidAmountKey = "paidAmount";

  final num offerPrice;
  static const String offerPriceKey = "offerPrice";

  final String artTypeId;
  static const String artTypeIdKey = "artTypeID";

  final String productId;
  static const String productIdKey = "productID";

  final SizeModel? size;
  static const String sizeKey = "size";

  final num price;
  static const String priceKey = "price";

  final String productImage;
  static const String productImageKey = "product_image";

  final String catName;
  static const String catNameKey = "catName";

  final bool inOffer;
  static const String inOfferKey = "inOffer";

  ProductDetailsModel copyWith({
    String? msg,
    String? drawingType,
    num? offerPrice,
    String? artTypeId,
    String? productId,
    SizeModel? size,
    num? price,
    String? productImage,
    num? paidAmount,
    String? catName,
    bool? inOffer,
  }) {
    return ProductDetailsModel(
      msg: msg ?? this.msg,
      paidAmount: paidAmount ?? this.paidAmount,
      drawingType: drawingType ?? this.drawingType,
      offerPrice: offerPrice ?? this.offerPrice,
      artTypeId: artTypeId ?? this.artTypeId,
      productId: productId ?? this.productId,
      size: size ?? this.size,
      price: price ?? this.price,
      productImage: productImage ?? this.productImage,
      catName: catName ?? this.catName,
      inOffer: inOffer ?? this.inOffer,
    );
  }

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      msg: json["msg"] ?? "",
      paidAmount: json['paid_amount'] ?? '',
      drawingType: json["drawingType"] ?? "",
      offerPrice: json["offerPrice"] ?? 0,
      artTypeId: json["artTypeID"] ?? "",
      productId: json["productID"] ?? "",
      size: json["size"] == null ? null : SizeModel.fromJson(json["size"]),
      price: json["price"] ?? 0,
      productImage: json["product_image"] ?? "",
      catName: json["catName"] ?? "",
      inOffer: json["inOffer"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "drawingType": drawingType,
        "offerPrice": offerPrice,
        "paid_amount":paidAmount,
        "artTypeID": artTypeId,
        "productID": productId,
        "size": size?.toJson(),
        "price": price,
        "product_image": productImage,
        "catName": catName,
        "inOffer": inOffer,
      };

  @override
  String toString() {
    return "$msg, $drawingType, $offerPrice, $artTypeId, $productId, $size, $price, $productImage, $catName, $inOffer, ";
  }
}
