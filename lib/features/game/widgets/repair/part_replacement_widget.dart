import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/asset_paths.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/haptics_service.dart';

class PartReplacementWidget extends StatefulWidget {
  final int hitsRemaining;
  final VoidCallback onCompleteStep;

  const PartReplacementWidget({
    super.key,
    required this.hitsRemaining,
    required this.onCompleteStep,
  });

  @override
  State<PartReplacementWidget> createState() => _PartReplacementWidgetState();
}

class _PartReplacementWidgetState extends State<PartReplacementWidget> {
  bool _wrongPartDropped = false;

  @override
  Widget build(BuildContext context) {
    final isRepaired = widget.hitsRemaining <= 0;

    if (isRepaired) {
      return Container(
        width: 54,
        height: 54,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.success),
        child: const Icon(Icons.check, color: Colors.white, size: 28),
      );
    }

    return DragTarget<String>(
      onAcceptWithDetails: (details) {
        if (details.data == 'correct_part') {
          AudioService().playPartSnap();
          HapticsService().mediumImpact();
          widget.onCompleteStep();
        } else {
          AudioService().playWrongPartBuzz();
          HapticsService().successPattern();
          setState(() {
            _wrongPartDropped = true;
          });
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) setState(() => _wrongPartDropped = false);
          });
        }
      },
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _wrongPartDropped ? AppColors.error : AppColors.secondary,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 8)],
          ),
          child: Center(
            child: Image.asset(
              AssetPaths.toolIcon('spark_plug'),
              width: 32,
              height: 32,
              errorBuilder: (c, e, s) => Icon(_wrongPartDropped ? Icons.close : Icons.build_circle, color: Colors.white, size: 26),
            ),
          ),
        );
      },
    );
  }
}

class PartTrayWidget extends StatelessWidget {
  const PartTrayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDraggablePart('wrong_part_1', 'battery', AppColors.primary),
          _buildDraggablePart('correct_part', 'spark_plug', AppColors.accent),
          _buildDraggablePart('wrong_part_2', 'hammer', AppColors.secondary),
        ],
      ),
    );
  }

  Widget _buildDraggablePart(String data, String iconName, Color color) {
    return Draggable<String>(
      data: data,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.9),
            boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 10)],
          ),
          child: Center(
            child: Image.asset(
              AssetPaths.toolIcon(iconName),
              width: 36,
              height: 36,
              errorBuilder: (c, e, s) => const Icon(Icons.build, color: Colors.white, size: 28),
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade600),
      ),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: Colors.white24, width: 2),
        ),
        child: Center(
          child: Image.asset(
            AssetPaths.toolIcon(iconName),
            width: 28,
            height: 28,
            errorBuilder: (c, e, s) => const Icon(Icons.build, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }
}
