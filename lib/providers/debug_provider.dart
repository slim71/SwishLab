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
    // Session-only: do not read from SharedPreferences on build
    _logger.d('Building DebugState. Resetting to defaults (Session-only).');

    return const DebugState(
      showPerformanceOverlay: false,
      isDeveloperModeEnabled: false,
    );
  }

  void togglePerformanceOverlay() {
    state = state.copyWith(showPerformanceOverlay: !state.showPerformanceOverlay);
  }

  void setDeveloperMode(bool enabled) {
    _logger.i('Setting Developer Mode to: $enabled (Session-only)');
    state = state.copyWith(isDeveloperModeEnabled: enabled);
    // Session-only: removed SharedPreferences write
  }

  Future<void> reset() async {
    _logger.w('Resetting DebugState.');
    // Keep clearing pref just in case old persisted values exist
    await ref.read(sharedPreferencesProvider).setBool(_devModeKey, false);
    state = const DebugState(
      showPerformanceOverlay: false,
      isDeveloperModeEnabled: false,
    );
  }
}

final debugProvider = NotifierProvider<DebugNotifier, DebugState>(() => DebugNotifier());
