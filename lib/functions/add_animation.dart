import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';

const Duration defaultDurationMs = Duration(milliseconds: 600); // [ms]

class AnimationConfig {
  final Duration duration;
  final Curve curve;
  final Duration delay;

  const AnimationConfig({
    this.duration = defaultDurationMs,
    this.curve = Curves.easeInOut,
    this.delay = Duration.zero,
  });
}

class FadeConfig extends AnimationConfig {
  final double begin;
  final double end;

  const FadeConfig({
    this.begin = 0.0,
    this.end = 1.0,
    super.duration,
    super.curve,
    super.delay,
  });
}

class ScaleConfig extends AnimationConfig {
  final Offset begin;
  final Offset end;

  const ScaleConfig({
    required this.begin,
    this.end = const Offset(1, 1),
    super.duration,
    super.curve,
    super.delay,
  });
}

class RotateConfig extends AnimationConfig {
  final double begin;
  final double end;

  const RotateConfig({
    required this.begin,
    this.end = 0.0,
    super.duration,
    super.curve,
    super.delay,
  });
}

class MoveConfig extends AnimationConfig {
  final Offset begin;
  final Offset end;

  const MoveConfig({
    required this.begin,
    this.end = Offset.zero,
    super.duration,
    super.curve,
    super.delay,
  });
}

class MoveYConfig extends AnimationConfig {
  final double begin;
  final double end;

  const MoveYConfig({
    required this.begin,
    this.end = 0.0,
    super.duration,
    super.curve = Curves.bounceOut,
    super.delay,
  });
}

class SlideConfig extends AnimationConfig {
  final Offset begin;
  final Offset end;

  const SlideConfig({
    required this.begin,
    this.end = Offset.zero,
    super.duration,
    super.curve = Curves.easeOutCubic,
    super.delay,
  });
}

class ShakeConfig extends AnimationConfig {
  final Offset? offset;
  final double? rotation;
  final double hz;

  const ShakeConfig({
    this.offset,
    this.rotation,
    this.hz = 15,
    super.duration,
    super.curve,
    super.delay,
  });
}

Animate applyFade(Animate anim, FadeConfig config) {
  return anim.fade(
    begin: config.begin,
    end: config.end,
    duration: config.duration,
    curve: config.curve,
    delay: config.delay,
  );
}

Animate applyMoveY(Animate anim, MoveYConfig config) {
  return anim.moveY(
    begin: config.begin,
    end: config.end,
    duration: config.duration,
    curve: config.curve,
    delay: config.delay,
  );
}

Animate applyMove(Animate anim, MoveConfig config) {
  return anim.move(
    begin: config.begin,
    end: config.end,
    duration: config.duration,
    curve: config.curve,
    delay: config.delay,
  );
}

Animate applyScale(Animate anim, ScaleConfig config) {
  return anim.scale(
    begin: config.begin,
    end: config.end,
    duration: config.duration,
    curve: config.curve,
    delay: config.delay,
  );
}

Animate applyRotate(Animate anim, RotateConfig config) {
  return anim.rotate(
    begin: config.begin,
    end: config.end,
    duration: config.duration,
    curve: config.curve,
    delay: config.delay,
  );
}

Animate applySlide(Animate anim, SlideConfig config) {
  return anim.slide(
    begin: config.begin,
    end: config.end,
    duration: config.duration,
    curve: config.curve,
    delay: config.delay,
  );
}

Animate applyShake(Animate anim, ShakeConfig config) {
  return anim.shake(
    offset: config.offset,
    rotation: config.rotation,
    hz: config.hz,
    duration: config.duration,
    curve: config.curve,
    delay: config.delay,
  );
}

Widget addAnimation({
  required Widget widget,
  bool? withFade = true,

  // Visual clarity
  FadeConfig? fade = const FadeConfig(),
  // Spatial placement (translation)
  SlideConfig? slide,
  MoveYConfig? moveY,
  MoveConfig? move,
  // Size & orientation
  ScaleConfig? scale,
  RotateConfig? rotate,
  // Attention / feedback
  ShakeConfig? shake,
}) {
  Animate anim = widget.animate();

  // Visual clarity first
  // The widget should exist before it moves
  if (withFade! && fade != null) {
    anim = applyFade(anim, fade);
  }

  // Spatial placement (translations)
  // Position the widget in space
  if (slide != null) {
    anim = applySlide(anim, slide);
  }

  if (moveY != null) {
    anim = applyMoveY(anim, moveY);
  }

  if (move != null) {
    anim = applyMove(anim, move);
  }

  // Size & orientation
  // Transform around the final position
  if (scale != null) {
    anim = applyScale(anim, scale);
  }

  if (rotate != null) {
    anim = applyRotate(anim, rotate);
  }

  // Attention grabbers (last)
  // Emphasis should never affect layout perception
  if (shake != null) {
    anim = applyShake(anim, shake);
  }

  return anim;
}
