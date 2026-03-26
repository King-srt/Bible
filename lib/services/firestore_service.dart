import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/character.dart';
import '../models/story.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<String?> getContentVersion(String key) async {
    final doc = await _firestore.collection('content_meta').doc(key).get();
    if (!doc.exists) {
      return null;
    }

    final data = doc.data();
    final rawVersion = data?['version'];
    if (rawVersion is String && rawVersion.trim().isNotEmpty) {
      return rawVersion.trim();
    }
    if (rawVersion is int || rawVersion is num) {
      return 'v${rawVersion.toString()}.0.0';
    }
    return null;
  }

  Future<List<Story>> getStories() async {
    try {
      final snapshot = await _firestore.collection('stories').get();
      return snapshot.docs.map(Story.fromFirestore).toList();
    } catch (e) {
      throw Exception('Failed to fetch stories: $e');
    }
  }

  Future<List<Story>> getStoriesByTestament(String testament) async {
    try {
      final snapshot = await _firestore
          .collection('stories')
          .where('testament', isEqualTo: testament)
          .get();

      return snapshot.docs.map(Story.fromFirestore).toList();
    } catch (e) {
      throw Exception('Failed to fetch stories by testament: $e');
    }
  }

  Future<Story?> getStoryById(String id) async {
    try {
      final doc = await _firestore.collection('stories').doc(id).get();
      if (!doc.exists) {
        return null;
      }
      return Story.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch story by id: $e');
    }
  }

  Future<List<BibleCharacter>> getCharacters() async {
    try {
      final snapshot = await _firestore.collection('characters').get();
      return snapshot.docs.map(BibleCharacter.fromFirestore).toList();
    } catch (e) {
      throw Exception('Failed to fetch characters: $e');
    }
  }

  Future<BibleCharacter?> getCharacterById(String id) async {
    try {
      final doc = await _firestore.collection('characters').doc(id).get();
      if (!doc.exists) {
        return null;
      }
      return BibleCharacter.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch character by id: $e');
    }
  }

  Future<List<Story>> getStoriesByCharacter(String characterId) async {
    try {
      final snapshot = await _firestore
          .collection('stories')
          .where('character_ids', arrayContains: characterId)
          .get();

      return snapshot.docs.map(Story.fromFirestore).toList();
    } catch (e) {
      throw Exception('Failed to fetch stories by character: $e');
    }
  }
}
