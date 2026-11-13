import 'dart:math';
import 'package:flutter/material.dart';

enum ParticleType { soap, water, spark, smoke, shine, confetti, mudFlake, streak, drip }

class Particle {
  double x = 0;
  double y = 0;
  double vx = 0;
  double vy = 0;
  double radius = 0;
  double opacity = 1.0;
  double lifespan = 0;
  double maxLifespan = 1.0;
  Color color = Colors.white;
  ParticleType type = ParticleType.soap;
  bool active = false;

  void spawn({
    required double xPos,
    required double yPos,
    required ParticleType pType,
    required Color pColor,
  }) {
    final random = Random();
    x = xPos;
    y = yPos;
    type = pType;
    color = pColor;
    opacity = 1.0;
    active = true;

    switch (pType) {
      case ParticleType.soap:
        vx = (random.nextDouble() - 0.5) * 40;
        vy = (random.nextDouble() - 0.5) * 40 - 10;
        radius = random.nextDouble() * 12 + 8;
        maxLifespan = random.nextDouble() * 0.8 + 0.5;
        break;

      case ParticleType.water:
        vx = (random.nextDouble() - 0.5) * 120 + 30;
        vy = (random.nextDouble() - 0.5) * 60 + 40;
        radius = random.nextDouble() * 6 + 4;
        maxLifespan = random.nextDouble() * 0.4 + 0.2;
        break;

      case ParticleType.streak:
        vx = random.nextDouble() * 300 + 200; // Fast pressure jet streak
        vy = (random.nextDouble() - 0.5) * 40;
        radius = random.nextDouble() * 4 + 2;
        maxLifespan = random.nextDouble() * 0.25 + 0.1;
        break;

      case ParticleType.mudFlake:
        final angle = random.nextDouble() * 2 * pi;
        final speed = random.nextDouble() * 140 + 40;
        vx = cos(angle) * speed;
        vy = sin(angle) * speed + 60;
        radius = random.nextDouble() * 6 + 3;
        maxLifespan = random.nextDouble() * 0.5 + 0.3;
        break;

      case ParticleType.drip:
        vx = (random.nextDouble() - 0.5) * 10;
        vy = random.nextDouble() * 60 + 40;
        radius = random.nextDouble() * 4 + 2;
        maxLifespan = random.nextDouble() * 0.9 + 0.5;
        break;

      case ParticleType.spark:
        final angle = random.nextDouble() * 2 * pi;
        final speed = random.nextDouble() * 160 + 60;
        vx = cos(angle) * speed;
        vy = sin(angle) * speed;
        radius = random.nextDouble() * 5 + 3;
        maxLifespan = random.nextDouble() * 0.35 + 0.15;
        break;

      case ParticleType.smoke:
        vx = (random.nextDouble() - 0.5) * 30;
        vy = -random.nextDouble() * 40 - 20;
        radius = random.nextDouble() * 16 + 10;
        maxLifespan = random.nextDouble() * 1.0 + 0.6;
        break;

      case ParticleType.shine:
        vx = 0;
        vy = -15;
        radius = random.nextDouble() * 8 + 5;
        maxLifespan = random.nextDouble() * 0.6 + 0.4;
        break;

      case ParticleType.confetti:
        vx = (random.nextDouble() - 0.5) * 200;
        vy = -random.nextDouble() * 250 - 100;
        radius = random.nextDouble() * 7 + 4;
        maxLifespan = random.nextDouble() * 1.5 + 1.0;
        break;
    }
    lifespan = maxLifespan;
  }

  void update(double dt) {
    if (!active) return;
    lifespan -= dt;
    if (lifespan <= 0) {
      active = false;
      return;
    }

    if (type == ParticleType.confetti || type == ParticleType.drip || type == ParticleType.mudFlake) {
      vy += 250 * dt; // Gravity
    }

    x += vx * dt;
    y += vy * dt;
    opacity = (lifespan / maxLifespan).clamp(0.0, 1.0);

    if (type == ParticleType.smoke) {
      radius += 12 * dt;
    }
  }
}

class ParticlePool {
  static const int maxParticles = 160; // Capped at 160 max particles
  final List<Particle> _pool = List.generate(maxParticles, (_) => Particle());

  int get capacity => maxParticles;

  void spawnBurst(Offset position, ParticleType type, Color color, {int count = 6}) {
    int spawned = 0;
    for (var particle in _pool) {
      if (!particle.active) {
        particle.spawn(
          xPos: position.dx,
          yPos: position.dy,
          pType: type,
          pColor: color,
        );
        spawned++;
        if (spawned >= count) break;
      }
    }
  }

  void update(double dt) {
    for (var particle in _pool) {
      if (particle.active) {
        particle.update(dt);
      }
    }
  }

  List<Particle> get activeParticles => _pool.where((p) => p.active).toList();
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  // Pre-allocated static Paint objects to avoid allocations in paint()
  static final Paint _fillPaint = Paint()..style = PaintingStyle.fill;
  static final Paint _strokePaint = Paint()..style = PaintingStyle.stroke;
  static final Paint _shineHighlightPaint = Paint()..style = PaintingStyle.fill..color = Colors.white;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      if (p.type == ParticleType.spark) {
        _fillPaint.color = Colors.white.withValues(alpha: p.opacity);
        canvas.drawCircle(Offset(p.x, p.y), p.radius, _fillPaint);

        _strokePaint.color = p.color.withValues(alpha: p.opacity);
        _strokePaint.strokeWidth = 1.5;
        canvas.drawCircle(Offset(p.x, p.y), p.radius * 1.5, _strokePaint);
      } else if (p.type == ParticleType.streak) {
        _fillPaint.color = p.color.withValues(alpha: p.opacity);
        canvas.drawRect(Rect.fromLTWH(p.x, p.y, p.radius * 6, p.radius), _fillPaint);
      } else if (p.type == ParticleType.confetti) {
        _fillPaint.color = p.color.withValues(alpha: p.opacity);
        canvas.drawRect(Rect.fromLTWH(p.x, p.y, p.radius * 2, p.radius), _fillPaint);
      } else if (p.type == ParticleType.soap) {
        _strokePaint.color = p.color.withValues(alpha: p.opacity);
        _strokePaint.strokeWidth = 2.5;
        canvas.drawCircle(Offset(p.x, p.y), p.radius, _strokePaint);

        _shineHighlightPaint.color = Colors.white.withValues(alpha: p.opacity * 0.8);
        canvas.drawCircle(Offset(p.x - p.radius * 0.3, p.y - p.radius * 0.3), p.radius * 0.3, _shineHighlightPaint);
      } else {
        _fillPaint.color = p.color.withValues(alpha: p.opacity);
        canvas.drawCircle(Offset(p.x, p.y), p.radius, _fillPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}
