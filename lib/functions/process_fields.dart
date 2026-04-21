import 'fields_lookup_table.dart';
import 'get_section_name.dart';

/// Process the main subsection of the results JSON to extract relevant info
List<dynamic> processFields(Map<String, dynamic> data) {
  return data.entries.where((entry) => entry.key != "scores").map((entry) {
    final key = entry.key;
    final value = entry.value;
    final dynamic meta = fieldsLookupTable(key);

    if (value is Map<String, dynamic>) {
      return {
        "name": getSectionName(key),
        "value": processFields(value),
      };
    } else {
      final Map<String, dynamic> field = {
        "name": getSectionName(key),
        "value": value,
      };
      if (meta is Map<String, dynamic>) {
        field["unit"] = meta["unit"];
        if (meta.containsKey("range")) {
          final range = meta["range"] as Map<String, dynamic>;
          field["range"] = "[${range["min"]}-${range["max"]}]";
        }
      }
      return field;
    }
  }).toList();
}
