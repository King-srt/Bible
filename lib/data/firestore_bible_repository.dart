import '../models/character.dart';
import '../models/story.dart';
import '../services/firestore_service.dart';
import 'bible_repository.dart';

class FirestoreBibleRepository implements BibleRepository {
  FirestoreBibleRepository(this._service);

  final FirestoreService _service;

  @override
  Future<List<Story>> getStories() {
    return _service.getStories();
  }

  @override
  Future<Story?> getStoryById(String id) {
    return _service.getStoryById(id);
  }

  @override
  Future<List<BibleCharacter>> getCharacters() {
    return _service.getCharacters();
  }

  @override
  Future<BibleCharacter?> getCharacterById(String id) {
    return _service.getCharacterById(id);
  }
}
