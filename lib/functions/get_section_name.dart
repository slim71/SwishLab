/// Extract the name of a section from the results JSON, converting from snake
/// case to normal case (first letter uppercase, space-divided words)
String getSectionName(String section) {
  final words = section.split('_').map((w) => w.toLowerCase()).toList();
  if (words.isEmpty) return "";
  final firstWord = words.first[0].toUpperCase() + words.first.substring(1);
  final rest = words.sublist(1).join(' ');
  return "$firstWord${rest.isNotEmpty ? ' $rest' : ''}";
}
