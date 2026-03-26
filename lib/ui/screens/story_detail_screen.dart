import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content_images.dart';
import '../../l10n/app_localizations.dart';
import '../../state/character_providers.dart';
import '../../state/content_provider.dart';
import '../../state/story_providers.dart';
import '../widgets/bookmark_button.dart';
import '../widgets/character_card.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/section_header.dart';

class StoryDetailScreen extends ConsumerWidget {
  const StoryDetailScreen({super.key, required this.storyId});

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyAsync = ref.watch(storyProvider(storyId));
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: storyAsync.when(
        data: (story) {
          if (story == null) {
            return EmptyView(
              message: l10n.storiesEmpty,
              icon: Icons.auto_stories_rounded,
            );
          }
          final title = story.title.forLocale(locale);
          final content = story.content.forLocale(locale);
          final scriptureReferences = story.scriptureReferences.forLocale(locale);
          final relatedCharactersAsync =
              ref.watch(charactersByIdsProvider(story.characterIds));

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF274C3A), Color(0xFF8C6A43)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          ContentImages.story(story.id),
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    if (scriptureReferences.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Text(
                        l10n.storyDetailScriptureReferences,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white70,
                              letterSpacing: 0.3,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: scriptureReferences
                            .map(
                              (reference) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.18),
                                  ),
                                ),
                                child: Text(
                                  reference,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 16),
                    BookmarkButton(storyId: story.id),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE3D7C8)),
                ),
                child: Text(
                  content,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.7,
                        color: const Color(0xFF2F2419),
                      ),
                ),
              ),
              const SizedBox(height: 10),
              SectionHeader(title: l10n.storyDetailRelatedCharacters),
              relatedCharactersAsync.when(
                data: (characters) {
                  if (characters.isEmpty) {
                    return EmptyView(
                      message: l10n.charactersEmpty,
                      icon: Icons.people_alt_rounded,
                    );
                  }
                  return SizedBox(
                    height: 140,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      scrollDirection: Axis.horizontal,
                      itemCount: characters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final character = characters[index];
                        return SizedBox(
                          width: 170,
                          child: CharacterCard(
                            name: character.name.forLocale(locale),
                            imageAsset: ContentImages.character(character.id),
                            onTap: () => context.push('/character/${character.id}'),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const LoadingView(),
                error: (_, __) => AppErrorView(
                  message: l10n.genericErrorMessage,
                  onRetry: () => ref.read(contentControllerProvider).refresh(force: true),
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
    );
  }
}
