import 'package:flutter/material.dart';
import '../../../core/ads/ad_service.dart';
import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/repositories/upgrade_repository.dart';
import '../../../data/repositories/vehicle_repository.dart';
import '../../game/screens/game_screen.dart';

class GarageScreen extends StatefulWidget {
  const GarageScreen({super.key});

  @override
  State<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final StorageService _storage = StorageService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _tryUnlockVehicle(String vehicleId, int cost) {
    if (_storage.spendCoins(cost)) {
      _storage.unlockVehicle(vehicleId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 Vehicle Unlocked!'), backgroundColor: AppColors.success),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Not enough coins!'), backgroundColor: AppColors.error),
      );
    }
  }

  void _tryBuyUpgrade(String upgradeId, int cost, int maxLevel) {
    if (_storage.buyUpgrade(upgradeId, cost, maxLevel)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚡ Upgrade Purchased!'), backgroundColor: AppColors.success),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Cannot purchase upgrade!'), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = VehicleRepository.vehicles;
    final upgrades = UpgradeRepository.upgrades;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Garage & Upgrades'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Vehicles', icon: Icon(Icons.directions_car)),
            Tab(text: 'Tool Upgrades', icon: Icon(Icons.build)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: AppColors.secondary),
                const SizedBox(width: 4),
                Text('${_storage.coins}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Vehicles Tab
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    final isUnlocked = vehicle.isUnlockedByDefault || _storage.isVehicleUnlocked(vehicle.id);
                    final isSelected = _storage.selectedVehicleId == vehicle.id;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    vehicle.name,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                if (isUnlocked)
                                  ChoiceChip(
                                    label: Text(isSelected ? 'SELECTED' : 'SELECT'),
                                    selected: isSelected,
                                    onSelected: (_) {
                                      _storage.setSelectedVehicle(vehicle.id);
                                      setState(() {});
                                    },
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Vehicle Preview
                            Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.cardBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: 220,
                                  height: 100,
                                  child: CustomPaint(
                                    painter: VehicleRepository.buildVehiclePainter(
                                      vehicleId: vehicle.id,
                                      bodyColor: vehicle.baseColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (!isUnlocked) ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _tryUnlockVehicle(vehicle.id, vehicle.unlockCost),
                                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                                      icon: const Icon(Icons.monetization_on),
                                      label: Text('${vehicle.unlockCost} Coins'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        AdService().showRewardedAd(
                                          context: context,
                                          onRewardGranted: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (_) => const GameScreen(levelNumber: 1)),
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.play_circle_outline),
                                      label: const Text('Try 1 Level (Ad)', style: TextStyle(fontSize: 11)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // Upgrades Tab
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: upgrades.length,
                  itemBuilder: (context, index) {
                    final upgrade = upgrades[index];
                    final currentLvl = _storage.getUpgradeLevel(upgrade.id);
                    final isMaxed = currentLvl >= upgrade.maxLevel;
                    final cost = upgrade.baseCost + (currentLvl * upgrade.costMultiplier);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Icon(upgrade.icon, color: Colors.white),
                        ),
                        title: Text(upgrade.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(upgrade.description),
                            const SizedBox(height: 4),
                            Text(
                              'Level: $currentLvl / ${upgrade.maxLevel}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: isMaxed ? null : () => _tryBuyUpgrade(upgrade.id, cost, upgrade.maxLevel),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                          child: Text(isMaxed ? 'MAXED' : '$cost 🪙'),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const AdaptiveBannerAdWidget(),
        ],
      ),
    );
  }
}
