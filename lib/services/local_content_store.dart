import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/character.dart';
import '../models/story.dart';

class LocalContentStore {
  LocalContentStore({
    required SharedPreferences preferences,
    AssetBundle? bundle,
  })  : _preferences = preferences,
        _bundle = bundle ?? rootBundle;

  static const _storiesKey = 'content.cached_stories';
  static const _charactersKey = 'content.cached_characters';
  static const _storiesVersionKey = 'content.cached_stories_version';
  static const _charactersVersionKey = 'content.cached_characters_version';

  final SharedPreferences _preferences;
  final AssetBundle _bundle;

  Future<void> ensureSeeded() async {
    final hasStories = (_preferences.getString(_storiesKey) ?? '').isNotEmpty;
    final hasCharacters =
        (_preferences.getString(_charactersKey) ?? '').isNotEmpty;

    if (hasStories && hasCharacters) {
      return;
    }

    final bundledStories = await loadBundledStories();
    final bundledCharacters = await loadBundledCharacters();

    if (!hasStories) {
      await saveStories(bundledStories);
    }
    if (!hasCharacters) {
      await saveCharacters(bundledCharacters);
    }
  }

  Future<List<Story>> loadBundledStories() async {
    final raw = await _bundle.loadString('firestore_seed/stories.json');
    return _decodeStories(raw);
  }

  Future<List<BibleCharacter>> loadBundledCharacters() async {
    final raw = await _bundle.loadString('firestore_seed/characters.json');
    return _decodeCharacters(raw);
  }

  List<Story> getStories() {
    final raw = _preferences.getString(_storiesKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    return _decodeStories(raw);
  }

  List<BibleCharacter> getCharacters() {
    final raw = _preferences.getString(_charactersKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    return _decodeCharacters(raw);
  }

  Future<void> saveStories(List<Story> stories) {
    return _preferences.setString(
      _storiesKey,
      jsonEncode(stories.map((story) => story.toMap()).toList()),
    );
  }

  Future<void> saveCharacters(List<BibleCharacter> characters) {
    return _preferences.setString(
      _charactersKey,
      jsonEncode(characters.map((character) => character.toMap()).toList()),
    );
  }

  String? getStoriesVersion() => _preferences.getString(_storiesVersionKey);

  String? getCharactersVersion() => _preferences.getString(_charactersVersionKey);

  Future<void> saveStoriesVersion(String version) {
    return _preferences.setString(_storiesVersionKey, version);
  }

  Future<void> saveCharactersVersion(String version) {
    return _preferences.setString(_charactersVersionKey, version);
  }

  List<Story> _decodeStories(String raw) {
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Story.fromMap(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  List<BibleCharacter> _decodeCharacters(String raw) {
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map(
          (item) => BibleCharacter.fromMap(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }
}
