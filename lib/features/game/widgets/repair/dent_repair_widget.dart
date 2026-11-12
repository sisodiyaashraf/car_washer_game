import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/asset_paths.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/haptics_service.dart';

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
  late AnimationController _swingController;
  late Animation<double> _swingAngle;

  @override
  void initState() {
    super.initState();
    _swingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _swingAngle = Tween<double>(begin: 0.0, end: -0.6).animate(
      CurvedAnimation(parent: _swingController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _swingController.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticsService().mediumImpact();
    AudioService().playHammerHit();
    _swingController.forward(from: 0.0).then((_) => _swingController.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final isRepaired = widget.hitsRemaining <= 0;

    return AnimatedBuilder(
      animation: _swingController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _swingAngle.value,
          child: GestureDetector(
            onTap: isRepaired ? null : _handleTap,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isRepaired ? AppColors.success : AppColors.error,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: (isRepaired ? AppColors.success : AppColors.error).withValues(alpha: 0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: isRepaired
                  ? const Icon(Icons.check, color: Colors.white, size: 28)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AssetPaths.toolIcon('hammer'),
                          width: 26,
                          height: 26,
                          errorBuilder: (c, e, s) => const Icon(Icons.hardware, color: Colors.white, size: 22),
                        ),
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
      },
    );
  }
}
