import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/content_sync_service.dart';
import '../services/local_content_store.dart';
import 'firestore_provider.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('SharedPreferences must be overridden.'),
);

final localContentStoreProvider = Provider<LocalContentStore>((ref) {
  final preferences = ref.watch(sharedPreferencesProvider);
  return LocalContentStore(
    preferences: preferences,
    bundle: rootBundle,
  );
});

final contentSyncServiceProvider = Provider<ContentSyncService>((ref) {
  final localStore = ref.watch(localContentStoreProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);
  return ContentSyncService(
    localStore: localStore,
    firestoreService: firestoreService,
  );
});

final contentRevisionProvider = StateProvider<int>((ref) => 0);

final storiesVersionProvider = Provider<String>((ref) {
  ref.watch(contentRevisionProvider);
  return ref.watch(localContentStoreProvider).getStoriesVersion() ?? 'v1.0.0';
});

final charactersVersionProvider = Provider<String>((ref) {
  ref.watch(contentRevisionProvider);
  return ref.watch(localContentStoreProvider).getCharactersVersion() ?? 'v1.0.0';
});

class ContentRefreshResult {
  const ContentRefreshResult({required this.updated});

  final bool updated;
}

class ContentController {
  const ContentController(this._ref);

  final Ref _ref;

  Future<ContentRefreshResult> refresh({bool force = false}) async {
    try {
      final updated = await _ref.read(contentSyncServiceProvider).syncIfNeeded(
            force: force,
          );
      if (updated) {
        _ref.read(contentRevisionProvider.notifier).state++;
      }
      return ContentRefreshResult(updated: updated);
    } catch (_) {
      return const ContentRefreshResult(updated: false);
    }
  }
}

final contentControllerProvider = Provider<ContentController>((ref) {
  return ContentController(ref);
});

final contentBootstrapProvider = FutureProvider<void>((ref) async {
  await ref.watch(contentSyncServiceProvider).ensureInitialized();
  unawaited(ref.read(contentControllerProvider).refresh());
});
