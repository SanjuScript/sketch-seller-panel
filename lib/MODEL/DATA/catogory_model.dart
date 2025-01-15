import 'package:drawer_panel/MODEL/DATA/art_type_model.dart';

class CategoryModel {
  final String id;
  final String? name;
  final List<ArtTypeModel> types;

  CategoryModel({
    required this.id,
    required this.name,
    this.types = const [],
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    var typesJson = json['types'] as List<dynamic>? ?? [];
    List<ArtTypeModel> typesList = typesJson.map((typeJson) {
      return ArtTypeModel.fromJson(typeJson as Map<String, dynamic>);
    }).toList();
     String categoryName = json['name'] != null ? json['name'] as String : '';
    return CategoryModel(
        id: json['id'] ?? '',
        name: categoryName,
        types: typesList);
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'types': types.map((type) => type.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name, types: $types)';
  }
}

// Future<List<Category>> fetchCategories() async {
//   final categoriesSnapshot = await FirebaseFirestore.instance.collection('categories').get();
//   return Future.wait(categoriesSnapshot.docs.map((doc) async {
//     final typesSnapshot = await doc.reference.collection('types').get();
//     final types = typesSnapshot.docs.map((typeDoc) {
//       return Type.fromJson(typeDoc.id, typeDoc.data());
//     }).toList();
//     return Category.fromJson(doc.id, doc.data(), types);
//   }).toList());
// }

// Fetch Products for a Type

// Future<List<Product>> fetchProducts(String categoryId, String typeId) async {
//   final productsSnapshot = await FirebaseFirestore.instance
//       .collection('categories')
//       .doc(categoryId)
//       .collection('types')
//       .doc(typeId)
//       .collection('products')
//       .get();

//   return productsSnapshot.docs.map((doc) {
//     return Product.fromJson(doc.id, doc.data());
//   }).toList();
// }