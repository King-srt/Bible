import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../state/content_provider.dart';
import '../../state/genealogy_provider.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

class GenealogyScreen extends ConsumerWidget {
  const GenealogyScreen({super.key, required this.genealogyId});

  final String genealogyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genealogyAsync = ref.watch(genealogyProvider(genealogyId));
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: genealogyAsync.when(
        data: (genealogy) {
          if (genealogy == null) {
            return EmptyView(
              message: l10n.genealogyEmpty,
              icon: Icons.account_tree_rounded,
            );
          }

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
                    Text(
                      genealogy.title.forLocale(locale),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      genealogy.description.forLocale(locale),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.45,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(genealogy.entries.length, (index) {
                final entry = genealogy.entries[index];
                final isLast = index == genealogy.entries.length - 1;
                return _GenealogyNode(
                  label: entry.label.forLocale(locale),
                  isLast: isLast,
                  onTap: entry.characterId == null || entry.characterId!.isEmpty
                      ? null
                      : () => context.push('/character/${entry.characterId}'),
                );
              }),
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

class _GenealogyNode extends StatelessWidget {
  const _GenealogyNode({
    required this.label,
    required this.isLast,
    this.onTap,
  });

  final String label;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(top: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF8C6A43),
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: const Color(0xFFD8C9B6),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFE3D7C8)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            label,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF2F2419),
                                ),
                          ),
                        ),
                        if (onTap != null)
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Color(0xFF8C6A43),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
