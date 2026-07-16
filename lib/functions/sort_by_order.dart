import '../logger.dart';

final sortLogger = AppLogger.scope('Credits');

/// Sort a JSON list through the "order" field
List<dynamic> sortByOrder(List<dynamic> list) {
  // Make a copy so original is not modified
  final sorted = [...list];

  sorted.sort((a, b) {
    final orderA = (a is Map && a['order'] is num) ? a['order'] as num : 0;
    final orderB = (b is Map && b['order'] is num) ? b['order'] as num : 0;
    return orderA.compareTo(orderB);
  });

  return sorted;
}
