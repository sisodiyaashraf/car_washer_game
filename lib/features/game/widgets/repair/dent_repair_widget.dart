import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class DentRepairWidget extends StatefulWidget {
  final int hitsRemaining;
  final VoidCallback onTap;

  const DentRepairWidget({
    super.key,
    required this.hitsRemaining,
    required this.onTap,
  });

  @override
  State<DentRepairWidget> createState() => _DentRepairWidgetState();
}

class _DentRepairWidgetState extends State<DentRepairWidget> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _shakeController.forward(from: 0.0).then((_) => _shakeController.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final isRepaired = widget.hitsRemaining <= 0;

    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.25).animate(_shakeController),
      child: GestureDetector(
        onTap: isRepaired ? null : _handleTap,
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isRepaired ? AppColors.success : AppColors.error,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: (isRepaired ? AppColors.success : AppColors.error).withValues(alpha: 0.4),
                blurRadius: 8,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isRepaired ? Icons.check : Icons.hardware,
                color: Colors.white,
                size: 22,
              ),
              if (!isRepaired)
                Text(
                  '${widget.hitsRemaining}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
