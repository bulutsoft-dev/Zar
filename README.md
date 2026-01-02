# Zar Pro - Premium Dice Rolling App

Profesyonel ve havalı bir zar atma uygulaması (Professional dice rolling application)

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

## 🎯 Özellikler (Features)

- 🎲 1-6 arası zar sayısı seçebilme
- ✨ Premium koyu tema tasarımı
- 🎨 Gradient arka planlar ve neon efektler
- 🔄 Akıcı animasyonlu zar yuvarlanması
- 📊 Toplam değer göstergesi
- 📜 Son 5 atış geçmişi
- 💫 Profesyonel splash screen
- 📱 Modern ve kullanıcı dostu arayüz
- 📳 Dokunsal geri bildirim (Haptic feedback)
- 🌙 Tamamen koyu tema

## 🎨 UI Özellikleri

- **Premium Renk Paleti**: Koyu lacivert tonları ile kırmızı-mor gradient aksentler
- **3D Zar Görünümü**: Gölge ve ışık efektleri ile gerçekçi zarlar
- **Neon Glow Efektleri**: Butonlar ve seçili elemanlarda parlama efektleri
- **Smooth Animasyonlar**: Sayfa geçişleri ve zar atma animasyonları
- **Glassmorphism**: Yarı saydam paneller ile modern görünüm

## 📦 Kurulum (Installation)

1. Flutter SDK'yı yükleyin: https://flutter.dev/docs/get-started/install
2. Projeyi klonlayın
3. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

## 🚀 Çalıştırma (Running)

Android cihaz veya emülatör bağlayın ve:

```bash
flutter run
```

## 📱 Build

Android APK oluşturmak için:

```bash
flutter build apk
```

## 🏗️ Uygulama Yapısı

- `lib/main.dart` - Ana uygulama kodu
  - `AppColors` - Premium renk paleti
  - `ZarApp` - Ana uygulama widget'ı
  - `SplashScreen` - Animasyonlu başlangıç ekranı
  - `DiceScreen` - Ana zar atma ekranı
  - `DiceWidget` - 3D görünümlü zar widget'ı

## 🎮 Kullanım

1. Uygulama açıldığında premium splash ekranı görüntülenir
2. Ana ekranda üstten zar sayısını seçin (1-6)
3. "ZAR AT" butonuna basarak zarları atın
4. Toplam değer altın renkli göstergede görüntülenir
5. Son atışlarınız alt kısımda listelenir