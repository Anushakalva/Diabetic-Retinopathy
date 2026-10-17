import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/models/app_models.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../inputs/custom_inputs.dart';

class StatisticsCard extends ConsumerWidget {
  const StatisticsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.trend,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final String? trend;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppTheme.cardDecoration(isDark: isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const Spacer(),
              if (trend != null)
                Text(
                  trend!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(subtitle!, style: Theme.of(context).textTheme.labelSmall),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}

class PatientCard extends ConsumerWidget {
  const PatientCard({
    super.key,
    required this.patient,
    this.onTap,
  });

  final Patient patient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final dateFormat = DateFormat('MMM d, yyyy');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: AppTheme.cardDecoration(isDark: isDark),
          child: Row(
            children: [
              ProfileAvatar(name: patient.name, size: 52),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${patient.age} yrs · ${patient.gender} · ${patient.diabetesType}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (patient.lastScanDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Last scan: ${dateFormat.format(patient.lastScanDate!)}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ],
                ),
              ),
              DiseaseBadge(severity: patient.riskLevel),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.05, end: 0);
  }
}

class DoctorCard extends ConsumerWidget {
  const DoctorCard({
    super.key,
    required this.profile,
    this.onTap,
  });

  final UserProfile profile;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              ProfileAvatar(name: profile.name, size: 56),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      profile.role,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                    ),
                    Text(
                      profile.hospital,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultCard extends ConsumerWidget {
  const ResultCard({
    super.key,
    required this.scan,
    this.onTap,
  });

  final ScanResult scan;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final dateFormat = DateFormat('MMM d, yyyy · h:mm a');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: AppTheme.cardDecoration(isDark: isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      scan.patientName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  DiseaseBadge(severity: scan.severity),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                dateFormat.format(scan.timestamp),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(
                    Icons.verified_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(scan.confidence * 100).toStringAsFixed(1)}% confidence',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PredictionCard extends ConsumerWidget {
  const PredictionCard({
    super.key,
    required this.severity,
    required this.confidence,
  });

  final DrSeverity severity;
  final double confidence;

  Color get _severityColor => switch (severity) {
        DrSeverity.none => AppColors.success,
        DrSeverity.mild => AppColors.accent,
        DrSeverity.moderate => AppColors.warning,
        DrSeverity.severe => const Color(0xFFF97316),
        DrSeverity.proliferative => AppColors.danger,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _severityColor.withValues(alpha: 0.15),
            _severityColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: _severityColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.visibility_rounded,
            size: 48,
            color: _severityColor,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            severity.label,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: _severityColor,
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            severity.description,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '${(confidence * 100).toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: _severityColor,
                  fontWeight: FontWeight.w800,
                ),
          ),
          Text(
            'AI Confidence',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    ).animate().scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          duration: 500.ms,
          curve: Curves.easeOutBack,
        );
  }
}

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({super.key, required this.recommendations});

  final List<String> recommendations;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: recommendations.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${entry.key + 1}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  entry.value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ).animate(delay: (entry.key * 80).ms).fadeIn().slideX(begin: 0.05, end: 0);
      }).toList(),
    );
  }
}
