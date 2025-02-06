class SizeModel {
    SizeModel({
        required this.height,
        required this.width,
    });

    final num height;
    static const String heightKey = "height";
    
    final num width;
    static const String widthKey = "width";
    

    SizeModel copyWith({
        num? height,
        num? width,
    }) {
        return SizeModel(
            height: height ?? this.height,
            width: width ?? this.width,
        );
    }

    factory SizeModel.fromJson(Map<String, dynamic> json){ 
        return SizeModel(
            height: json["height"] ?? 0,
            width: json["width"] ?? 0,
        );
    }

    Map<String, dynamic> toJson() => {
        "height": height,
        "width": width,
    };

    @override
    String toString(){
        return "$height, $width, ";
    }
}
