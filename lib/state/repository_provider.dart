import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/bible_repository.dart';
import '../data/local_bible_repository.dart';
import 'content_provider.dart';

final bibleRepositoryProvider = Provider<BibleRepository>((ref) {
  final localStore = ref.watch(localContentStoreProvider);
  return LocalBibleRepository(localStore);
});
