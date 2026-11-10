import 'dart:math';
import 'package:flutter/material.dart';

enum ParticleType { soap, water, spark, smoke, shine }

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
        vx = (random.nextDouble() - 0.5) * 30;
        vy = (random.nextDouble() - 0.5) * 30;
        radius = random.nextDouble() * 10 + 6;
        maxLifespan = random.nextDouble() * 0.8 + 0.6;
        break;
      case ParticleType.water:
        vx = (random.nextDouble() - 0.5) * 60;
        vy = random.nextDouble() * 40 + 20;
        radius = random.nextDouble() * 5 + 3;
        maxLifespan = random.nextDouble() * 0.5 + 0.3;
        break;
      case ParticleType.spark:
        vx = (random.nextDouble() - 0.5) * 120;
        vy = (random.nextDouble() - 0.5) * 120;
        radius = random.nextDouble() * 4 + 2;
        maxLifespan = random.nextDouble() * 0.4 + 0.2;
        break;
      case ParticleType.smoke:
        vx = (random.nextDouble() - 0.5) * 20;
        vy = -random.nextDouble() * 30 - 10;
        radius = random.nextDouble() * 14 + 8;
        maxLifespan = random.nextDouble() * 0.9 + 0.5;
        break;
      case ParticleType.shine:
        vx = 0;
        vy = -10;
        radius = random.nextDouble() * 8 + 4;
        maxLifespan = random.nextDouble() * 0.6 + 0.4;
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

    x += vx * dt;
    y += vy * dt;
    opacity = (lifespan / maxLifespan).clamp(0.0, 1.0);

    if (type == ParticleType.smoke) {
      radius += 8 * dt; // Smoke expands
    }
  }
}

class ParticlePool {
  static const int maxParticles = 60;
  final List<Particle> _pool = List.generate(maxParticles, (_) => Particle());

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

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = p.color.withValues(alpha: p.opacity)
        ..style = (p.type == ParticleType.soap) ? PaintingStyle.stroke : PaintingStyle.fill
        ..strokeWidth = (p.type == ParticleType.soap) ? 2.0 : 1.0;

      canvas.drawCircle(Offset(p.x, p.y), p.radius, paint);
      
      if (p.type == ParticleType.soap) {
        // Bubble shine highlight
        final shinePaint = Paint()..color = Colors.white.withValues(alpha: p.opacity * 0.8);
        canvas.drawCircle(Offset(p.x - p.radius * 0.3, p.y - p.radius * 0.3), p.radius * 0.25, shinePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}
