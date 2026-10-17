import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/models/app_models.dart';
import '../../../core/repositories/app_repositories.dart';
import '../../../core/services/app_providers.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../widgets/buttons/app_buttons.dart';
import '../../../widgets/cards/feature_cards.dart';
import '../../../widgets/cards/glass_card.dart';
import '../../../widgets/charts/app_charts.dart';
import '../../../widgets/inputs/custom_inputs.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key, required this.scanId});

  final String scanId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scan = ref.watch(scanRepositoryProvider).getById(scanId) ??
        ref.watch(currentScanResultProvider);
    final isDark = ref.watch(isDarkModeProvider);
    final isWide = MediaQuery.sizeOf(context).width > 700;

    if (scan == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Report')),
        body: const Center(child: Text('Scan result not found')),
      );
    }

    final dateFormat = DateFormat('MMMM d, yyyy · h:mm a');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 80,
            pinned: true,
            backgroundColor:
                isDark ? AppColors.darkBackground : AppColors.background,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.go('/dashboard'),
            ),
            title: const Text('Diagnostic Report'),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_rounded),
                onPressed: () => _showShareSheet(context),
                tooltip: 'Share Report',
              ),
              IconButton(
                icon: const Icon(Icons.download_rounded),
                onPressed: () => _showDownloadSnack(context),
                tooltip: 'Download PDF',
              ),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? AppSpacing.xl : AppSpacing.md,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                PredictionCard(
                  severity: scan.severity,
                  confidence: scan.confidence,
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    ProfileAvatar(name: scan.patientName, size: 44),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scan.patientName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            dateFormat.format(scan.timestamp),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: AppSpacing.lg),
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildLeftColumn(context, scan, isDark)),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(child: _buildRightColumn(context, scan)),
                    ],
                  )
                else ...[
                  _buildLeftColumn(context, scan, isDark),
                  const SizedBox(height: AppSpacing.lg),
                  _buildRightColumn(context, scan),
                ],
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        label: 'Schedule Follow-up',
                        icon: Icons.calendar_month_rounded,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PrimaryButton(
                        label: 'New Scan',
                        icon: Icons.camera_alt_rounded,
                        onPressed: () => context.push('/camera'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxxl),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftColumn(
    BuildContext context,
    ScanResult scan,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Retina Image', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        GlassCard(
          padding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: AspectRatio(
              aspectRatio: 1,
              child: scan.imagePath != null
                  ? Image.file(
                      File(scan.imagePath!),
                      fit: BoxFit.cover,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF4A1515),
                            Colors.black,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.remove_red_eye_rounded,
                        size: 64,
                        color: Colors.white24,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Risk Assessment', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        GlassCard(
          child: Center(
            child: RiskGauge(riskLevel: scan.severity.riskLevel),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Confidence', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        GlassCard(child: ConfidenceMeter(confidence: scan.confidence)),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context, ScanResult scan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Detected Features', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        GlassCard(
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: scan.detectedFeatures
                .map(
                  (f) => StatusBadge(
                    label: f,
                    color: AppColors.primary,
                    icon: Icons.fiber_manual_record,
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Recommendations', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        GlassCard(child: RecommendationCard(recommendations: scan.recommendations)),
        const SizedBox(height: AppSpacing.lg),
        Text('Timeline', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        GlassCard(child: _TimelineWidget(scan: scan)),
        if (scan.doctorNotes != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Doctor Notes', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          GlassCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.note_alt_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    scan.doctorNotes!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _showShareSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Share Report', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            ListTile(
              leading: const Icon(Icons.email_rounded),
              title: const Text('Email to Specialist'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.link_rounded),
              title: const Text('Copy Link'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showDownloadSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Report PDF generated successfully'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
    );
  }
}

class _TimelineWidget extends StatelessWidget {
  const _TimelineWidget({required this.scan});

  final ScanResult scan;

  @override
  Widget build(BuildContext context) {
    final events = [
      ('Scan Captured', scan.timestamp),
      ('AI Analysis Complete', scan.timestamp.add(const Duration(minutes: 1))),
      ('Report Generated', scan.timestamp.add(const Duration(minutes: 2))),
    ];
    final format = DateFormat('h:mm a');

    return Column(
      children: events.asMap().entries.map((entry) {
        final isLast = entry.key == events.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 32,
                    color: AppColors.border,
                  ),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.value.$1,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      format.format(entry.value.$2),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
