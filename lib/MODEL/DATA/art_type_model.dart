
import 'package:drawer_panel/MODEL/DATA/product_model.dart';

class ArtType {
  final String id;
  final String name;
  final String description;
  final List<Product> products;

  ArtType({
    required this.id,
    required this.name,
    required this.description,
    this.products = const [],
  });

  factory ArtType.fromJson(String id, Map<String, dynamic> json, [List<Product>? products]) {
    return ArtType(
      id: id,
      name: json['name'] as String,
      description: json['description'] as String,
      products: products ?? [],
    );
  }
}
