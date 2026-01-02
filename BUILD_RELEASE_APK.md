# Release APK Build Guide / Release APK Derleme Kılavuzu

## 🚀 Release APK Oluşturma Adımları

### Gereksinimler
- Flutter SDK 3.0.0 veya üzeri
- Android SDK (API 21-34)
- Java JDK 17+
- Gradle 8.3

### 1. Projeyi Hazırlama

```bash
cd /path/to/Zar
flutter clean
flutter pub get
```

### 2. Release APK Oluşturma

**Basit Release Build:**
```bash
flutter build apk --release
```

**Split APKs (Daha küçük dosya boyutu):**
```bash
flutter build apk --release --split-per-abi
```

Bu komut 3 farklı APK üretir:
- `app-armeabi-v7a-release.apk` (32-bit ARM için)
- `app-arm64-v8a-release.apk` (64-bit ARM için)
- `app-x86_64-release.apk` (x86 için)

**Universal APK (Tüm cihazlar için):**
```bash
flutter build apk --release
```

### 3. APK Konumu

Build tamamlandıktan sonra APK dosyası şu konumda olacaktır:

```
build/app/outputs/flutter-apk/
├── app-release.apk (Universal APK - ~20-25 MB)
└── split_apks/ (Eğer --split-per-abi kullandıysanız)
    ├── app-armeabi-v7a-release.apk (~15 MB)
    ├── app-arm64-v8a-release.apk (~17 MB)
    └── app-x86_64-release.apk (~18 MB)
```

---

## 📦 APK Detayları

### Uygulama Bilgileri

| Özellik | Değer |
|---------|-------|
| **Uygulama Adı** | Zar |
| **Paket Adı** | com.bulutsoft.zar |
| **Versiyon** | 1.0.0 (Build 1) |
| **Min SDK** | 21 (Android 5.0 Lollipop) |
| **Target SDK** | 34 (Android 14) |
| **Compile SDK** | 34 |

### APK Özellikleri

**Universal APK (app-release.apk):**
- **Boyut:** ~20-25 MB (sıkıştırılmış)
- **Desteklenen Mimariler:** armeabi-v7a, arm64-v8a, x86_64
- **Uyumluluk:** Tüm Android cihazlar
- **Önerilen Kullanım:** Test ve genel dağıtım

**Split APKs:**
- **arm64-v8a:** Modern 64-bit ARM cihazlar (En yaygın)
- **armeabi-v7a:** Eski 32-bit ARM cihazlar
- **x86_64:** Emülatörler ve x86 cihazlar

### İmzalama

Mevcut build **debug** sertifikası ile imzalanmıştır. Production için:

```gradle
// android/app/build.gradle
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}
```

---

## 🔧 Build Optimizasyonları

### 1. ProGuard/R8 Kod Küçültme

`android/app/build.gradle` dosyasına ekleyin:

```gradle
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        signingConfig signingConfigs.release
    }
}
```

### 2. Obfuscation (Kod Gizleme)

Kodunuzu korumak için:

```bash
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

### 3. App Bundle (Play Store İçin)

Google Play Store'a yükleme için:

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

---

## 📊 Build Performans Metrikleri

### Beklenen Build Süreleri

| Build Tipi | Süre (Yaklaşık) |
|------------|------------------|
| Clean build | 2-5 dakika |
| Incremental | 30-90 saniye |
| Release APK | 3-7 dakika |
| Split APKs | 4-8 dakika |

### APK Boyutları

| APK Tipi | Boyut |
|----------|-------|
| Universal | 20-25 MB |
| arm64-v8a | 15-18 MB |
| armeabi-v7a | 14-17 MB |
| x86_64 | 16-19 MB |

---

## 🧪 APK Test Etme

### ADB ile Yükleme

```bash
# APK'yı cihaza yükle
adb install build/app/outputs/flutter-apk/app-release.apk

# Uygulamayı başlat
adb shell am start -n com.bulutsoft.zar/.MainActivity

# Logları izle
adb logcat | grep -i flutter
```

### Test Checklist

- [ ] Splash screen doğru gösteriliyor mu? (2 saniye)
- [ ] Ana ekrana geçiş otomatik mi?
- [ ] Zar sayısı seçimi çalışıyor mu? (1-6)
- [ ] Zar atma animasyonu düzgün mü?
- [ ] Zarlar rastgele değerler gösteriyor mu?
- [ ] Uygulama kapanmıyor/çökmiyor mu?
- [ ] Rotasyon değişimlerinde sorun yok mu?
- [ ] Geri butonu doğru çalışıyor mu?

---

## 🔒 Güvenlik Kontrolleri

### APK Analizi

APK'nızı analiz etmek için:

```bash
# APK içeriğini incele
unzip -l build/app/outputs/flutter-apk/app-release.apk

# APK boyutunu analiz et
flutter build apk --release --analyze-size

# APK'yı Android Studio'da analiz et
# Build > Analyze APK
```

### Güvenlik Tarama

```bash
# Flutter güvenlik taraması
flutter analyze

# Dependency audit
flutter pub outdated
```

---

## 📱 Kurulum ve Dağıtım

### Manuel Kurulum

1. APK dosyasını Android cihaza aktarın
2. Dosya yöneticisinden APK'yı açın
3. "Bilinmeyen kaynaklardan yüklemeye izin ver" seçeneğini etkinleştirin
4. Yüklemeyi onaylayın

### QR Kod ile Dağıtım

APK'yı bir sunucuya yükleyin ve QR kod oluşturun:

```
https://example.com/zar-release.apk
```

### Google Play Store

1. App Bundle oluşturun: `flutter build appbundle --release`
2. Google Play Console'a gidin
3. Yeni release oluşturun
4. AAB dosyasını yükleyin
5. Store listing bilgilerini doldurun

---

## 🐛 Sorun Giderme

### "Minimum SDK version" Hatası

```bash
# pubspec.yaml'da kontrol edin
environment:
  sdk: '>=3.0.0 <4.0.0'

# android/app/build.gradle'da kontrol edin
minSdk 21
```

### "Gradle Build Failed" Hatası

```bash
cd android
./gradlew clean
./gradlew assembleRelease --stacktrace
```

### "Out of Memory" Hatası

`android/gradle.properties` dosyasına:

```properties
org.gradle.jvmargs=-Xmx4096m -XX:MaxMetaspaceSize=1024m
```

### Build Çok Yavaş

```bash
# Gradle daemon'ı etkinleştir
echo "org.gradle.daemon=true" >> android/gradle.properties
echo "org.gradle.parallel=true" >> android/gradle.properties
echo "org.gradle.configureondemand=true" >> android/gradle.properties
```

---

## 📋 Build Komutları Özeti

```bash
# Development
flutter run

# Debug APK
flutter build apk --debug

# Release APK (Universal)
flutter build apk --release

# Release APK (Split)
flutter build apk --release --split-per-abi

# Release with obfuscation
flutter build apk --release --obfuscate --split-debug-info=build/symbols

# App Bundle
flutter build appbundle --release

# Analyze size
flutter build apk --release --analyze-size

# Clean build
flutter clean && flutter pub get && flutter build apk --release
```

---

## 📈 CI/CD Build Script

GitHub Actions için örnek:

```yaml
name: Build APK
on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.5'
      - run: flutter pub get
      - run: flutter build apk --release --split-per-abi
      - uses: actions/upload-artifact@v3
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/*.apk
```

---

## 📝 Notlar

1. **İlk Build:** İlk kez build alırken Gradle dosyalarını indireceği için daha uzun sürebilir (5-10 dakika)
2. **Cache:** Sonraki build'ler cache sayesinde daha hızlı olacaktır
3. **Split APKs:** Play Store otomatik olarak doğru APK'yı kullanıcılara dağıtır
4. **Universal APK:** Test ve manuel dağıtım için daha pratiktir
5. **Obfuscation:** Production build'lerde mutlaka kullanın

---

## 🎯 Önerilen Production Build

```bash
# 1. Temizlik
flutter clean

# 2. Dependencies
flutter pub get

# 3. Analyze
flutter analyze

# 4. Test (eğer varsa)
flutter test

# 5. Release Build
flutter build apk --release --obfuscate --split-debug-info=build/symbols --split-per-abi

# 6. Verify
ls -lh build/app/outputs/flutter-apk/
```

**Output:**
```
-rw-r--r-- 1 user user 15M app-armeabi-v7a-release.apk
-rw-r--r-- 1 user user 17M app-arm64-v8a-release.apk
-rw-r--r-- 1 user user 18M app-x86_64-release.apk
```

---

**Son Güncelleme:** 2 Ocak 2026
**Flutter Versiyonu:** 3.24.5
**Android Gradle Plugin:** 8.1.0
