import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'ad_config.dart';

/// AdMob reklam servisi
class AdService {
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialLoading = false;
  
  static AppOpenAd? _appOpenAd;
  static bool _isAppOpenAdLoading = false;
  static bool _isAppOpenAdShowing = false;
  static int _appOpenAdRetryCount = 0;
  static const int _maxRetries = 3;
  
  /// Google Mobile Ads SDK'yı başlat
  static Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
      debugPrint('AdMob SDK initialized');
    } catch (e) {
      debugPrint('AdMob SDK initialization failed: $e');
    }
  }
  
  // ==================== APP OPEN AD ====================
  
  /// App Open reklamı yükle (retry mekanizması ile)
  static Future<void> loadAppOpenAd({bool isRetry = false}) async {
    if (_isAppOpenAdLoading || _appOpenAd != null) {
      return;
    }
    
    if (!isRetry) {
      _appOpenAdRetryCount = 0;
    }
    
    if (_appOpenAdRetryCount >= _maxRetries) {
      debugPrint('App Open ad max retries reached, giving up');
      return;
    }
    
    _isAppOpenAdLoading = true;
    
    await AppOpenAd.load(
      adUnitId: AdConfig.appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('App Open ad loaded successfully');
          _appOpenAd = ad;
          _isAppOpenAdLoading = false;
          _appOpenAdRetryCount = 0;
        },
        onAdFailedToLoad: (error) {
          debugPrint('App Open ad failed to load: $error');
          _appOpenAd = null;
          _isAppOpenAdLoading = false;
          _appOpenAdRetryCount++;
          
          // Retry after delay
          if (_appOpenAdRetryCount < _maxRetries) {
            Future.delayed(const Duration(seconds: 2), () {
              loadAppOpenAd(isRetry: true);
            });
          }
        },
      ),
    );
  }
  
  /// App Open reklamı göster
  static Future<bool> showAppOpenAd({VoidCallback? onAdDismissed}) async {
    if (_appOpenAd == null) {
      debugPrint('App Open ad not loaded');
      onAdDismissed?.call();
      return false;
    }
    
    if (_isAppOpenAdShowing) {
      debugPrint('App Open ad already showing');
      return false;
    }
    
    _isAppOpenAdShowing = true;
    
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        debugPrint('App Open ad showed');
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('App Open ad dismissed');
        _isAppOpenAdShowing = false;
        ad.dispose();
        _appOpenAd = null;
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('App Open ad failed to show: $error');
        _isAppOpenAdShowing = false;
        ad.dispose();
        _appOpenAd = null;
        onAdDismissed?.call();
      },
    );
    
    await _appOpenAd!.show();
    return true;
  }
  
  /// App Open reklamın yüklü olup olmadığını kontrol et
  static bool get isAppOpenAdReady => _appOpenAd != null;
  
  // ==================== INTERSTITIAL AD ====================
  
  /// Interstitial (geçiş) reklamı yükle
  static Future<void> loadInterstitialAd() async {
    if (_isInterstitialLoading || _interstitialAd != null) {
      return;
    }
    
    _isInterstitialLoading = true;
    
    await InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('Interstitial ad loaded successfully');
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('Interstitial ad dismissed');
              ad.dispose();
              _interstitialAd = null;
              // Yeni reklam yükle
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('Interstitial ad failed to show: $error');
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialLoading = false;
            },
            onAdShowedFullScreenContent: (ad) {
              debugPrint('Interstitial ad showed');
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed to load: $error');
          _interstitialAd = null;
          _isInterstitialLoading = false;
        },
      ),
    );
  }
  
  /// Interstitial reklamı göster
  static Future<bool> showInterstitialAd() async {
    if (_interstitialAd != null) {
      debugPrint('Showing interstitial ad');
      await _interstitialAd!.show();
      return true;
    } else {
      debugPrint('Interstitial ad not loaded, loading now...');
      await loadInterstitialAd();
      return false;
    }
  }
  
  /// Interstitial reklamın yüklü olup olmadığını kontrol et
  static bool get isInterstitialReady => _interstitialAd != null;
  
  /// Kaynakları temizle
  static void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _appOpenAd?.dispose();
    _appOpenAd = null;
  }
}
