import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logger.dart';
import 'shared_preferences_provider.dart';

class DebugState {
  final bool showPerformanceOverlay;
  final bool isDeveloperModeEnabled;

  const DebugState({
    required this.showPerformanceOverlay,
    required this.isDeveloperModeEnabled,
  });

  DebugState copyWith({
    bool? showPerformanceOverlay,
    bool? isDeveloperModeEnabled,
  }) {
    return DebugState(
      showPerformanceOverlay: showPerformanceOverlay ?? this.showPerformanceOverlay,
      isDeveloperModeEnabled: isDeveloperModeEnabled ?? this.isDeveloperModeEnabled,
    );
  }
}

class DebugNotifier extends Notifier<DebugState> {
  static const String _devModeKey = 'isDeveloperModeEnabled';
  final _logger = AppLogger.scope('DebugNotifier');

  @override
  DebugState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final isDev = prefs.getBool(_devModeKey) ?? false;

    _logger.d('Building DebugState. Source: SharedPreferences, Value: $isDev');

    return DebugState(
      showPerformanceOverlay: false,
      isDeveloperModeEnabled: isDev,
    );
  }

  void togglePerformanceOverlay() {
    state = state.copyWith(showPerformanceOverlay: !state.showPerformanceOverlay);
  }

  void setDeveloperMode(bool enabled) {
    _logger.i('Setting Developer Mode to: $enabled');
    state = state.copyWith(isDeveloperModeEnabled: enabled);
    ref.read(sharedPreferencesProvider).setBool(_devModeKey, enabled);
  }

  Future<void> reset() async {
    _logger.w('Resetting DebugState. Clearing SharedPreferences key: $_devModeKey');
    await ref.read(sharedPreferencesProvider).setBool(_devModeKey, false);
    state = const DebugState(
      showPerformanceOverlay: false,
      isDeveloperModeEnabled: false,
    );
  }
}

final debugProvider = NotifierProvider<DebugNotifier, DebugState>(() => DebugNotifier());
