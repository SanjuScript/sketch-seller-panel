import 'package:drawer_panel/MODEL/DATA/art_type_model.dart';

class Category {
  final String id;
  final String name;
  final String description;
  final List<ArtType> types;

  Category({
    required this.id,
    required this.name,
    required this.description,
    this.types = const [],
  });

  factory Category.fromJson(String id, Map<String, dynamic> json,
      [List<ArtType>? types]) {
    return Category(
      id: id,
      name: json['name'] as String,
      description: json['description'] as String,
      types: types ?? [],
    );
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