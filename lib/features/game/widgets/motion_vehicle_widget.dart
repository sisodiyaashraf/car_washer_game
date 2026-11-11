import 'package:flutter/material.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../data/models/vehicle_def.dart';
import '../controllers/vehicle_motion.dart';
import 'vehicle_image_widget.dart';

class MotionVehicleWidget extends StatelessWidget {
  final VehicleDef vehicle;
  final VehicleMotion motion;
  final String? paintColorName;
  final bool isDamaged;
  final Widget? overlay;

  const MotionVehicleWidget({
    super.key,
    required this.vehicle,
    required this.motion,
    this.paintColorName,
    this.isDamaged = false,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stageWidth = constraints.maxWidth;
        final vehicleWidth = stageWidth * 0.92;
        final vehicleHeight = vehicleWidth / 2.0;

        // Position vehicle wheels on floor line (~61% of stage height)
        final floorY = constraints.maxHeight * 0.61 - (vehicleHeight * 0.75);
        final posX = (stageWidth / 2 - vehicleWidth / 2) + (motion.x * stageWidth * 0.5);
        final posY = floorY + motion.bodyBounce;

        final transformMatrix = Matrix4.identity()
          ..setTranslationRaw(posX, posY, 0.0)
          ..rotateZ(motion.bodyPitch);

        return Stack(
          children: [
            // Garage Door Prop (rolls up/down)
            if (motion.isGarageDoorClosed)
              Positioned(
                left: stageWidth * 0.1,
                top: 0,
                width: stageWidth * 0.8,
                height: constraints.maxHeight * 0.65,
                child: Image.asset(AssetPaths.propGarageDoor(), fit: BoxFit.cover),
              ),

            // Vehicle Layer with Matrix4 transform & RepaintBoundary
            Transform(
              transform: transformMatrix,
              child: SizedBox(
                width: vehicleWidth,
                height: vehicleHeight,
                child: RepaintBoundary(
                  child: Stack(
                    children: [
                      // Headlight Beam
                      if (motion.isHeadlightOn)
                        Positioned(
                          left: vehicle.headlightPos.dx * vehicleWidth,
                          top: vehicle.headlightPos.dy * vehicleHeight - 30,
                          child: Image.asset(
                            AssetPaths.fxHeadlightBeam(),
                            width: vehicleWidth * 0.35,
                            height: 60,
                            fit: BoxFit.fill,
                          ),
                        ),

                      // Vehicle Image Base
                      VehicleImageWidget(
                        vehicleId: vehicle.id,
                        imageId: vehicle.imageId,
                        isDamaged: isDamaged,
                        paintColorName: paintColorName,
                        baseColor: vehicle.baseColor,
                        overlay: overlay,
                      ),

                      // Animated Spinning Wheel Sprites (8% larger so it fully covers baked wheels)
                      ...List.generate(vehicle.wheelCenters.length, (idx) {
                        final center = vehicle.wheelCenters[idx];
                        final radius = vehicle.wheelRadii[idx];
                        final wheelSize = (radius * 2.0 * 1.08) * vehicleWidth;

                        final isFlat = isDamaged && idx == vehicle.flatWheelIndex;
                        final wheelPosX = center.dx * vehicleWidth - wheelSize / 2;
                        final wheelPosY = center.dy * vehicleHeight - wheelSize / 2;

                        return Positioned(
                          left: wheelPosX,
                          top: wheelPosY,
                          child: Transform.rotate(
                            angle: motion.wheelAngle,
                            child: Image.asset(
                              AssetPaths.wheelSprite(vehicle.imageId),
                              width: wheelSize,
                              height: isFlat ? wheelSize * 0.6 : wheelSize,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                            ),
                          ),
                        );
                      }),

                      // Speedlines
                      if (motion.isSpeedlineVisible)
                        Positioned(
                          left: -40,
                          top: vehicleHeight * 0.3,
                          child: Image.asset(AssetPaths.fxSpeedline(), width: 100, height: 30),
                        ),

                      // Dust Puffs at Rear Wheel
                      if (motion.isDustActive && vehicle.wheelCenters.isNotEmpty)
                        Positioned(
                          left: vehicle.wheelCenters.first.dx * vehicleWidth - 30,
                          top: vehicle.wheelCenters.first.dy * vehicleHeight - 10,
                          child: Image.asset(AssetPaths.fxDust(), width: 50, height: 40),
                        ),

                      // Honk FX
                      if (motion.isHonking)
                        Positioned(
                          left: vehicle.headlightPos.dx * vehicleWidth - 20,
                          top: vehicle.headlightPos.dy * vehicleHeight - 50,
                          child: Image.asset(AssetPaths.fxHonk(), width: 60, height: 60),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
