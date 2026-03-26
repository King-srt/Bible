import '../models/character.dart';
import '../models/story.dart';
import '../services/local_content_store.dart';
import 'bible_repository.dart';

class LocalBibleRepository implements BibleRepository {
  const LocalBibleRepository(this._store);

  final LocalContentStore _store;

  @override
  Future<List<Story>> getStories() async {
    return _store.getStories();
  }

  @override
  Future<Story?> getStoryById(String id) async {
    final stories = _store.getStories();
    for (final story in stories) {
      if (story.id == id) {
        return story;
      }
    }
    return null;
  }

  @override
  Future<List<BibleCharacter>> getCharacters() async {
    return _store.getCharacters();
  }

  @override
  Future<BibleCharacter?> getCharacterById(String id) async {
    final characters = _store.getCharacters();
    for (final character in characters) {
      if (character.id == id) {
        return character;
      }
    }
    return null;
  }
}
