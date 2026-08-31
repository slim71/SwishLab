import 'dart:convert';
import '../constants.dart';

Map<String, dynamic>? _cachedTable;

/// Hash table search to quickly find info related to a particular section of
/// the backend analysis. Uses the centralized JSON constant.
dynamic fieldsLookupTable(String key) {
  _cachedTable ??= json.decode(kFieldsLookupTableJson) as Map<String, dynamic>;

  return _cachedTable![key];
}
