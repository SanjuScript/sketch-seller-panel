class ProductSizeModel {
  final double length;
  final double width;
  final double price;
  final double? offerPrice;

  ProductSizeModel({
    required this.length,
    required this.width,
    required this.price,
    this.offerPrice,
  });

  factory ProductSizeModel.fromJson(Map<String, dynamic> json) {
    return ProductSizeModel(
      length: (json['length'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      offerPrice: (json['offerPrice'] as num?)?.toDouble(),
    );
  }
  ProductSizeModel copyWith({
    double? length,
    double? width,
    double? price,
    double? offerPrice,
  }) {
    return ProductSizeModel(
      length: length ?? this.length,
      width: width ?? this.width,
      price: price ?? this.price,
      offerPrice: offerPrice ?? this.offerPrice,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'width': width,
      'price': price,
      'offerPrice': offerPrice,
    };
  }

  @override
  String toString() {
    return 'Size(length: $length, width: $width, price: $price, offerPrice: $offerPrice)';
  }
}
