import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../state/content_provider.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

class ContentGate extends ConsumerWidget {
  const ContentGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final contentBootstrap = ref.watch(contentBootstrapProvider);

    return contentBootstrap.when(
      data: (_) => child,
      loading: () => Scaffold(
        backgroundColor: const Color(0xFFF6F1E8),
        body: LoadingView(message: l10n.contentPreparingLibrary),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: const Color(0xFFF6F1E8),
        body: AppErrorView(
          message: l10n.contentFailedMessage,
          onRetry: () => ref.invalidate(contentBootstrapProvider),
        ),
      ),
    );
  }
}
