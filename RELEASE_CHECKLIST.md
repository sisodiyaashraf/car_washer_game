# 🚀 Play Store Release & Submission Checklist

## 1. Google Play Console Setup & Requirements
- [ ] **In-App Products Setup**: Create product ID `remove_ads` in Play Console under **Monetize -> In-app products** (Set status: Active, Type: Non-consumable). Add developer email under **License Testing** to test purchases without charge.
  - *Note*: Google Play In-App Purchase and Restoration DO NOT work from sideloaded local debug builds; you MUST test from an Internal Testing Track install.
- [ ] **Closed Testing Requirement**: New personal developer accounts created after Nov 2023 MUST run a closed test with at least **20 testers** opted in for at least **14 continuous days** before requesting Production access.
- [ ] **Privacy Policy URL**: Host a privacy policy document on GitHub Pages or developer site detailing data processed by Google AdMob and Google Play Billing.
- [ ] **Data Safety Form**:
  - **Identifiers**: Device ID & Advertising ID collected by Google Mobile Ads SDK.
  - **Financial Info**: Purchase history processed by Google Play Billing for `remove_ads`.
  - **Data Encryption**: Encrypted in transit over HTTPS.
- [ ] **Content Rating**: Complete the IARC questionnaire in Play Console.
- [ ] **Ads Declaration**: Declare **YES**, my app contains ads.

## 2. AdMob Production Cutover & UMP Consent
- [ ] Create AdMob App in Google AdMob Console.
- [ ] Create 3 Ad Units: Banner, Interstitial, and Rewarded.
- [ ] Create & publish a GDPR/UMP consent message in AdMob's **Privacy & messaging** section (the UMP consent form will not show without a published message).
- [ ] Replace placeholder IDs in `lib/core/ads/ad_config.dart` (`prodBannerAdUnitId`, `prodInterstitialAdUnitId`, `prodRewardedAdUnitId`).
- [ ] Link AdMob App to Google Play Store listing after publishing.

## 3. Store Listing Assets
- [ ] **App Icon**: 512x512 px PNG (32-bit with alpha).
- [ ] **Feature Graphic**: 1024x500 px PNG or JPEG.
- [ ] **Screenshots**: At least 2 phone screenshots (portrait 16:9 or 18:9 ratio).
- [ ] **Short Description**: "Wash, repair, paint, and customize awesome cars in this fun casual 2D game!"
- [ ] **Full Description**: Detailed gameplay overview outlining wash stages, garage repairs, custom paint, decals, and unlockable vehicles.
