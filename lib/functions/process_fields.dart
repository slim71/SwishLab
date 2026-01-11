import 'package:SwishLab/functions/fields_lookup_table.dart';
import 'package:SwishLab/functions/get_section_name.dart';

/// Process the main subsection of the results JSON to extract relevant info
List<dynamic> processFields(dynamic data) {
  return data.entries.where((entry) => entry.key != "scores").map((entry) {
    final key = entry.key;
    final value = entry.value;
    final meta = fieldsLookupTable(key);

    if (value is Map<String, dynamic>) {
      return {
        "name": getSectionName(key),
        "value": processFields(value),
      };
    } else {
      final field = {
        "name": getSectionName(key),
        "value": value,
      };
      if (meta != null) {
        field["unit"] = meta["unit"];
        if (meta.containsKey("range")) {
          field["range"] = "[${meta["range"]["min"]}-${meta["range"]["max"]}]";
        }
      }
      return field;
    }
  }).toList();
}
