import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content_images.dart';
import '../../l10n/app_localizations.dart';
import '../../models/character.dart';
import '../../models/story.dart';
import '../../state/character_providers.dart';
import '../../state/content_provider.dart';
import '../../state/story_providers.dart';
import '../widgets/character_card.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/section_header.dart';
import '../widgets/story_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String query = '';

  Future<void> _refreshSearch() {
    return ref.read(contentControllerProvider).refresh(force: true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final storiesAsync = ref.watch(storyListProvider(null));
    final charactersAsync = ref.watch(characterListProvider(null));

    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(l10n.searchTitle),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshSearch,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  query = value.trim().toLowerCase();
                });
              },
            ),
            const SizedBox(height: 18),
            if (query.isEmpty)
              EmptyView(
                message: l10n.searchEmptyQuery,
                icon: Icons.search_rounded,
                actionLabel: l10n.retryLabel,
                onAction: () {
                  ref.read(contentControllerProvider).refresh(force: true);
                },
              )
            else ...[
              storiesAsync.when(
                data: (stories) {
                  final filteredStories = _filterStories(stories, locale, query);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: l10n.searchStories),
                      if (filteredStories.isEmpty)
                        EmptyView(
                          message: l10n.searchNoStories,
                          icon: Icons.auto_stories_rounded,
                          actionLabel: l10n.retryLabel,
                          onAction: () => ref.read(contentControllerProvider).refresh(force: true),
                        )
                      else
                        ...filteredStories.map(
                          (story) => Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: const Color(0xFFE3D7C8)),
                            ),
                            child: StoryCard(
                              title: story.title.forLocale(locale),
                              imageAsset: ContentImages.story(story.id),
                              onTap: () => context.push('/story/${story.id}'),
                            ),
                          ),
                        ),
                    ],
                  );
                },
                loading: () => const LoadingView(),
                error: (_, __) => AppErrorView(
                  message: l10n.genericErrorMessage,
                  onRetry: () => ref.read(contentControllerProvider).refresh(force: true),
                ),
              ),
              const SizedBox(height: 8),
              charactersAsync.when(
                data: (characters) {
                  final filteredCharacters =
                      _filterCharacters(characters, locale, query);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: l10n.searchCharacters),
                      if (filteredCharacters.isEmpty)
                        EmptyView(
                          message: l10n.searchNoCharacters,
                          icon: Icons.people_alt_rounded,
                          actionLabel: l10n.retryLabel,
                          onAction: () => ref.read(contentControllerProvider).refresh(force: true),
                        )
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredCharacters.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.05,
                          ),
                          itemBuilder: (context, index) {
                            final character = filteredCharacters[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: const Color(0xFFE3D7C8)),
                              ),
                              child: CharacterCard(
                                name: character.name.forLocale(locale),
                                imageAsset: ContentImages.character(character.id),
                                onTap: () => context.push('/character/${character.id}'),
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
                loading: () => const LoadingView(),
                error: (_, __) => AppErrorView(
                  message: l10n.genericErrorMessage,
                  onRetry: () => ref.read(contentControllerProvider).refresh(force: true),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Story> _filterStories(List<Story> stories, Locale locale, String query) {
    return stories.where((story) {
      final title = story.title.forLocale(locale).toLowerCase();
      final content = story.content.forLocale(locale).toLowerCase();
      final tags = story.tags.join(' ').toLowerCase();
      return title.contains(query) || content.contains(query) || tags.contains(query);
    }).toList();
  }

  List<BibleCharacter> _filterCharacters(
    List<BibleCharacter> characters,
    Locale locale,
    String query,
  ) {
    return characters.where((character) {
      final name = character.name.forLocale(locale).toLowerCase();
      final summary = character.summary.forLocale(locale).toLowerCase();
      return name.contains(query) || summary.contains(query);
    }).toList();
  }
}
