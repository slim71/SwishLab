/// Regex matching function for some string field
bool isFieldValid(
  String field,
  String pattern,
) {
  final regex = RegExp(pattern);
  return regex.hasMatch(field);
}
