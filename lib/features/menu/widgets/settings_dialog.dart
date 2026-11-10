import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/purchases/purchase_service.dart';
import '../../../core/services/storage_service.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  final StorageService _storage = StorageService();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '⚙️ SETTINGS ⚙️',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Sound Effects'),
              value: _storage.isSoundEnabled,
              activeTrackColor: AppColors.primary,
              onChanged: (val) {
                setState(() => _storage.toggleSound(val));
              },
            ),
            SwitchListTile(
              title: const Text('Background Music'),
              value: _storage.isMusicEnabled,
              activeTrackColor: AppColors.primary,
              onChanged: (val) {
                setState(() => _storage.toggleMusic(val));
              },
            ),
            SwitchListTile(
              title: const Text('Vibration Haptics'),
              value: _storage.isVibrationEnabled,
              activeTrackColor: AppColors.primary,
              onChanged: (val) {
                setState(() => _storage.toggleVibration(val));
              },
            ),
            if (kDebugMode)
              SwitchListTile(
                title: const Text('Debug Performance FPS Overlay'),
                subtitle: const Text('Shows Flutter 60 FPS frame timing graph'),
                value: _storage.showPerformanceOverlay,
                activeTrackColor: AppColors.accent,
                onChanged: (val) {
                  setState(() => _storage.togglePerformanceOverlay(val));
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.restore, color: AppColors.primary),
              title: const Text('Restore Purchases'),
              onTap: () => PurchaseService().restorePurchases(context),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
              title: const Text('Privacy Policy'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening Privacy Policy...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: AppColors.textSecondary),
              title: const Text('Car Wash & Repair v1.0.0'),
              subtitle: Text(_storage.hasRemovedAds ? 'Ad-Free Version Owned' : 'Free Version'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
