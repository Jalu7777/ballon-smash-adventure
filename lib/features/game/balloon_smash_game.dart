import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

typedef ScoreChanged = void Function(int score);
typedef GameEnded = void Function(int score);

class BalloonSmashGame extends FlameGame with TapCallbacks {
  BalloonSmashGame({
    required this.onScoreChanged,
    required this.onGameEnded,
  });

  final ScoreChanged onScoreChanged;
  final GameEnded onGameEnded;
  final Random _random = Random();
  double _spawnTimer = 0;
  double _gameTimer = 45;
  int _score = 0;
  bool _ended = false;

  int get score => _score;
  int get secondsLeft => _gameTimer.ceil().clamp(0, 45);

  @override
  Color backgroundColor() => const Color(0xFFE9FAFF);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addAll([
      _SkyGradient(size),
      _HudText(() => 'Score $_score', Vector2(18, 18)),
      _HudText(() => 'Time $secondsLeft', Vector2(18, 52)),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_ended) {
      return;
    }
    _gameTimer -= dt;
    _spawnTimer -= dt;
    if (_spawnTimer <= 0) {
      _spawnBalloon();
      _spawnTimer = max(0.35, 0.9 - (_score * 0.015));
    }
    if (_gameTimer <= 0) {
      _ended = true;
      onGameEnded(_score);
    }
  }

  void _spawnBalloon() {
    final radius = 24 + _random.nextDouble() * 22;
    final x = radius + _random.nextDouble() * max(1, size.x - radius * 2);
    final color = [
      const Color(0xFFE84855),
      const Color(0xFFFF9F1C),
      const Color(0xFF2EC4B6),
      const Color(0xFF3D5A80),
      const Color(0xFFB565A7),
    ][_random.nextInt(5)];

    add(
      BalloonComponent(
        position: Vector2(x, size.y + radius),
        radius: radius,
        color: color,
        speed: 80 + _random.nextDouble() * 130 + _score,
        onPopped: () {
          _score += radius > 42 ? 15 : 10;
          onScoreChanged(_score);
        },
      ),
    );
  }
}

class BalloonComponent extends CircleComponent with TapCallbacks {
  BalloonComponent({
    required super.position,
    required this.radius,
    required this.color,
    required this.speed,
    required this.onPopped,
  }) : super(
          radius: radius,
          anchor: Anchor.center,
          paint: Paint()..color = color,
        );

  @override
  final double radius;
  final Color color;
  final double speed;
  final VoidCallback onPopped;

  @override
  void update(double dt) {
    super.update(dt);
    y -= speed * dt;
    if (y < -radius) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final highlight = Paint()..color = Colors.white.withValues(alpha: 0.35);
    canvas.drawCircle(Offset(-radius * 0.28, -radius * 0.32), radius * 0.22, highlight);
    final stringPaint = Paint()
      ..color = const Color(0xFF415A77)
      ..strokeWidth = 2;
    canvas.drawLine(Offset.zero, Offset(0, radius + 22), stringPaint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    onPopped();
    removeFromParent();
  }
}

class _HudText extends PositionComponent {
  _HudText(this.textBuilder, Vector2 position) : super(position: position);

  final String Function() textBuilder;
  late final TextPaint _textPaint;

  @override
  Future<void> onLoad() async {
    _textPaint = TextPaint(
      style: const TextStyle(
        color: Color(0xFF17324D),
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    _textPaint.render(canvas, textBuilder(), Vector2.zero());
  }
}

class _SkyGradient extends PositionComponent {
  _SkyGradient(Vector2 size) : super(size: size);

  @override
  void render(Canvas canvas) {
    final rect = Offset.zero & Size(size.x, size.y);
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE9FAFF), Color(0xFFFFF8E7)],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }
}
