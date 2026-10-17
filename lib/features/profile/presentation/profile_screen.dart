import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/services/app_providers.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../widgets/buttons/app_buttons.dart';
import '../../../widgets/cards/feature_cards.dart';
import '../../../widgets/cards/glass_card.dart';
import '../../../widgets/charts/app_charts.dart';
import '../../../widgets/inputs/custom_inputs.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final stats = ref.watch(dashboardStatsProvider);
    final isWide = MediaQuery.sizeOf(context).width > 700;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Not signed in')));
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      ProfileAvatar(name: user.name, size: 80, showStatus: true),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      Text(
                        user.role,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () => context.push('/settings'),
              ),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.all(isWide ? AppSpacing.xl : AppSpacing.md),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                GlassCard(
                  child: Column(
                    children: [
                      _InfoRow(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: user.email,
                      ),
                      const Divider(height: AppSpacing.lg),
                      _InfoRow(
                        icon: Icons.local_hospital_rounded,
                        label: 'Hospital',
                        value: user.hospital,
                      ),
                      if (user.licenseNumber != null) ...[
                        const Divider(height: AppSpacing.lg),
                        _InfoRow(
                          icon: Icons.badge_outlined,
                          label: 'License',
                          value: user.licenseNumber!,
                        ),
                      ],
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.05, end: 0),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Your Statistics',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: GlassCard(
                        child: Column(
                          children: [
                            AnimatedCounter(
                              value: stats.totalScans,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(color: AppColors.primary),
                            ),
                            Text(
                              'Total Scans',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: GlassCard(
                        child: Column(
                          children: [
                            AnimatedCounter(
                              value: (stats.averageConfidence * 100).round(),
                              suffix: '%',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(color: AppColors.accent),
                            ),
                            Text(
                              'Avg Confidence',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                SecondaryButton(
                  label: 'Sign Out',
                  icon: Icons.logout_rounded,
                  onPressed: () async {
                    await ref.read(authStateProvider.notifier).logout();
                    if (context.mounted) context.go('/login');
                  },
                ),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelSmall),
              Text(value, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}
