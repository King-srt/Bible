import 'dart:convert';

import '../models/character.dart';
import '../models/story.dart';
import 'content_version.dart';
import 'firestore_service.dart';
import 'local_content_store.dart';

class ContentSyncService {
  ContentSyncService({
    required LocalContentStore localStore,
    required FirestoreService firestoreService,
  })  : _localStore = localStore,
        _firestoreService = firestoreService;

  final LocalContentStore _localStore;
  final FirestoreService _firestoreService;

  Future<void> ensureInitialized() {
    return _localStore.ensureSeeded();
  }

  Future<bool> syncIfNeeded({bool force = false}) async {
    await ensureInitialized();

    var updated = false;
    updated = await _syncStories(force: force) || updated;
    updated = await _syncCharacters(force: force) || updated;
    return updated;
  }

  Future<bool> _syncStories({required bool force}) async {
    final localStories = _localStore.getStories();
    final localVersion = _parseVersion(_localStore.getStoriesVersion());
    final remoteVersion = _parseVersion(await _safeContentVersion('stories'));

    if (!force && remoteVersion != null && localVersion != null) {
      if (remoteVersion.compareTo(localVersion) <= 0) {
        return false;
      }
    }

    final remoteStories = await _safeStories();
    if (remoteStories == null || remoteStories.isEmpty) {
      return false;
    }

    if (!force && remoteVersion == null && _sameStories(localStories, remoteStories)) {
      return false;
    }

    await _localStore.saveStories(remoteStories);
    if (remoteVersion != null) {
      await _localStore.saveStoriesVersion(remoteVersion.toString());
    }
    return true;
  }

  Future<bool> _syncCharacters({required bool force}) async {
    final localCharacters = _localStore.getCharacters();
    final localVersion = _parseVersion(_localStore.getCharactersVersion());
    final remoteVersion = _parseVersion(await _safeContentVersion('characters'));

    if (!force && remoteVersion != null && localVersion != null) {
      if (remoteVersion.compareTo(localVersion) <= 0) {
        return false;
      }
    }

    final remoteCharacters = await _safeCharacters();
    if (remoteCharacters == null || remoteCharacters.isEmpty) {
      return false;
    }

    if (!force &&
        remoteVersion == null &&
        _sameCharacters(localCharacters, remoteCharacters)) {
      return false;
    }

    await _localStore.saveCharacters(remoteCharacters);
    if (remoteVersion != null) {
      await _localStore.saveCharactersVersion(remoteVersion.toString());
    }
    return true;
  }

  ContentVersion? _parseVersion(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    try {
      return ContentVersion.parse(raw);
    } catch (_) {
      return null;
    }
  }

  Future<String?> _safeContentVersion(String collection) async {
    try {
      return await _firestoreService.getContentVersion(collection);
    } catch (_) {
      return null;
    }
  }

  Future<List<Story>?> _safeStories() async {
    try {
      return await _firestoreService.getStories();
    } catch (_) {
      return null;
    }
  }

  Future<List<BibleCharacter>?> _safeCharacters() async {
    try {
      return await _firestoreService.getCharacters();
    } catch (_) {
      return null;
    }
  }

  bool _sameStories(List<Story> left, List<Story> right) {
    return jsonEncode(left.map((story) => story.toMap()).toList()) ==
        jsonEncode(right.map((story) => story.toMap()).toList());
  }

  bool _sameCharacters(List<BibleCharacter> left, List<BibleCharacter> right) {
    return jsonEncode(right.map((character) => character.toMap()).toList()) ==
        jsonEncode(left.map((character) => character.toMap()).toList());
  }
}
