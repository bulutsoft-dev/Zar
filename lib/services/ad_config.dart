import 'package:flutter/foundation.dart';

/// AdMob reklam yapılandırması
class AdConfig {
  // Debug modda test reklamları kullan
  static final bool isDebug = kDebugMode;
  
  // AdMob App ID (AndroidManifest.xml'de de tanımlı)
  static const String appId = 'ca-app-pub-9589008379442992~3210359874';
  
  // Test reklam birimleri (Google tarafından sağlanan)
  static const String testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String testAppOpenAdUnitId = 'ca-app-pub-3940256099942544/9257395921';
  
  // Gerçek reklam birimleri (AdMob'dan alınan)
  static const String realBannerAdUnitId = 'ca-app-pub-9589008379442992/2962947863';
  static const String realInterstitialAdUnitId = 'ca-app-pub-9589008379442992/4579281864';
  static const String realAppOpenAdUnitId = 'ca-app-pub-9589008379442992/8187354387';
  
  /// Banner reklam birimi ID'si
  static String get bannerAdUnitId {
    if (isDebug) {
      return testBannerAdUnitId;
    }
    return realBannerAdUnitId;
  }
  
  /// Interstitial (geçiş) reklam birimi ID'si
  static String get interstitialAdUnitId {
    if (isDebug) {
      return testInterstitialAdUnitId;
    }
    return realInterstitialAdUnitId;
  }
  
  /// App Open (uygulama açılış) reklam birimi ID'si
  static String get appOpenAdUnitId {
    if (isDebug) {
      return testAppOpenAdUnitId;
    }
    return realAppOpenAdUnitId;
  }
}
