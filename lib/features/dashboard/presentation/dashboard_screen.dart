import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/models/app_models.dart';
import '../../../core/services/app_providers.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../widgets/cards/feature_cards.dart';
import '../../../widgets/cards/glass_card.dart';
import '../../../widgets/charts/app_charts.dart';
import '../../../widgets/inputs/custom_inputs.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider).valueOrNull;
    final stats = ref.watch(dashboardStatsProvider);
    final recentScans = ref.watch(recentScansProvider);
    final isDark = ref.watch(isDarkModeProvider);
    final isWide = MediaQuery.sizeOf(context).width > 700;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor:
                isDark ? AppColors.darkBackground : AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good ${_greeting()},',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    auth?.name.split(' ').last ?? 'Doctor',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
                tooltip: 'Notifications',
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => context.push('/settings'),
                tooltip: 'Settings',
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.md),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                GlassCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Retinal Screening',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Capture fundus image for AI analysis',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Material(
                        color: AppColors.primary,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                        child: InkWell(
                          onTap: () => context.push('/camera'),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                          child: const Padding(
                            padding: EdgeInsets.all(AppSpacing.md),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.05, end: 0),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Overview',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                if (isWide)
                  Row(
                    children: [
                      Expanded(child: _buildStatCard(context, stats, 0)),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: _buildStatCard(context, stats, 1)),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: _buildStatCard(context, stats, 2)),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: _buildStatCard(context, stats, 3)),
                    ],
                  )
                else
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.3,
                    children: List.generate(
                      4,
                      (i) => _buildStatCard(context, stats, i),
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Scan Trends',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                GlassCard(child: const ScanTrendChart()),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Severity Distribution',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                GlassCard(
                  child: SeverityPieChart(
                    distribution: stats.severityDistribution,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Scans',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () => context.go('/reports'),
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                ...recentScans.take(3).map(
                      (scan) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ResultCard(
                          scan: scan,
                          onTap: () => context.push('/results/${scan.id}'),
                        ),
                      ),
                    ),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  Widget _buildStatCard(BuildContext context, DashboardStats stats, int index) {
    final items = [
      (
        'Total Scans',
        stats.totalScans.toString(),
        Icons.analytics_rounded,
        AppColors.primary,
        '+12%',
      ),
      (
        'Today',
        stats.todayScans.toString(),
        Icons.today_rounded,
        AppColors.secondary,
        '+3',
      ),
      (
        'High Risk',
        stats.highRiskCases.toString(),
        Icons.warning_amber_rounded,
        AppColors.danger,
        'Urgent',
      ),
      (
        'Avg Confidence',
        '${(stats.averageConfidence * 100).toStringAsFixed(0)}%',
        Icons.verified_rounded,
        AppColors.accent,
        'Excellent',
      ),
    ];
    final item = items[index];
    return StatisticsCard(
      title: item.$1,
      value: item.$2,
      icon: item.$3,
      color: item.$4,
      trend: item.$5,
    ).animate(delay: (index * 80).ms);
  }
}
