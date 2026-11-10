# Flutter Keep Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.provider.** { *; }

# Flutter Play Store Deferred Components / SplitCompat
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Google Mobile Ads (AdMob) Keep Rules
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# In-App Purchase Keep Rules
-keep class com.android.billingclient.api.** { *; }
-dontwarn com.android.billingclient.api.**
