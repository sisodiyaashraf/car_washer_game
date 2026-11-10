import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../services/storage_service.dart';

class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  static const String removeAdsProductId = 'remove_ads';
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  void initialize() {
    _subscription?.cancel();
    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: () => _subscription?.cancel(),
      onError: (_) {},
    );
    _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    _isAvailable = await _iap.isAvailable();
  }

  void buyRemoveAds(BuildContext context) async {
    if (!_isAvailable) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Store unavailable. Please try again later.')),
        );
      }
      return;
    }

    final response = await _iap.queryProductDetails({removeAdsProductId});
    if (response.notFoundIDs.contains(removeAdsProductId) || response.productDetails.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Remove Ads product not found in store.')),
        );
      }
      return;
    }

    final productDetails = response.productDetails.first;
    final purchaseParam = PurchaseParam(productDetails: productDetails);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases(BuildContext context) async {
    try {
      await _iap.restorePurchases();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchases restored successfully!')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to restore purchases.')),
        );
      }
    }
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
        if (purchase.productID == removeAdsProductId) {
          StorageService().setRemoveAds(true);
        }
        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
        }
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
