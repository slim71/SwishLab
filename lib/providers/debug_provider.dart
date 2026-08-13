import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebugState {
  final bool showPerformanceOverlay;

  const DebugState({
    this.showPerformanceOverlay = false,
  });

  DebugState copyWith({
    bool? showPerformanceOverlay,
  }) {
    return DebugState(
      showPerformanceOverlay: showPerformanceOverlay ?? this.showPerformanceOverlay,
    );
  }
}

class DebugNotifier extends Notifier<DebugState> {
  @override
  DebugState build() {
    return const DebugState();
  }

  void togglePerformanceOverlay() {
    state = state.copyWith(showPerformanceOverlay: !state.showPerformanceOverlay);
  }
}

final debugProvider = NotifierProvider<DebugNotifier, DebugState>(() => DebugNotifier());
