import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../state/auth_provider.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authBootstrap = ref.watch(ensureAnonymousSignInProvider);

    return authBootstrap.when(
      data: (_) => child,
      loading: () => Scaffold(
        backgroundColor: const Color(0xFFF6F1E8),
        body: LoadingView(message: l10n.authPreparingSession),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: const Color(0xFFF6F1E8),
        body: AppErrorView(
          message: l10n.authFailedMessage,
          onRetry: () => ref.invalidate(ensureAnonymousSignInProvider),
        ),
      ),
    );
  }
}
