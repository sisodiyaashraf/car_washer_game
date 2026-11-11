import 'package:flutter/material.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../data/models/customization_def.dart';
import '../../../data/repositories/vehicle_repository.dart';

class VehicleImageWidget extends StatelessWidget {
  final String vehicleId;
  final String imageId;
  final bool isDamaged;
  final String? paintColorName;
  final Color baseColor;
  final RimStyle rimStyle;
  final DecalType decalType;
  final Offset decalOffset;
  final double decalScale;
  final Widget? overlay;

  const VehicleImageWidget({
    super.key,
    required this.vehicleId,
    required this.imageId,
    this.isDamaged = false,
    this.paintColorName,
    required this.baseColor,
    this.rimStyle = RimStyle.classic,
    this.decalType = DecalType.none,
    this.decalOffset = const Offset(0.5, 0.45),
    this.decalScale = 1.0,
    this.overlay,
  });

  static Offset normalizedToScreen(Offset relativePos, Size size) {
    return Offset(relativePos.dx * size.width, relativePos.dy * size.height);
  }

  String get _imagePath {
    if (isDamaged) {
      return AssetPaths.vehicleDamaged(imageId);
    } else if (paintColorName != null) {
      return AssetPaths.vehiclePaint(imageId, paintColorName!);
    } else {
      return AssetPaths.vehicleClean(imageId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.0, // 2:1 Aspect ratio (600x300 / 900x450)
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                _imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // CustomPainter fallback if image fails to load
                  return CustomPaint(
                    size: size,
                    painter: VehicleRepository.buildVehiclePainter(
                      vehicleId: vehicleId,
                      bodyColor: baseColor,
                      rimStyle: rimStyle,
                      decalType: decalType,
                      decalOffset: decalOffset,
                      decalScale: decalScale,
                    ),
                  );
                },
              ),
              if (overlay != null) overlay as Widget,
            ],
          );
        },
      ),
    );
  }
}
