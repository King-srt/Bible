import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content_images.dart';
import '../../l10n/app_localizations.dart';
import '../../state/bookmark_provider.dart';
import '../../state/story_providers.dart';
import '../../state/content_provider.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/main_bottom_navigation.dart';
import '../widgets/story_card.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final bookmarkedIds = ref.watch(bookmarksProvider);
    final storiesAsync = ref.watch(storyListProvider(null));

    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(l10n.bookmarksTitle),
      ),
      bottomNavigationBar: const MainBottomNavigation(currentIndex: 2),
      body: RefreshIndicator(
        onRefresh: () => ref.read(contentControllerProvider).refresh(force: true),
        child: storiesAsync.when(
          data: (stories) {
            final bookmarkedStories = stories
                .where((story) => bookmarkedIds.contains(story.id))
                .toList();

            if (bookmarkedStories.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 120),
                  EmptyView(
                    message: l10n.bookmarksEmpty,
                    icon: Icons.bookmark_outline_rounded,
                    actionLabel: l10n.retryLabel,
                    onAction: () => ref.read(contentControllerProvider).refresh(force: true),
                  ),
                ],
              );
            }

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _ScreenIntro(
                  title: l10n.bookmarksTitle,
                  subtitle: l10n.homeWelcomeSubtitle,
                  countLabel: l10n.bookmarksSavedCount(bookmarkedStories.length),
                ),
                const SizedBox(height: 16),
                ...bookmarkedStories.map(
                  (story) => Container(
                    margin: const EdgeInsets.only(bottom: 14),
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
                  ),
                ),
              ],
            );
          },
          loading: () => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 160),
              LoadingView(),
            ],
          ),
          error: (_, __) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 120),
              AppErrorView(
                message: l10n.genericErrorMessage,
                onRetry: () => ref.read(contentControllerProvider).refresh(force: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScreenIntro extends StatelessWidget {
  const _ScreenIntro({
    required this.title,
    required this.subtitle,
    required this.countLabel,
  });

  final String title;
  final String subtitle;
  final String countLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C4A3F), Color(0xFF7F6445)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            countLabel,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.88),
                ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }
}
