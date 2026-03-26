import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/bookmark_service.dart';
import '../services/remote_bookmark_service.dart';
import 'auth_provider.dart';

final bookmarkServiceProvider = Provider<BookmarkService>((ref) {
  return BookmarkService();
});

final remoteBookmarkServiceProvider = Provider<RemoteBookmarkService>((ref) {
  return RemoteBookmarkService();
});

final bookmarksProvider = StateNotifierProvider<BookmarkNotifier, Set<String>>((ref) {
  final localService = ref.watch(bookmarkServiceProvider);
  final remoteService = ref.watch(remoteBookmarkServiceProvider);
  final notifier = BookmarkNotifier(
    ref: ref,
    localService: localService,
    remoteService: remoteService,
  );

  ref.listen(currentUserProvider, (_, nextUser) {
    notifier.handleUserChanged(nextUser?.uid);
  });

  return notifier;
});

class BookmarkNotifier extends StateNotifier<Set<String>> {
  BookmarkNotifier({
    required Ref ref,
    required BookmarkService localService,
    required RemoteBookmarkService remoteService,
  })  : _ref = ref,
        _localService = localService,
        _remoteService = remoteService,
        super(<String>{}) {
    _load();
  }

  final Ref _ref;
  final BookmarkService _localService;
  final RemoteBookmarkService _remoteService;

  String? _uid;
  bool _isSyncing = false;

  Future<void> _load() async {
    final localBookmarks = await _localService.loadBookmarks();
    state = localBookmarks;
    final uid = _ref.read(currentUserProvider)?.uid;
    if (uid != null) {
      await handleUserChanged(uid);
    }
  }

  Future<void> handleUserChanged(String? uid) async {
    _uid = uid;
    if (_isSyncing || uid == null) {
      return;
    }

    _isSyncing = true;
    try {
      final localBookmarks = await _localService.loadBookmarks();
      final remoteBookmarks = await _remoteService.getBookmarks(uid);
      final mergedBookmarks = {...localBookmarks, ...remoteBookmarks};

      if (mergedBookmarks.isNotEmpty && mergedBookmarks.length != remoteBookmarks.length) {
        await _remoteService.replaceBookmarks(uid: uid, storyIds: mergedBookmarks);
      }

      state = mergedBookmarks;
      await _localService.saveBookmarks(mergedBookmarks);
    } catch (_) {
      state = await _localService.loadBookmarks();
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> toggle(String storyId) async {
    final updated = {...state};
    final wasBookmarked = updated.contains(storyId);

    if (wasBookmarked) {
      updated.remove(storyId);
    } else {
      updated.add(storyId);
    }

    state = updated;
    await _localService.saveBookmarks(updated);

    final uid = _uid ?? _ref.read(currentUserProvider)?.uid;
    if (uid == null) {
      return;
    }

    try {
      if (wasBookmarked) {
        await _remoteService.removeBookmark(uid: uid, storyId: storyId);
      } else {
        await _remoteService.addBookmark(uid: uid, storyId: storyId);
      }
    } catch (_) {
      // Keep local state as fallback even if remote sync fails.
    }
  }

  bool isBookmarked(String storyId) => state.contains(storyId);
}
