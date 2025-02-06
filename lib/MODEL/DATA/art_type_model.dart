import 'package:drawer_panel/MODEL/DATA/product_model.dart';

class ArtTypeModel {
  final String id;
  final String? name;
  final String? catName;
  final Product product;

  ArtTypeModel({
    required this.id,
    required this.name,
    this.catName,
    required this.product,
  });

  factory ArtTypeModel.fromJson(Map<String, dynamic> json) {
    return ArtTypeModel(
      id: json['id'],
      name: json['name'] ?? '',
      catName: json['catName'] ?? '',
      product: Product.fromJson(json['product'] as Map<String, dynamic>? ?? {}),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'catName':catName,
      'name': name,
      'product': product.toMap(),
    };
  }

  @override
  String toString() {
    return 'ArtType(id: $id, name: $name, product: $product)';
  }
}
