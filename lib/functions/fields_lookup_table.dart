import 'dart:convert';
import '../constants.dart';

/// Hash table search to quickly find info related to a particular section of
/// the backend analysis. Uses the centralized JSON constant.
dynamic fieldsLookupTable(String key) {
  final Map<String, dynamic> table = json.decode(kFieldsLookupTableJson) as Map<String, dynamic>;

  return table.containsKey(key) ? table[key] : null;
}
