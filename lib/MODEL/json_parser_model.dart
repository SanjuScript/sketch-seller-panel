class JsonParser {
  static List<T> parseList<T>(
    List<dynamic>? data, 
    T Function(Map<String, dynamic>) fromJson
  ) {
    return data?.map((json) => fromJson(json as Map<String, dynamic>)).toList() ?? [];
  }
}