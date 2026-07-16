import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_providers.dart';
import '../state/app_state.dart';

/// A bridge between Riverpod state and GoRouter's refresh mechanism.
///
/// GoRouter relies on a [Listenable] to know when it should re-evaluate
/// its `redirect` logic. Since Riverpod providers are not Listenable,
/// this class adapts Riverpod state changes into ChangeNotifier updates.
///
/// It listens to [appStatusProvider] (which combines auth + connectivity)
/// and [appStateProvider] (for onboarding state)
/// and calls [notifyListeners] whenever either changes,
/// triggering a router refresh.
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(this.ref) {
    ref.listen<AppAuthStatus>(appStatusProvider, (_, __) {
      notifyListeners();
    });
    ref.listen<AppState>(appStateProvider, (prev, next) {
      if (prev?.hasOpenedBefore != next.hasOpenedBefore) {
        notifyListeners();
      }
    });
  }

  final Ref ref;
}

/// Provides a singleton instance of [RouterRefreshNotifier].
///
/// This is used by GoRouter as a `refreshListenable` to trigger
/// route re-evaluation whenever the app state changes.
///
/// This allows GoRouter to react to updates from Riverpod providers
/// without requiring manual navigation triggers.
final routerRefreshProvider = Provider<RouterRefreshNotifier>((ref) {
  return RouterRefreshNotifier(ref);
});
