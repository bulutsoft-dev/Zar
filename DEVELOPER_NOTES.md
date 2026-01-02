# Zar Uygulaması - Geliştirici Notları

## Proje Özeti

Bu proje, Flutter kullanılarak geliştirilmiş basit bir zar atma uygulamasıdır. Uygulama sadece Android platformu için yapılandırılmıştır.

## Uygulamanın Yapısı

### 1. Ana Bileşenler

#### ZarApp (lib/main.dart)
- Ana uygulama widget'ı
- Material Design 3 kullanır
- Mavi renk teması

#### SplashScreen (lib/main.dart)
- Uygulama açılışında 2 saniye gösterilir
- Mavi arka plan üzerinde zar ikonu ve "ZAR" yazısı
- Otomatik olarak ana ekrana geçiş yapar

#### DiceScreen (lib/main.dart)
- Ana zar atma ekranı
- Üç bölümden oluşur:
  1. Zar sayısı seçici (1-6 arası)
  2. Zar görüntüleme alanı
  3. "Zar At" butonu

#### DiceWidget (lib/main.dart)
- Tek bir zarı görselleştiren widget
- Her zarın üzerinde nokta deseni ile değer gösterilir
- 1'den 6'ya kadar tüm zar yüzlerini destekler

### 2. Özellikler

#### Zar Sayısı Seçimi
- Kullanıcı 1-6 arası zar sayısı seçebilir
- ChoiceChip widget'ları ile seçim yapılır
- Seçilen sayı mavi renkle vurgulanır

#### Zar Atma
- "Zar At" butonuna tıklanarak zarlar atılır
- 100ms aralıklarla 10 kez animasyon çalıştırılır
- Her animasyon adımında rastgele değerler gösterilir
- Animasyon sırasında buton devre dışı kalır

#### Görsel Tasarım
- Zarlar beyaz arka plan üzerinde mavi kenarlı
- Zar noktaları mavi renkte
- Gölge efekti ile 3D görünüm
- Responsive tasarım - birden fazla zar yan yana ve alt alta sıralanabilir

### 3. Teknik Detaylar

#### Android Yapılandırması
- Minimum SDK: 21 (Android 5.0)
- Target SDK: 34 (Android 14)
- Namespace: com.bulutsoft.zar
- Kotlin: 1.9.0
- Gradle: 8.3

#### Flutter Yapılandırması
- SDK: >=3.0.0 <4.0.0
- Material Design 3 aktif
- cupertino_icons paketi dahil

#### Dosya Yapısı
```
Zar/
├── lib/
│   └── main.dart              # Tüm uygulama kodu
├── android/                    # Android yapılandırması
│   ├── app/
│   │   ├── build.gradle       # Uygulama build yapılandırması
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       ├── kotlin/com/bulutsoft/zar/
│   │       │   └── MainActivity.kt
│   │       └── res/values/
│   │           └── styles.xml
│   ├── build.gradle           # Proje build yapılandırması
│   ├── settings.gradle        # Gradle ayarları
│   ├── gradle.properties      # Gradle özellikleri
│   └── gradle/wrapper/
│       └── gradle-wrapper.properties
├── pubspec.yaml               # Flutter bağımlılıkları
├── analysis_options.yaml      # Dart lint kuralları
├── .gitignore                 # Git ignore dosyası
├── .metadata                  # Flutter metadata
└── README.md                  # Kullanıcı dokümantasyonu
```

## Kurulum ve Çalıştırma

### Gereksinimler
1. Flutter SDK (3.0.0 veya üzeri)
2. Android Studio veya Android SDK
3. Java JDK 17 veya üzeri

### Kurulum Adımları

1. Flutter bağımlılıklarını yükleyin:
```bash
flutter pub get
```

2. Android cihaz veya emülatör bağlayın

3. Uygulamayı çalıştırın:
```bash
flutter run
```

### APK Oluşturma

Debug APK:
```bash
flutter build apk
```

Release APK (imzalı):
```bash
flutter build apk --release
```

## Kod Kalitesi

- ✅ Flutter lints kuralları aktif
- ✅ Const constructor kullanımı optimize edildi
- ✅ Widget yapısı temiz ve modüler
- ✅ State management basit ve etkili
- ✅ Kullanılmayan import yok
- ✅ Güvenlik açığı tespit edilmedi

## Potansiyel Geliştirmeler

Bu temel uygulama gereksinimlerini karşılamaktadır. İsterseniz ileride eklenebilecek özellikler:

1. Ses efektleri (zar atılırken ses)
2. Haptic feedback (titreşim)
3. Zar sonuçlarının geçmişi
4. Farklı zar tipleri (D4, D8, D10, D12, D20)
5. Karanlık tema desteği
6. Dil seçenekleri (İngilizce, Türkçe)
7. Toplam puan gösterimi
8. İstatistikler

## Notlar

- iOS desteği kasıtlı olarak eklenmemiştir (gereksinimler gereği)
- Uygulama login/kayıt sistemi içermemektedir
- Veri kalıcılığı (persistence) yoktur - her açılışta sıfırdan başlar
- İnternet bağlantısı gerektirmez

## Lisans

Bu proje BulutSoft tarafından geliştirilmiştir.
