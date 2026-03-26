import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content_images.dart';
import '../../l10n/app_localizations.dart';
import '../../models/testament.dart';
import '../../state/character_providers.dart';
import '../../state/content_provider.dart';
import '../../state/story_providers.dart';
import '../widgets/character_card.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/main_bottom_navigation.dart';
import '../widgets/section_header.dart';
import '../widgets/story_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _refreshHome(WidgetRef ref) {
    return ref.read(contentControllerProvider).refresh(force: true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      bottomNavigationBar: const MainBottomNavigation(currentIndex: 0),
      body: RefreshIndicator(
        onRefresh: () => _refreshHome(ref),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeWelcomeTitle,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF2F2419),
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.homeWelcomeSubtitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF6A5846),
                            height: 1.4,
                          ),
                    ),
                    const SizedBox(height: 20),
                    const _QuickActions(),
                    const SizedBox(height: 20),
                    const _FeaturedStorySection(),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SectionHeader(
                title: l10n.homeOldTestament,
                actionLabel: l10n.viewAll,
                onAction: () => context.push('/stories/old'),
              ),
            ),
            SliverToBoxAdapter(
              child: _StoryStrip(
                testament: Testament.old,
                accentColor: scheme.primary,
              ),
            ),
            SliverToBoxAdapter(
              child: SectionHeader(
                title: l10n.homeNewTestament,
                actionLabel: l10n.viewAll,
                onAction: () => context.push('/stories/new'),
              ),
            ),
            const SliverToBoxAdapter(
              child: _StoryStrip(
                testament: Testament.newTestament,
                accentColor: Color(0xFF8A5A2B),
              ),
            ),
            SliverToBoxAdapter(
              child: SectionHeader(
                title: l10n.homeCharacterHighlight,
                actionLabel: l10n.viewAll,
                onAction: () => context.push('/characters'),
              ),
            ),
            const SliverToBoxAdapter(child: _CharacterHighlight()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeQuickActions,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2F2419),
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ActionChip(
              icon: Icons.menu_book_outlined,
              label: l10n.homeActionOld,
              onTap: () => context.push('/stories/old'),
            ),
            _ActionChip(
              icon: Icons.auto_stories_outlined,
              label: l10n.homeActionNew,
              onTap: () => context.push('/stories/new'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: const Color(0xFF6D4C2E)),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedStorySection extends ConsumerWidget {
  const _FeaturedStorySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(featuredStoryProvider);
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context)!;

    return storiesAsync.when(
      data: (story) {
        if (story == null) {
          return EmptyView(
            message: l10n.storiesEmpty,
            icon: Icons.auto_stories_rounded,
            actionLabel: l10n.retryLabel,
            onAction: () => ref.read(contentControllerProvider).refresh(force: true),
          );
        }

        final imageAsset = ContentImages.story(story.id);

        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF274C3A), Color(0xFF8C6A43)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.push('/story/${story.id}'),
              borderRadius: BorderRadius.circular(28),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        height: 180,
                        width: double.infinity,
                        child: Image.asset(
                          imageAsset,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF1F3B2E), Color(0xFF6F5537)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.auto_stories_rounded,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      l10n.homeHeroEyebrow,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white70,
                            letterSpacing: 1.1,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      story.title.forLocale(locale),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      story.content.forLocale(locale),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.4,
                          ),
                    ),
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF274C3A),
                      ),
                      onPressed: () => context.push('/story/${story.id}'),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: Text(l10n.homeReadNow),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const LoadingView(),
      error: (_, __) => AppErrorView(
        message: l10n.genericErrorMessage,
        onRetry: () => ref.read(contentControllerProvider).refresh(force: true),
      ),
    );
  }
}

class _StoryStrip extends ConsumerWidget {
  const _StoryStrip({
    required this.testament,
    required this.accentColor,
  });

  final Testament testament;
  final Color accentColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(storyListProvider(testament));
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: 230,
      child: storiesAsync.when(
        data: (stories) {
          if (stories.isEmpty) {
            return EmptyView(
              message: l10n.storiesEmpty,
              icon: Icons.menu_book_rounded,
              actionLabel: l10n.retryLabel,
              onAction: () => ref.read(contentControllerProvider).refresh(force: true),
            );
          }
          final limited = stories.take(6).toList();
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: limited.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final story = limited[index];
              return SizedBox(
                width: 220,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: accentColor.withValues(alpha: 0.18)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 14,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: StoryCard(
                    title: story.title.forLocale(locale),
                    imageAsset: ContentImages.story(story.id),
                    onTap: () => context.push('/story/${story.id}'),
                  ),
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
    );
  }
}

class _CharacterHighlight extends ConsumerWidget {
  const _CharacterHighlight();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsync = ref.watch(characterListProvider(null));
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context)!;

    return charactersAsync.when(
      data: (characters) {
        if (characters.isEmpty) {
          return EmptyView(
            message: l10n.charactersEmpty,
            icon: Icons.people_alt_rounded,
            actionLabel: l10n.retryLabel,
            onAction: () => ref.read(contentControllerProvider).refresh(force: true),
          );
        }
        final character = characters.first;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF4),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE4D8C7)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CharacterCard(
                    name: character.name.forLocale(locale),
                    imageAsset: ContentImages.character(character.id),
                    onTap: () => context.push('/character/${character.id}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/character/${character.id}'),
                      icon: const Icon(Icons.travel_explore_outlined),
                      label: Text(l10n.homeExploreCharacter),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const LoadingView(),
      error: (_, __) => AppErrorView(
        message: l10n.genericErrorMessage,
        onRetry: () => ref.read(contentControllerProvider).refresh(force: true),
      ),
    );
  }
}
