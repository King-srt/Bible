import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/story.dart';
import '../models/testament.dart';
import 'content_provider.dart';
import 'repository_provider.dart';

final storyListProvider = FutureProvider.family<List<Story>, Testament?>(
  (ref, testament) async {
    await ref.watch(contentBootstrapProvider.future);
    ref.watch(contentRevisionProvider);

    final repository = ref.watch(bibleRepositoryProvider);
    final stories = await repository.getStories();
    if (testament == null) {
      return stories;
    }
    return stories.where((story) => story.testament == testament).toList();
  },
);

final storyProvider = FutureProvider.family<Story?, String>((ref, id) async {
  await ref.watch(contentBootstrapProvider.future);
  ref.watch(contentRevisionProvider);

  final repository = ref.watch(bibleRepositoryProvider);
  return repository.getStoryById(id);
});

final featuredStoryProvider = Provider<AsyncValue<Story?>>((ref) {
  final storiesAsync = ref.watch(storyListProvider(null));
  return storiesAsync.whenData((stories) => stories.isNotEmpty ? stories.first : null);
});
