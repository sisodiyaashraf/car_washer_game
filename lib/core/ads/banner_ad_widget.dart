import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/storage_service.dart';
import 'ad_config.dart';

class AdaptiveBannerAdWidget extends StatefulWidget {
  const AdaptiveBannerAdWidget({super.key});

  @override
  State<AdaptiveBannerAdWidget> createState() => _AdaptiveBannerAdWidgetState();
}

class _AdaptiveBannerAdWidgetState extends State<AdaptiveBannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    if (!StorageService().hasRemovedAds) {
      _loadBanner();
    }
  }

  void _loadBanner() {
    _bannerAd = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) setState(() => _isAdLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (StorageService().hasRemovedAds) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: 50, // Reserved height prevents layout jump
      color: Colors.black12,
      alignment: Alignment.center,
      child: _isAdLoaded && _bannerAd != null
          ? AdWidget(ad: _bannerAd!)
          : const Text(
              'Ad Banner Space',
              style: TextStyle(color: Colors.black38, fontSize: 12),
            ),
    );
  }
}
