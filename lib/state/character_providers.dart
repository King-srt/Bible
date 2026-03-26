import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/character.dart';
import '../models/story.dart';
import '../models/testament.dart';
import 'content_provider.dart';
import 'repository_provider.dart';

final characterListProvider = FutureProvider.family<List<BibleCharacter>, Testament?>(
  (ref, testament) async {
    await ref.watch(contentBootstrapProvider.future);
    ref.watch(contentRevisionProvider);

    final repository = ref.watch(bibleRepositoryProvider);
    final characters = await repository.getCharacters();
    if (testament == null) {
      return characters;
    }
    return characters.where((character) => character.testament == testament).toList();
  },
);

final characterProvider = FutureProvider.family<BibleCharacter?, String>((ref, id) async {
  await ref.watch(contentBootstrapProvider.future);
  ref.watch(contentRevisionProvider);

  final repository = ref.watch(bibleRepositoryProvider);
  return repository.getCharacterById(id);
});

final charactersByIdsProvider = FutureProvider.family<List<BibleCharacter>, List<String>>(
  (ref, ids) async {
    await ref.watch(contentBootstrapProvider.future);
    ref.watch(contentRevisionProvider);

    final repository = ref.watch(bibleRepositoryProvider);
    final characters = await repository.getCharacters();
    return characters.where((character) => ids.contains(character.id)).toList();
  },
);

final storiesByCharacterProvider = FutureProvider.family<List<Story>, String>((ref, characterId) async {
  await ref.watch(contentBootstrapProvider.future);
  ref.watch(contentRevisionProvider);

  final repository = ref.watch(bibleRepositoryProvider);
  final stories = await repository.getStories();
  return stories.where((story) => story.characterIds.contains(characterId)).toList();
});
