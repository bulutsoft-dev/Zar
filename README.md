# Zar - Dice Rolling App

Basit bir zar atma uygulaması (Simple dice rolling application)

## Özellikler (Features)

- 1-6 arası zar sayısı seçebilme
- Tıklayarak zar atma
- Animasyonlu zar yuvarlanması
- Splash screen ile başlangıç
- Sadece Android desteği

## Kurulum (Installation)

1. Flutter SDK'yı yükleyin: https://flutter.dev/docs/get-started/install
2. Projeyi klonlayın
3. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

## Çalıştırma (Running)

Android cihaz veya emülatör bağlayın ve:

```bash
flutter run
```

## Build

Android APK oluşturmak için:

```bash
flutter build apk
```

## Uygulama Yapısı

- `lib/main.dart` - Ana uygulama kodu
  - `ZarApp` - Ana uygulama widget'ı
  - `SplashScreen` - Başlangıç ekranı
  - `DiceScreen` - Zar atma ekranı
  - `DiceWidget` - Zar görünümü widget'ı