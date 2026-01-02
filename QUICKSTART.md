# 🎲 Zar Uygulaması - Hızlı Başlangıç

## Uygulama Hakkında

Bu basit ve kullanıcı dostu zar atma uygulaması Flutter ile geliştirilmiştir. Uygulama sadece Android cihazlar için tasarlanmıştır.

## 🚀 Hızlı Kurulum

### 1. Flutter Kurulumu

Eğer Flutter yüklü değilse:

**Windows:**
```bash
# Flutter SDK'yı indirin ve çıkartın
# PATH'e ekleyin
```

**macOS/Linux:**
```bash
# Flutter SDK'yı indirin ve çıkartın
export PATH="$PATH:`pwd`/flutter/bin"
```

Flutter'ı kontrol edin:
```bash
flutter doctor
```

### 2. Projeyi Çalıştırma

```bash
# Bağımlılıkları yükleyin
flutter pub get

# Android cihaz/emülatör bağlayın
# Uygulamayı çalıştırın
flutter run
```

### 3. APK Oluşturma

**Debug APK (Test için):**
```bash
flutter build apk --debug
# APK konumu: build/app/outputs/flutter-apk/app-debug.apk
```

**Release APK (Yayın için):**
```bash
flutter build apk --release
# APK konumu: build/app/outputs/flutter-apk/app-release.apk
```

## 📱 Nasıl Kullanılır?

### Adım 1: Uygulama Açılışı
- Uygulama açıldığında 2 saniye splash screen gösterilir
- Otomatik olarak ana ekrana geçiş yapılır

### Adım 2: Zar Sayısı Seçimi
- Ekranın üst kısmında 1'den 6'ya kadar sayıları göreceksiniz
- Kaç tane zar atmak istediğinizi seçin
- Seçiminiz mavi renkle vurgulanır

### Adım 3: Zar Atma
- "Zar At" butonuna tıklayın
- Zarlar 1 saniye boyunca animasyonlu şekilde döner
- Sonuç ekranda gösterilir

### Adım 4: Tekrar Atma
- İstediğiniz zaman tekrar "Zar At" butonuna basabilirsiniz
- Farklı zar sayısı seçerek tekrar deneyebilirsiniz

## 🎯 Özellikler

✅ 1-6 arası zar sayısı seçimi
✅ Animasyonlu zar atma
✅ Gerçekçi zar görünümü (nokta desenleri)
✅ Basit ve anlaşılır arayüz
✅ Hızlı ve akıcı performans
✅ Login/kayıt gerektirmeyen
✅ İnternet bağlantısı gerektirmeyen

## 🎨 Ekran Görünümleri

### Splash Screen
- Mavi arka plan
- Zar simgesi
- "ZAR" yazısı
- Yükleme animasyonu

### Ana Ekran
- Zar sayısı seçici (üstte)
- Zar görünümleri (ortada)
- "Zar At" butonu (altta)

## ⚙️ Teknik Detaylar

- **Platform:** Android (SDK 21+)
- **Framework:** Flutter
- **Dil:** Dart
- **UI:** Material Design 3

## 🔧 Sorun Giderme

### "Flutter not found" hatası
```bash
# Flutter SDK'nın PATH'te olduğundan emin olun
export PATH="$PATH:/path/to/flutter/bin"
```

### "Android SDK not found" hatası
```bash
# Android SDK'yı yükleyin veya flutter doctor ile kontrol edin
flutter doctor
```

### Build hatası
```bash
# Cache'i temizleyin ve tekrar deneyin
flutter clean
flutter pub get
flutter build apk
```

## 📞 Destek

Sorun yaşıyorsanız veya öneriniz varsa:
- GitHub Issues: Proje repository'sindeki Issues bölümünü kullanın
- Dokümantasyon: DEVELOPER_NOTES.md dosyasına bakın
- Ekran akışı: SCREEN_FLOW.md dosyasına bakın

## 📝 Notlar

- Uygulama sadece Android için yapılandırılmıştır
- iOS desteği yoktur
- Veri kaydedilmez (her açılışta sıfırdan başlar)
- İnternet bağlantısı gerektirmez
- Login/kayıt sistemi yoktur

## 🎓 Geliştirici Bilgileri

Daha fazla teknik detay için:
- `DEVELOPER_NOTES.md` - Teknik mimari ve kod yapısı
- `SCREEN_FLOW.md` - Ekran akışı ve UI detayları
- `lib/main.dart` - Ana kaynak kod dosyası

---

**İyi eğlenceler! 🎲🎲🎲**
