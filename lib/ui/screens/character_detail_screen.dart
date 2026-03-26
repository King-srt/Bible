import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content_images.dart';
import '../../l10n/app_localizations.dart';
import '../../state/character_providers.dart';
import '../../state/content_provider.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/section_header.dart';
import '../widgets/story_card.dart';

class CharacterDetailScreen extends ConsumerWidget {
  const CharacterDetailScreen({super.key, required this.characterId});

  final String characterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterAsync = ref.watch(characterProvider(characterId));
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(),
      body: characterAsync.when(
        data: (character) {
          if (character == null) {
            return EmptyView(
              message: l10n.charactersEmpty,
              icon: Icons.people_alt_rounded,
            );
          }
          final name = character.name.forLocale(locale);
          final identity = character.identity.forLocale(locale);
          final lifeSpan = character.lifeSpan.forLocale(locale);
          final summary = character.summary.forLocale(locale);
          final strengths = character.strengths.forLocale(locale);
          final weaknesses = character.weaknesses.forLocale(locale);
          final relatedStoriesAsync =
              ref.watch(storiesByCharacterProvider(character.id));
          final hasGenealogy = character.id == 'char_jesus';

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      ContentImages.character(character.id),
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      alignment: const Alignment(0, -0.7),
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFECE4D7),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.person_rounded,
                          size: 56,
                          color: Color(0xFF8C6A43),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              if (identity.isNotEmpty || lifeSpan.isNotEmpty) ...[
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (identity.isNotEmpty)
                        _MetaPill(
                          icon: Icons.badge_outlined,
                          label: identity,
                        ),
                      if (lifeSpan.isNotEmpty)
                        _MetaPill(
                          icon: Icons.schedule_rounded,
                          label: lifeSpan,
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              if (hasGenealogy) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FilledButton.icon(
                    onPressed: () => context.push('/genealogy/genealogy_jesus'),
                    icon: const Icon(Icons.account_tree_rounded),
                    label: Text(l10n.characterDetailViewGenealogy),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  summary,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              SectionHeader(title: l10n.characterDetailStrengths),
              _TextChips(values: strengths),
              SectionHeader(title: l10n.characterDetailWeaknesses),
              _TextChips(values: weaknesses),
              SectionHeader(title: l10n.characterDetailRelatedStories),
              relatedStoriesAsync.when(
                data: (stories) {
                  if (stories.isEmpty) {
                    return EmptyView(
                      message: l10n.storiesEmpty,
                      icon: Icons.auto_stories_rounded,
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: stories.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final story = stories[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(color: const Color(0xFFE3D7C8)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 16,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: StoryCard(
                          title: story.title.forLocale(locale),
                          imageAsset: ContentImages.story(story.id),
                          onTap: () => context.push('/story/${story.id}'),
                        ),
                      );
                    },
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

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE3D7C8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF8C6A43)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2F2419),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextChips extends StatelessWidget {
  const _TextChips({required this.values});

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: values
            .map((value) => Chip(
                  label: Text(value),
                ))
            .toList(),
      ),
    );
  }
}
