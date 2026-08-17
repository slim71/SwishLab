import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logger.dart';
import '../models/credit_item.dart';
import '../models/user_row_data.dart';
import '../providers/shared_preferences_provider.dart';

class AppState {
  final bool hasOpenedBefore;
  final bool userDataFetched;
  final UserRowData? userData;
  final List<Credit> credits;
  final List<Map<String, dynamic>>? loadedFaqs;
  final bool sessionInitialized;
  final bool showRadarChart;

  const AppState({
    this.hasOpenedBefore = false,
    this.userDataFetched = false,
    this.userData = const UserRowData(),
    this.credits = const [],
    this.loadedFaqs,
    this.sessionInitialized = false,
    this.showRadarChart = true,
  });

  AppState copyWith({
    bool? hasOpenedBefore,
    bool? userDataFetched,
    UserRowData? userData,
    List<Credit>? credits,
    List<Map<String, dynamic>>? loadedFaqs,
    bool? sessionInitialized,
    bool? showRadarChart,
  }) {
    return AppState(
      hasOpenedBefore: hasOpenedBefore ?? this.hasOpenedBefore,
      userDataFetched: userDataFetched ?? this.userDataFetched,
      userData: userData ?? this.userData,
      credits: credits ?? this.credits,
      loadedFaqs: loadedFaqs ?? this.loadedFaqs,
      sessionInitialized: sessionInitialized ?? this.sessionInitialized,
      showRadarChart: showRadarChart ?? this.showRadarChart,
    );
  }
}

class AppStateNotifier extends Notifier<AppState> {
  static const String _hasOpenedBeforeKey = 'hasOpenedBefore';
  static const String _showRadarChartKey = 'showRadarChart';
  final _logger = AppLogger.scope('AppStateNotifier');

  @override
  AppState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final hasOpenedBefore = prefs.getBool(_hasOpenedBeforeKey) ?? false;
    final showRadar = prefs.getBool(_showRadarChartKey) ?? true;

    _logger.d('Building AppState. hasOpenedBefore=$hasOpenedBefore, showRadar=$showRadar');

    return AppState(
      hasOpenedBefore: hasOpenedBefore,
      showRadarChart: showRadar,
    );
  }

  void setHasOpenedBefore(bool value) {
    _logger.i('Setting hasOpenedBefore to: $value');
    state = state.copyWith(hasOpenedBefore: value);
    ref.read(sharedPreferencesProvider).setBool(_hasOpenedBeforeKey, value);
  }

  void setShowRadarChart(bool value) {
    _logger.i('Setting showRadarChart to: $value');
    state = state.copyWith(showRadarChart: value);
    ref.read(sharedPreferencesProvider).setBool(_showRadarChartKey, value);
  }

  void setUserDataFetched(bool value) {
    state = state.copyWith(userDataFetched: value);
  }

  void setUserData(UserRowData data) {
    state = state.copyWith(userData: data, userDataFetched: true);
  }

  void setCredits(List<Credit> credits) {
    state = state.copyWith(credits: credits);
  }

  void setLoadedFaqs(List<Map<String, dynamic>> faqs) {
    state = state.copyWith(loadedFaqs: faqs);
  }

  void setSessionInitialized(bool value) {
    state = state.copyWith(sessionInitialized: value);
  }

  void reset() {
    final prefs = ref.read(sharedPreferencesProvider);
    final hasOpenedBefore = prefs.getBool(_hasOpenedBeforeKey) ?? false;
    _logger.w('Resetting AppState. Preserving hasOpenedBefore=$hasOpenedBefore');
    state = AppState(
      hasOpenedBefore: hasOpenedBefore,
      showRadarChart: true, // Explicitly provide default on reset
    );
  }
}

final appStateProvider = NotifierProvider<AppStateNotifier, AppState>(() => AppStateNotifier());
