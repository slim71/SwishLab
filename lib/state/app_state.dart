import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logger.dart';
import '../models/credit_item.dart';
import '../models/user_row_data.dart';
import '../providers/shared_preferences_provider.dart';

class AppState {
  // Riverpod requires immutable states
  final bool hasOpenedBefore; //  Whether this is the first time the user opens up the app or not
  final bool userDataFetched; //  Whether the user data has been fetched or not
  final UserRowData? userData;
  final List<Credit> credits;
  final List<Map<String, dynamic>>?
      loadedFaqs; // Container to store FAQs loaded either from remote or from the default constant
  final bool sessionInitialized; // Flag to track whether the home page has been already shown or not before

  const AppState({
    this.hasOpenedBefore = false,
    this.userDataFetched = false,
    this.userData = const UserRowData(),
    this.credits = const [],
    this.loadedFaqs,
    this.sessionInitialized = false,
  });

  // Helper function to avoid having to rebuild all fields manually every time
  AppState copyWith({
    bool? hasOpenedBefore,
    bool? userDataFetched,
    UserRowData? userData,
    List<Credit>? credits,
    List<Map<String, dynamic>>? loadedFaqs,
    bool? sessionInitialized,
  }) {
    return AppState(
      hasOpenedBefore: hasOpenedBefore ?? this.hasOpenedBefore,
      userDataFetched: userDataFetched ?? this.userDataFetched,
      userData: userData ?? this.userData,
      credits: credits ?? this.credits,
      loadedFaqs: loadedFaqs ?? this.loadedFaqs,
      sessionInitialized: sessionInitialized ?? this.sessionInitialized,
    );
  }
}

// Riverpod notifier
class AppStateNotifier extends Notifier<AppState> {
  static const String _hasOpenedBeforeKey = 'hasOpenedBefore';
  final _logger = AppLogger.scope('AppStateNotifier');

  @override
  AppState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final hasOpenedBefore = prefs.getBool(_hasOpenedBeforeKey) ?? false;

    _logger.d('Building AppState. hasOpenedBefore=$hasOpenedBefore');

    return AppState(
      hasOpenedBefore: hasOpenedBefore,
    );
  }

  void setHasOpenedBefore(bool value) {
    _logger.i('Setting hasOpenedBefore to: $value');
    state = state.copyWith(hasOpenedBefore: value);
    ref.read(sharedPreferencesProvider).setBool(_hasOpenedBeforeKey, value);
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
    state = AppState(hasOpenedBefore: hasOpenedBefore);
  }
}

final appStateProvider = NotifierProvider<AppStateNotifier, AppState>(() => AppStateNotifier());
