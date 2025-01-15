import 'package:drawer_panel/MODEL/DATA/product_size_model.dart';
import 'package:drawer_panel/MODEL/json_parser_model.dart';

class DrawingTypeModel {
  String? type;
  List<ProductSizeModel>? sizes;

  DrawingTypeModel({
    this.type,
    this.sizes,
  });

  factory DrawingTypeModel.fromJson(Map<String, dynamic> json) {
    return DrawingTypeModel(
      type: json['type'] as String?,
      sizes: JsonParser.parseList(
          json['sizes'], (data) => ProductSizeModel.fromJson(data)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'sizes': sizes?.map((size) => size.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'DrawingType(type: $type, sizes: $sizes)';
  }
}
