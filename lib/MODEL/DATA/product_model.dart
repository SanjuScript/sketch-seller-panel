import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer_panel/MODEL/DATA/drawing_type_model.dart';
import 'package:drawer_panel/MODEL/DATA/product_size_model.dart';
import 'package:drawer_panel/MODEL/DATA/review_model.dart';
import 'package:drawer_panel/MODEL/json_parser_model.dart';

class Product {
  String? artist;
  String? productId;
  String? ownerID;
  String? description;
  String? title;
  List<DrawingTypeModel>? drawingTypes;
  Timestamp? createdAt;
  bool? isAvailable;
  num? revenue;
  bool? inOffer;
  List<ReviewModel>? reviews;
  int? totalReviewCount;
  List<String>? images;
  String? categoryId;
  String? offermsg;
  String? artTypeId;
  num? avgRating;
  int? totalOrders;

  Product({
    this.productId,
    this.ownerID,
    this.title,
    this.totalOrders,
    this.offermsg,
    this.avgRating,
    this.artTypeId,
    this.categoryId,
    this.drawingTypes,
    this.artist,
    this.description,
    this.revenue,
    this.createdAt,
    this.isAvailable,
    this.inOffer,
    this.reviews,
    this.totalReviewCount = 0,
    this.images,
  });

  static double getPrice(ProductSizeModel selectedSize) {
    return selectedSize.offerPrice ?? selectedSize.price;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    String ownerID = json['ownerID'] != null ? json['ownerID'] as String : '';
    String description =
        json['description'] != null ? json['description'] as String : '';
    return Product(
      productId: json['productId'] as String,
      offermsg: json['offermsg'] as String,
      avgRating: json['avgRating'] as num? ?? 0.0,
      revenue: json['revenue'] as num? ?? 0.0,
      ownerID: ownerID,
      totalOrders: json['totalOrders'] as int ?? 0,
      description: description,
      artist: json['artist'] as String,
      title: json['title'] as String?,
      artTypeId: json['artTypeId'] as String?,
      categoryId: json['categoryId'] as String?,
      drawingTypes: JsonParser.parseList(
        json['drawingTypes'],
        (data) => DrawingTypeModel.fromJson(data),
      ),
      createdAt: json['createdAt'] as Timestamp?,
      isAvailable: json['isAvailable'] as bool?,
      inOffer: json['inOffer'] as bool?,
      reviews: JsonParser.parseList(
        json['reviews'],
        (data) => ReviewModel.fromJson(data),
      ),
      totalReviewCount: json['totalReviewCount'] as int? ?? 0,
      images: (json['images'] as List<dynamic>?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'offermsg': offermsg,
      'avgRating': avgRating,
      'revenue': revenue,
      'ownerID': ownerID,
      'totalOrders': totalOrders,
      'description': description,
      'categoryId': categoryId,
      'artTypeId': artTypeId,
      'productId': productId,
      'drawingTypes': drawingTypes?.map((type) => type.toJson()).toList(),
      'createdAt': createdAt,
      'isAvailable': isAvailable,
      'inOffer': inOffer,
      'reviews': reviews?.map((review) => review.toJson()).toList(),
      'totalReviewCount': totalReviewCount,
      'images': images,
    };
  }

  @override
  String toString() {
    return 'Product(productId: $productId, title: $title, artist: $artist, drawingTypes: $drawingTypes, createdAt: $createdAt, isAvailable: $isAvailable, inOffer: $inOffer, reviews: $reviews, totalReviewCount: $totalReviewCount, images: $images description : $description ownerID : $ownerID';
  }
}
