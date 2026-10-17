import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';

class UploadWidget extends StatelessWidget {
  const UploadWidget({
    super.key,
    this.onTap,
    this.label = 'Upload Retina Image',
    this.subtitle = 'Tap to select from gallery or drag & drop',
  });

  final VoidCallback? onTap;
  final String label;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xl,
            horizontal: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 2,
            ),
            color: AppColors.primary.withValues(alpha: 0.04),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_upload_rounded,
                  color: AppColors.primary,
                  size: 32,
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
                    begin: 0,
                    end: -4,
                    duration: 1200.ms,
                  ),
              const SizedBox(height: AppSpacing.md),
              Text(label, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
