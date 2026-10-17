import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/services/app_providers.dart';
import '../../../widgets/buttons/app_buttons.dart';
import '../../../widgets/inputs/custom_inputs.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  final _picker = ImagePicker();
  XFile? _capturedImage;
  bool _aligned = false;
  bool _ledOn = true;
  double _quality = 0.0;
  String _instruction = 'Position the retina within the circular guide';

  @override
  void initState() {
    super.initState();
    _simulateAlignment();
  }

  void _simulateAlignment() {
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _aligned = true;
          _quality = 0.87;
          _instruction = 'Perfect alignment! Ready to capture.';
        });
      }
    });
  }

  Future<void> _capture() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 90,
    );
    if (image != null && mounted) {
      setState(() => _capturedImage = image);
      ref.read(analysisImagePathProvider.notifier).state = image.path;
    }
  }

  Future<void> _pickFromGallery() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      setState(() => _capturedImage = image);
      ref.read(analysisImagePathProvider.notifier).state = image.path;
    }
  }

  void _proceedToAnalysis() {
    context.push('/ai-processing');
  }

  @override
  Widget build(BuildContext context) {
    final patient = ref.watch(selectedPatientProvider);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          patient?.name ?? 'Retina Capture',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          StatusBadge(
            label: _ledOn ? 'LED ON' : 'LED OFF',
            color: _ledOn ? AppColors.accent : AppColors.textSecondary,
            icon: Icons.lightbulb_rounded,
          ),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildPreview(size),
          _buildOverlay(),
          _buildTopIndicators(),
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildPreview(Size size) {
    if (_capturedImage != null) {
      return Image.file(
        File(_capturedImage!.path),
        fit: BoxFit.cover,
        width: size.width,
        height: size.height,
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            Color(0xFF1A0A0A),
            Color(0xFF0D0505),
            Colors.black,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.remove_red_eye_rounded,
          size: 120,
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return CustomPaint(
      painter: _RetinaOverlayPainter(aligned: _aligned),
      child: const SizedBox.expand(),
    );
  }

  Widget _buildTopIndicators() {
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 64,
      left: AppSpacing.md,
      right: AppSpacing.md,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _IndicatorChip(
                  label: 'Alignment',
                  value: _aligned ? 'Aligned' : 'Adjusting',
                  color: _aligned ? AppColors.accent : AppColors.warning,
                  icon: Icons.center_focus_strong_rounded,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _IndicatorChip(
                  label: 'Quality',
                  value: '${(_quality * 100).toInt()}%',
                  color: _quality > 0.7 ? AppColors.accent : AppColors.warning,
                  icon: Icons.high_quality_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _IndicatorChip(
            label: 'AI Status',
            value: _aligned ? 'Ready' : 'Waiting',
            color: _aligned ? AppColors.primary : AppColors.textSecondary,
            icon: Icons.psychology_rounded,
            fullWidth: true,
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Text(
              _instruction,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).fade(
                begin: 0.8,
                end: 1,
                duration: 1500.ms,
              ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: _capturedImage != null
            ? Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Retake',
                      icon: Icons.refresh_rounded,
                      onPressed: () => setState(() => _capturedImage = null),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Analyze',
                      icon: Icons.auto_awesome_rounded,
                      onPressed: _proceedToAnalysis,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ControlButton(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    onTap: _pickFromGallery,
                  ),
                  _CaptureButton(onTap: _capture, enabled: _aligned),
                  _ControlButton(
                    icon: Icons.flip_camera_ios_rounded,
                    label: 'Flip',
                    onTap: () {},
                  ),
                ],
              ),
      ),
    );
  }
}

class _IndicatorChip extends StatelessWidget {
  const _IndicatorChip({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    this.fullWidth = false,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 10,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  const _CaptureButton({required this.onTap, required this.enabled});

  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled ? Colors.white : Colors.white38,
            width: 4,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: enabled ? AppColors.primary : Colors.white24,
            ),
          ),
        ),
      ),
    ).animate(target: enabled ? 1 : 0).scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          duration: 300.ms,
        );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _RetinaOverlayPainter extends CustomPainter {
  _RetinaOverlayPainter({required this.aligned});

  final bool aligned;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 40);
    final radius = size.width * 0.35;

    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.6);
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCircle(center: center, radius: radius))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, overlayPaint);

    final ringPaint = Paint()
      ..color = aligned ? AppColors.accent : Colors.white54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, ringPaint);

    final crosshairPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(center.dx - 20, center.dy),
      Offset(center.dx + 20, center.dy),
      crosshairPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - 20),
      Offset(center.dx, center.dy + 20),
      crosshairPaint,
    );

    for (var i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final tickStart = Offset(
        center.dx + (radius - 15) * math.cos(angle),
        center.dy + (radius - 15) * math.sin(angle),
      );
      final tickEnd = Offset(
        center.dx + (radius + 5) * math.cos(angle),
        center.dy + (radius + 5) * math.sin(angle),
      );
      canvas.drawLine(tickStart, tickEnd, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RetinaOverlayPainter old) =>
      old.aligned != aligned;
}
