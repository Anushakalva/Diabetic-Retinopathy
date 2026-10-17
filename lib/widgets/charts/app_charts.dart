import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/models/app_models.dart';

class RiskGauge extends StatelessWidget {
  const RiskGauge({
    super.key,
    required this.riskLevel,
    this.size = 180,
  });

  final int riskLevel;
  final double size;

  Color get _color => switch (riskLevel) {
        1 => AppColors.success,
        2 => AppColors.accent,
        3 => AppColors.warning,
        4 => const Color(0xFFF97316),
        _ => AppColors.danger,
      };

  @override
  Widget build(BuildContext context) {
    final progress = riskLevel / 5;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: 1200.ms,
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return CircularProgressIndicator(
                value: value,
                strokeWidth: 12,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation(_color),
                strokeCap: StrokeCap.round,
              );
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$riskLevel',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: _color,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              Text(
                'Risk Level',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
        );
  }
}

class ConfidenceMeter extends StatelessWidget {
  const ConfidenceMeter({
    super.key,
    required this.confidence,
  });

  final double confidence;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Confidence',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: confidence * 100),
              duration: 1000.ms,
              builder: (context, value, _) {
                return Text(
                  '${value.toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: confidence),
          duration: 1200.ms,
          curve: Curves.easeOutCubic,
          builder: (context, value, _) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 10,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            );
          },
        ),
      ],
    );
  }
}

class SeverityPieChart extends StatelessWidget {
  const SeverityPieChart({
    super.key,
    required this.distribution,
  });

  final Map<DrSeverity, int> distribution;

  Color _colorFor(DrSeverity s) => switch (s) {
        DrSeverity.none => AppColors.success,
        DrSeverity.mild => AppColors.accent,
        DrSeverity.moderate => AppColors.warning,
        DrSeverity.severe => const Color(0xFFF97316),
        DrSeverity.proliferative => AppColors.danger,
      };

  @override
  Widget build(BuildContext context) {
    final total = distribution.values.fold<int>(0, (a, b) => a + b);
    if (total == 0) {
      return const Center(child: Text('No data'));
    }

    var index = 0;
    final sections = distribution.entries
        .where((e) => e.value > 0)
        .map((e) {
          final i = index++;
          return PieChartSectionData(
            value: e.value.toDouble(),
            color: _colorFor(e.key),
            title: '${((e.value / total) * 100).round()}%',
            radius: 50,
            titleStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          );
        })
        .toList();

    return SizedBox(
      height: 180,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 40,
          sectionsSpace: 2,
          startDegreeOffset: -90,
        ),
        duration: const Duration(milliseconds: 800),
      ),
    ).animate().fadeIn(duration: 600.ms);
  }
}

class ScanTrendChart extends StatelessWidget {
  const ScanTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    final spots = [
      const FlSpot(0, 8),
      const FlSpot(1, 12),
      const FlSpot(2, 10),
      const FlSpot(3, 15),
      const FlSpot(4, 18),
      const FlSpot(5, 14),
      const FlSpot(6, 22),
    ];

    return SizedBox(
      height: 160,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 5,
            getDrawingHorizontalLine: (v) => FlLine(
              color: AppColors.border,
              strokeWidth: 1,
            ),
          ),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minY: 0,
          maxY: 25,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.2),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 800),
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }
}

class AnimatedCounter extends StatelessWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.suffix = '',
  });

  final int value;
  final TextStyle? style;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: 1200.ms,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) {
        return Text(
          '$v$suffix',
          style: style ?? Theme.of(context).textTheme.headlineMedium,
        );
      },
    );
  }
}
