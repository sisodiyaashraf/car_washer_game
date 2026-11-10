# Car Wash & Repair 🚗🧼🛠️

A casual 2D mobile game built with Flutter (Android-first) featuring finger-scrub washing, garage damage repair, custom spray painting, vector decals, wheel rim customization, shop upgrades, daily rewards, and AdMob integration.

---

## 🏗️ Project Architecture & Structure

```
lib/
├── core/
│   ├── ads/              # AdMob configuration, frequency policy & adaptive banner widget
│   ├── constants/        # App colors, grid resolution & game constants
│   ├── particles/        # 60 FPS object-pooled particle engine (bubbles, splash, sparks, shine)
│   ├── purchases/        # In-App Purchase service ("Remove Ads" non-consumable)
│   ├── services/         # AudioService, HapticsService, StorageService (versioned persistence)
│   └── theme/            # Material 3 theme & smooth page route transitions
├── data/
│   ├── models/           # Data models: VehicleDef, RepairSpotDef, WashToolDef, UpgradeDef, DecalDef
│   └── repositories/     # Data repositories for vehicles, tools, upgrades & customization
├── features/
│   ├── game/             # GameController, painters, screens and views (Wash, Repair, Paint, Customization, Preview, Done)
│   ├── garage/           # Dual-tab Vehicles & Tool Upgrades shop screen
│   └── menu/             # Animated Main Menu screen, Daily Reward dialog & Settings dialog
└── main.dart             # App entry point with portrait lock, zone error logging & lifecycle observer
```

---

## 🚀 How to Run

1. **Prerequisites**: Ensure Flutter SDK (3.10+) and Android Studio / SDK are installed.
2. **Fetch Dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run Dev / Debug Build**:
   ```bash
   flutter run
   ```

---

## 📺 Switching from Test Ad IDs to Production Ad IDs

By default in debug mode (`kDebugMode`), Google's official test ad unit IDs are automatically enforced so you never load or click real ads during development.

To deploy for production release:
1. Open `lib/core/ads/ad_config.dart`.
2. Replace the placeholder IDs with your real AdMob Ad Unit IDs:
   ```dart
   static const String prodBannerAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
   static const String prodInterstitialAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
   static const String prodRewardedAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
   ```
3. Open `android/app/src/main/AndroidManifest.xml` and replace the AdMob `APPLICATION_ID` meta-data:
   ```xml
   <meta-data
       android:name="com.google.android.gms.ads.APPLICATION_ID"
       android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"/>
   ```

---

## 📦 Building a Release Bundle (AAB / APK)

1. Generate key.properties from `android/key.properties.example` (see `android/KEYSTORE_SETUP.md`).
2. Run release build command:
   ```bash
   flutter build appbundle --release
   ```
3. Output Android App Bundle is generated at:
   `build/app/outputs/bundle/release/app-release.aab`

---

## 🎨 Audio & Artwork Credits

- **Artwork**: 100% original CustomPainter vector paths for 6 vehicles (*Hatchback, Sports Car, Pickup Truck, Police Car, Monster Truck, Biplane*), decals (*Stripes, Flames, Racing #07, Stars, Camo, Checkered Flag*), and 4 rim styles.
- **Audio Effects**: Original synthesized audio hooks under **Creative Commons Zero (CC0 1.0 Universal / Public Domain)**. See `assets/audio/CREDITS.md` for full breakdown.
