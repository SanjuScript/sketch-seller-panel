import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? productId;
  String? title;
  double? price;
  List<String>? imageUrl; 
  double? offerPrice; 
  Timestamp? createdAt;
  bool? isAvailable;
  bool? inOffer;

  Product({
    this.productId,
    this.title,
    this.price,
    this.imageUrl,
    this.offerPrice,
    this.createdAt,
    this.isAvailable,
    this.inOffer,
  });

  factory Product.fromDocument(DocumentSnapshot doc) {
    return Product(
      productId: doc.id,
      title: doc['title'] as String?,
      price: (doc['price'] as num?)?.toDouble(),
      imageUrl: (doc['imageUrl'] as List<dynamic>?)?.cast<String>(),
      offerPrice: (doc['offerPrice'] as num?)?.toDouble(),
      createdAt: doc['createdAt'] as Timestamp?,
      isAvailable: doc['isAvailable'] as bool?,
      inOffer: doc['inOffer'] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'offerPrice': offerPrice,
      'createdAt': createdAt,
      'isAvailable': isAvailable,
      'inOffer': inOffer,
    };
  }
}
