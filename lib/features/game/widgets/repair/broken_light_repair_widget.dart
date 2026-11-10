import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class BrokenLightRepairWidget extends StatefulWidget {
  final int hitsRemaining;
  final VoidCallback onCompleteStep;

  const BrokenLightRepairWidget({
    super.key,
    required this.hitsRemaining,
    required this.onCompleteStep,
  });

  @override
  State<BrokenLightRepairWidget> createState() => _BrokenLightRepairWidgetState();
}

class _BrokenLightRepairWidgetState extends State<BrokenLightRepairWidget> {
  bool _isGlowing = false;

  @override
  Widget build(BuildContext context) {
    final isRepaired = widget.hitsRemaining <= 0;

    if (isRepaired || _isGlowing) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.success,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD54F).withValues(alpha: 0.8),
              blurRadius: 16,
              spreadRadius: 4,
            )
          ],
        ),
        child: const Icon(Icons.lightbulb, color: Colors.white, size: 28),
      );
    }

    return DragTarget<String>(
      onAcceptWithDetails: (details) {
        setState(() {
          _isGlowing = true;
        });
        widget.onCompleteStep();
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.deepOrange,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(Icons.lightbulb_outline, color: Colors.white, size: 26),
        );
      },
    );
  }
}
