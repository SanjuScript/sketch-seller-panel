class ArtCategory {
  final String title;
  final String imagePath;

  ArtCategory({
    required this.title,
    required this.imagePath,
  });

  factory ArtCategory.fromMap(Map<String, String> map) {
    return ArtCategory(
      title: map['title']!,
      imagePath: map['img']!,
    );
  }

  Map<String, String> toMap() {
    return {
      'title': title,
      'img': imagePath,
    };
  }
}
