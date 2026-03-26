import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../state/bookmark_provider.dart';

class BookmarkButton extends ConsumerWidget {
  const BookmarkButton({super.key, required this.storyId});

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final bookmarks = ref.watch(bookmarksProvider);
    final isBookmarked = bookmarks.contains(storyId);

    return FilledButton.icon(
      onPressed: () => ref.read(bookmarksProvider.notifier).toggle(storyId),
      icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
      label: Text(
        isBookmarked ? l10n.storyDetailBookmarkRemove : l10n.storyDetailBookmarkAdd,
      ),
    );
  }
}
