import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/repositories/app_repositories.dart';
import '../../../core/services/app_providers.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../widgets/cards/glass_card.dart';

class AiProcessingScreen extends ConsumerStatefulWidget {
  const AiProcessingScreen({super.key});

  @override
  ConsumerState<AiProcessingScreen> createState() => _AiProcessingScreenState();
}

class _AiProcessingScreenState extends ConsumerState<AiProcessingScreen> {
  static const _steps = [
    ('Uploading Image', Icons.cloud_upload_rounded),
    ('Enhancing Retina', Icons.auto_fix_high_rounded),
    ('Extracting Blood Vessels', Icons.bloodtype_rounded),
    ('Detecting Lesions', Icons.search_rounded),
    ('Running Deep Learning Model', Icons.psychology_rounded),
    ('Generating Diagnosis', Icons.medical_information_rounded),
    ('Preparing Report', Icons.description_rounded),
  ];

  int _currentStep = 0;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _runAnalysis();
  }

  Future<void> _runAnalysis() async {
    for (var i = 0; i < _steps.length; i++) {
      if (!mounted) return;
      setState(() {
        _currentStep = i;
        _progress = (i + 1) / _steps.length;
      });
      await Future<void>.delayed(
        Duration(milliseconds: AppConfig.aiProcessingStepDurationMs),
      );
    }

    final patient = ref.read(selectedPatientProvider);
    final imagePath = ref.read(analysisImagePathProvider);
    final repo = ref.read(scanRepositoryProvider);

    final result = await repo.analyzeScan(
      patientId: patient?.id ?? 'p-guest',
      patientName: patient?.name ?? 'Guest Patient',
      imagePath: imagePath,
    );

    ref.read(currentScanResultProvider.notifier).state = result;

    if (mounted) {
      context.go('/results/${result.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkModeProvider);
    final step = _steps[_currentStep];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [AppColors.darkBackground, const Color(0xFF0F172A)]
                : [const Color(0xFFEFF6FF), AppColors.background],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.psychology_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .shimmer(duration: 2000.ms, color: Colors.white30)
                    .then()
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      end: const Offset(1.05, 1.05),
                      duration: 1500.ms,
                    ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'AI Analysis in Progress',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Our deep learning model is analyzing the retinal image',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxl),
                GlassCard(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: _progress),
                          duration: 400.ms,
                          builder: (context, value, _) {
                            return LinearProgressIndicator(
                              value: value,
                              minHeight: 8,
                              backgroundColor: AppColors.border,
                              valueColor: const AlwaysStoppedAnimation(
                                AppColors.primary,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '${(_progress * 100).toInt()}% Complete',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Expanded(
                  child: ListView.builder(
                    itemCount: _steps.length,
                    itemBuilder: (context, index) {
                      final s = _steps[index];
                      final isActive = index == _currentStep;
                      final isDone = index < _currentStep;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: 300.ms,
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isDone
                                    ? AppColors.accent
                                    : isActive
                                        ? AppColors.primary
                                        : (isDark
                                            ? AppColors.darkSurfaceElevated
                                            : AppColors.border),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isDone ? Icons.check_rounded : s.$2,
                                color: isDone || isActive
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                s.$1,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: isActive || isDone
                                          ? null
                                          : AppColors.textSecondary,
                                      fontWeight: isActive
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                              ),
                            ),
                            if (isActive)
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ).animate(onPlay: (c) => c.repeat()).rotate(),
                          ],
                        ),
                      ).animate(delay: (index * 50).ms).fadeIn().slideX(
                            begin: 0.05,
                            end: 0,
                          );
                    },
                  ),
                ),
                Text(
                  step.$1,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                      ),
                ).animate(key: ValueKey(_currentStep)).fadeIn().slideY(
                      begin: 0.2,
                      end: 0,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
