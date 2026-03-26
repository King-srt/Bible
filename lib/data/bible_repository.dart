import '../models/character.dart';
import '../models/story.dart';

abstract class BibleRepository {
  Future<List<Story>> getStories();
  Future<Story?> getStoryById(String id);
  Future<List<BibleCharacter>> getCharacters();
  Future<BibleCharacter?> getCharacterById(String id);
}
