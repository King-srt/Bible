import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content_images.dart';
import '../../l10n/app_localizations.dart';
import '../../models/testament.dart';
import '../../state/story_providers.dart';
import '../../state/content_provider.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/story_card.dart';

class StoryListScreen extends ConsumerWidget {
  const StoryListScreen({super.key, required this.testament});

  final Testament testament;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final title = testament == Testament.old
        ? l10n.storyListTitleOld
        : l10n.storyListTitleNew;

    final storiesAsync = ref.watch(storyListProvider(testament));
    final locale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(title),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(contentControllerProvider).refresh(force: true),
        child: storiesAsync.when(
          data: (stories) {
            if (stories.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 120),
                  EmptyView(
                    message: l10n.storiesEmpty,
                    icon: Icons.auto_stories_rounded,
                    actionLabel: l10n.retryLabel,
                    onAction: () => ref.read(contentControllerProvider).refresh(force: true),
                  ),
                ],
              );
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: stories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
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
