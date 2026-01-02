# Zar Pro - Premium Dice Rolling App

Profesyonel ve havalı bir zar atma uygulaması (Professional dice rolling application)

**Bulutsoft tarafından geliştirilmiştir**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

## 🎯 Özellikler (Features)

### Temel Özellikler
- 🎲 1-6 arası zar sayısı seçebilme
- 💾 Oturum tabanlı oyun sistemi
- 📊 Gerçek zamanlı istatistik ve geçmiş takibi
- 🌓 Açık/Koyu tema değiştirme
- 💾 Kalıcı oturum depolama
- 📱 Profesyonel keskin köşeli UI tasarımı
- 📳 Dokunsal geri bildirim (Haptic feedback)
- ✨ Akıcı animasyonlar

### Oturum Yönetimi
- **Oturumsuz Mod**: Oyun başlatmadan zar atma (varsayılan)
- **Yeni Oyun Başlat**: Navbar'dan takip edilen bir oturum başlatma
- **Oturumları Kaydet**: Özel isimlerle oyun oturumlarını kaydetme
- **Geçmiş Görünümü**: Mevcut oturum atış geçmişini görüntüleme
- **Kayıtlı Oyunlar**: Daha önce kaydedilmiş tüm oyun oturumlarına erişim
- **Oturum Detayları**: Kaydedilmiş oturumlar için detaylı istatistik ve geçmiş

### UI/UX
- **Keskin Köşeler**: Tüm UI elemanları dikdörtgen, keskin köşeli tasarıma sahip
- **Bulutsoft Markalaşması**: Şirket adı navbar'da belirgin şekilde görüntüleniyor
- **Tema Değiştirme**: Açık ve koyu temalar arasında sorunsuz geçiş
- **Responsive Tasarım**: Mobil cihazlar için optimize edilmiş
- **Profesyonel Gradyanlar**: Premium renk paleti ile gradyan efektleri
- **Oturum Göstergeleri**: Aktif oyun oturumları için görsel geri bildirim

## 🎮 Kullanım (Usage)

### Basit Zar Atma
1. Uygulamayı açın (oturumsuz modda başlar)
2. Zar sayısını seçin (1-6)
3. "ZAR AT" butonuna basın
4. Toplam değeri anında görün

### Oturum Tabanlı Oyun
1. Yeni oyun başlatmak için navbar'daki **Oynat ikonuna** (▶) basın
2. İstediğiniz kadar zar atın
3. Mevcut oturum atışlarını görmek için **Geçmiş ikonuna** basın
4. Oyunu bitirmek için **Durdur ikonuna** (⏹) basın
5. Oyunu özel bir isimle kaydetmeyi veya atmayı seçin

### Kayıtlı Oyunları Yönetme
1. Navbar'daki **Klasör ikonuna** basın
2. Tüm kayıtlı oyun oturumlarının listesini görün
3. Detaylı istatistik ve atış geçmişini görmek için herhangi bir oturuma basın
4. Silme ikonuna basarak oturumları silin

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
flutter build apk --release
```

## 🏗️ Uygulama Yapısı

Yeni profesyonel mimari ile:

```
lib/
├── main.dart                    # Uygulama giriş noktası
├── models/                      # Veri modelleri
├── providers/                   # State management
├── screens/                     # Uygulama ekranları
├── widgets/                     # Yeniden kullanılabilir widgetlar
└── utils/                       # Yardımcı araçlar ve sabitler
```

Detaylı mimari bilgisi için [ARCHITECTURE.md](ARCHITECTURE.md) dosyasına bakın.

## 🎨 UI Özellikleri

- **Keskin Köşeler**: Tüm container ve butonlar borderRadius: 0 ile keskin köşeli
- **Premium Renk Paleti**: Koyu lacivert tonları ile kırmızı-mor gradient aksentler
- **3D Zar Görünümü**: Gölge ve ışık efektleri ile gerçekçi zarlar
- **Çift Tema**: Açık ve koyu tema desteği
- **Glassmorphism**: Yarı saydam paneller ile modern görünüm
- **Smooth Animasyonlar**: Sayfa geçişleri ve zar atma animasyonları

## 🔧 Teknolojiler

- **Flutter**: UI framework
- **Provider**: State management
- **SharedPreferences**: Yerel veri depolama
- **UUID**: Benzersiz oturum kimlikleri
- **Intl**: Tarih formatlama

## 📄 Lisans

Bu proje **Bulutsoft** tarafından geliştirilmiştir.

---

**Bulutsoft ile ❤️ ile yapılmıştır**