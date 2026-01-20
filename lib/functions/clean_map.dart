/// Used to filter out null values from json maps
Map<String, dynamic> cleanMap(Map<String, dynamic> input) {
  return Map.fromEntries(
    input.entries.where((e) => e.value != null),
  );
}
