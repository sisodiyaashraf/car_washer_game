import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/storage_service.dart';
import '../controllers/game_controller.dart';

class TutorialHintWidget extends StatefulWidget {
  final GamePhase phase;

  const TutorialHintWidget({super.key, required this.phase});

  @override
  State<TutorialHintWidget> createState() => _TutorialHintWidgetState();
}

class _TutorialHintWidgetState extends State<TutorialHintWidget> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String get _hintText {
    if (widget.phase == GamePhase.washSoap) return 'Swipe finger over car to apply soap foam!';
    if (widget.phase == GamePhase.washRinse) return 'Swipe spray hose to rinse off the foam!';
    if (widget.phase == GamePhase.repair) return 'Tap damaged markers to perform repairs!';
    return 'Customize your car with colors & decals!';
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed || StorageService().hasCompletedTutorial) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Row(
        children: [
          ScaleTransition(
            scale: Tween<double>(begin: 0.85, end: 1.15).animate(_pulseController),
            child: const Icon(Icons.touch_app, color: Colors.black87, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _hintText,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 13),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20, color: Colors.black54),
            onPressed: () {
              setState(() => _dismissed = true);
              StorageService().completeTutorial();
            },
          ),
        ],
      ),
    );
  }
}
