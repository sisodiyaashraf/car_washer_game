import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/particles/particle_pool.dart';
import '../../../data/models/vehicle_def.dart';
import '../../../data/repositories/vehicle_repository.dart';
import '../controllers/game_controller.dart';
import 'repair/broken_light_repair_widget.dart';
import 'repair/dent_repair_widget.dart';
import 'repair/flat_tire_repair_widget.dart';
import 'repair/part_replacement_widget.dart';
import 'repair/repair_tool_bar.dart';

class RepairView extends StatefulWidget {
  const RepairView({super.key});

  @override
  State<RepairView> createState() => _RepairViewState();
}

class _RepairViewState extends State<RepairView> with SingleTickerProviderStateMixin {
  late AnimationController _tickerController;
  final ParticlePool _particlePool = ParticlePool();

  @override
  void initState() {
    super.initState();
    _tickerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _tickerController.addListener(() {
      _particlePool.update(0.016);
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tickerController.dispose();
    super.dispose();
  }

  void _triggerSparks(Offset pos) {
    _particlePool.spawnBurst(pos, ParticleType.spark, Colors.amber, count: 12);
    _particlePool.spawnBurst(pos, ParticleType.smoke, Colors.grey, count: 6);
  }

  Widget _buildSpotWidget({
    required RepairSpotDef spot,
    required int hitsRemaining,
    required VoidCallback onHit,
    required Offset pos,
  }) {
    switch (spot.spotType) {
      case RepairSpotType.dent:
      case RepairSpotType.scratch:
        return DentRepairWidget(
          hitsRemaining: hitsRemaining,
          onTap: () {
            _triggerSparks(pos);
            onHit();
          },
        );

      case RepairSpotType.flatTire:
        return FlatTireRepairWidget(
          hitsRemaining: hitsRemaining,
          onCompleteStep: () {
            _triggerSparks(pos);
            onHit();
          },
        );

      case RepairSpotType.brokenLight:
        return BrokenLightRepairWidget(
          hitsRemaining: hitsRemaining,
          onCompleteStep: () {
            _triggerSparks(pos);
            onHit();
          },
        );

      case RepairSpotType.engine:
        return PartReplacementWidget(
          hitsRemaining: hitsRemaining,
          onCompleteStep: () {
            _triggerSparks(pos);
            onHit();
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final vehicle = controller.vehicleDef;
    final hitsRemaining = controller.repairHitsRemaining;

    final activeSpots = vehicle.repairSpots.where((s) => hitsRemaining.containsKey(s.id)).toList();
    final activeSpot = activeSpots.firstWhere(
      (s) => s.id == controller.selectedRepairSpotId,
      orElse: () => activeSpots.first,
    );

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Chip(
            avatar: Icon(Icons.handyman, size: 18, color: AppColors.accent),
            label: Text(
              'GARAGE REPAIR: Fix damaged parts!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.surface,
          ),
        ),
        Expanded(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth * 0.9;
                final height = constraints.maxHeight * 0.7;

                final damagedMap = <String, bool>{};
                for (final spot in activeSpots) {
                  damagedMap[spot.id] = (hitsRemaining[spot.id] ?? 0) <= 0;
                }

                return Stack(
                  children: [
                    // Vehicle Base
                    CustomPaint(
                      size: Size(width, height),
                      painter: VehicleRepository.buildVehiclePainter(
                        vehicleId: vehicle.id,
                        bodyColor: controller.vehiclePaintColor,
                        damagedSpots: damagedMap,
                        rimStyle: controller.selectedRimStyle,
                        decalType: controller.selectedDecal,
                        decalOffset: controller.decalOffset,
                        decalScale: controller.decalScale,
                        isCleanShine: true,
                      ),
                    ),
                    // Particles Layer
                    CustomPaint(
                      size: Size(width, height),
                      painter: ParticlePainter(particles: _particlePool.activeParticles),
                    ),
                    // Spot Interactive Hotspots
                    ...activeSpots.map((spot) {
                      final hits = hitsRemaining[spot.id] ?? 0;
                      final posX = spot.relativePosition.dx * width;
                      final posY = spot.relativePosition.dy * height;

                      return Positioned(
                        left: posX - 28,
                        top: posY - 28,
                        child: _buildSpotWidget(
                          spot: spot,
                          hitsRemaining: hits,
                          pos: Offset(posX, posY),
                          onHit: () => controller.hitRepairSpot(spot.id),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ),
        // If engine spot active, show spare parts tray
        if (activeSpot.spotType == RepairSpotType.engine && (hitsRemaining[activeSpot.id] ?? 0) > 0)
          const PartTrayWidget(),

        // Repair Tool Selector Bar
        RepairToolBar(
          repairSpots: activeSpots,
          activeSpotId: controller.selectedRepairSpotId,
          onSpotSelected: (id) => controller.selectRepairSpot(id),
        ),
      ],
    );
  }
}
