import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/services/app_providers.dart';
import '../../../widgets/cards/feature_cards.dart';
import '../../../widgets/loaders/app_loaders.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scans = ref.watch(recentScansProvider);
    final isWide = MediaQuery.sizeOf(context).width > 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? AppSpacing.xl : AppSpacing.md,
        ),
        child: scans.isEmpty
            ? const EmptyStateWidget(
                title: 'No reports yet',
                message: 'Complete a retinal scan to generate your first report.',
                icon: Icons.description_outlined,
              )
            : ListView.separated(
                itemCount: scans.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  return ResultCard(
                    scan: scans[index],
                    onTap: () => context.push('/results/${scans[index].id}'),
                  ).animate(delay: (index * 60).ms);
                },
              ),
      ),
    );
  }
}
