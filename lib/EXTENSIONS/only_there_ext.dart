extension StringCheck on String {
  String isOnly(String word) {
    return trim().toLowerCase() == word.toLowerCase() ? '' : this;
  }
}
