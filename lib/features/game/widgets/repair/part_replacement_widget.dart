import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

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
        width: 50,
        height: 50,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.success),
        child: const Icon(Icons.check, color: Colors.white, size: 28),
      );
    }

    return DragTarget<String>(
      onAcceptWithDetails: (details) {
        if (details.data == 'correct_part') {
          widget.onCompleteStep();
        } else {
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
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _wrongPartDropped ? AppColors.error : AppColors.secondary,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Icon(
            _wrongPartDropped ? Icons.close : Icons.build_circle,
            color: Colors.white,
            size: 26,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.cardBg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDraggablePart('wrong_part_1', Icons.settings, Colors.blue),
          _buildDraggablePart('correct_part', Icons.check_circle_outline, Colors.green),
          _buildDraggablePart('wrong_part_2', Icons.build, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildDraggablePart(String data, IconData icon, Color color) {
    return Draggable<String>(
      data: data,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.85),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
          ),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
      ),
      childWhenDragging: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade300),
      ),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
