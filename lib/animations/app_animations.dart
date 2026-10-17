import 'package:flutter_animate/flutter_animate.dart';

/// Shared animation presets for consistent motion design.
abstract final class AppAnimations {
  static const fadeIn = FadeEffect(duration: 400.ms);
  static const slideUp = SlideEffect(
    begin: Offset(0, 0.08),
    end: Offset.zero,
    duration: 400.ms,
    curve: Curves.easeOutCubic,
  );
  static const slideLeft = SlideEffect(
    begin: Offset(0.05, 0),
    end: Offset.zero,
    duration: 400.ms,
  );
  static const slideRight = SlideEffect(
    begin: Offset(-0.05, 0),
    end: Offset.zero,
    duration: 400.ms,
  );
  static const scale = ScaleEffect(
    begin: Offset(0.95, 0.95),
    end: Offset(1, 1),
    duration: 350.ms,
    curve: Curves.easeOutBack,
  );
}
