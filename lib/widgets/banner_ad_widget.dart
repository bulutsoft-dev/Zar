import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_config.dart';

/// Banner reklam widget'ı - Sabit yükseklikte, yüklenene kadar boş alan gösterir
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _loadFailed = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    if (_retryCount >= _maxRetries) {
      debugPrint('Banner ad max retries reached, giving up');
      return;
    }

    _bannerAd?.dispose();
    _bannerAd = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Banner ad loaded successfully');
          if (mounted) {
            setState(() {
              _isLoaded = true;
              _loadFailed = false;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed to load: $error');
          ad.dispose();
          _bannerAd = null;
          _retryCount++;
          
          if (mounted) {
            setState(() {
              _loadFailed = true;
            });
            
            // 5 saniye sonra tekrar dene
            if (_retryCount < _maxRetries) {
              Future.delayed(const Duration(seconds: 5), () {
                if (mounted) {
                  _loadBannerAd();
                }
              });
            }
          }
        },
        onAdOpened: (ad) {
          debugPrint('Banner ad opened');
        },
        onAdClosed: (ad) {
          debugPrint('Banner ad closed');
        },
      ),
    );

    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sabit yükseklik - reklam yüklense de yüklenmese de aynı alan
    const double adHeight = 50.0;
    
    // Reklam yüklendiyse göster
    if (_isLoaded && _bannerAd != null) {
      return Container(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        alignment: Alignment.center,
        child: AdWidget(ad: _bannerAd!),
      );
    }

    // Reklam yüklenmediyse veya başarısız olduysa - sadece boş alan göster (yanıp sönme yok)
    return const SizedBox(height: adHeight);
  }
}
