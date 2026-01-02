# Zar Uygulaması - Ekran Akışı

## Ekran 1: Splash Screen (Başlangıç Ekranı)

```
╔════════════════════════════════╗
║                                ║
║                                ║
║          🎲 (Icon)             ║
║                                ║
║            ZAR                 ║
║                                ║
║         ⚪ (Loading)           ║
║                                ║
║                                ║
╚════════════════════════════════╝
```

**Özellikler:**
- Mavi arka plan
- Beyaz zar ikonu (120x120)
- "ZAR" yazısı (48pt, bold, beyaz)
- Yükleniyor animasyonu
- 2 saniye sonra otomatik geçiş

---

## Ekran 2: Ana Ekran (Zar Atma Ekranı)

```
╔════════════════════════════════╗
║     Zar Atma (App Bar)         ║
╠════════════════════════════════╣
║                                ║
║        Zar Sayısı              ║
║   [1] [2] [3] [4] [5] [6]     ║
║   (Seçim Chip'leri)            ║
║                                ║
║ ┌────┐ ┌────┐ ┌────┐          ║
║ │ •• │ │ •• │ │ •  │          ║
║ │ •• │ │ •  │ │••• │          ║
║ └────┘ └────┘ └────┘          ║
║   (Zar Görünümleri)            ║
║                                ║
║                                ║
║     ┌──────────────┐           ║
║     │   Zar At     │           ║
║     └──────────────┘           ║
║                                ║
╚════════════════════════════════╝
```

**Özellikler:**
- Üst kısım: Zar sayısı seçici (1-6)
- Orta kısım: Zar görünümleri
- Alt kısım: "Zar At" butonu

---

## Zar Tasarımları

### 1 Nokta
```
┌────────┐
│        │
│   •    │
│        │
└────────┘
```

### 2 Nokta
```
┌────────┐
│ •      │
│        │
│      • │
└────────┘
```

### 3 Nokta
```
┌────────┐
│ •      │
│   •    │
│      • │
└────────┘
```

### 4 Nokta
```
┌────────┐
│ •    • │
│        │
│ •    • │
└────────┘
```

### 5 Nokta
```
┌────────┐
│ •    • │
│   •    │
│ •    • │
└────────┘
```

### 6 Nokta
```
┌────────┐
│ •    • │
│ •    • │
│ •    • │
└────────┘
```

---

## Kullanıcı Etkileşimi Akışı

1. **Uygulama Açılışı**
   - Splash screen gösterilir
   - 2 saniye beklenir
   - Ana ekrana geçiş

2. **Zar Sayısı Seçimi**
   - Kullanıcı 1-6 arası seçim yapar
   - Seçilen chip mavi renge döner
   - Zar görünümleri güncellenir

3. **Zar Atma**
   - "Zar At" butonuna tıklanır
   - Buton devre dışı kalır ("Atılıyor...")
   - 1 saniye boyunca animasyon (10 kare)
   - Her karede rastgele değerler gösterilir
   - Animasyon biter, son değerler sabitlenir
   - Buton tekrar aktif olur

4. **Animasyon Detayları**
   - Süre: 1 saniye (10 x 100ms)
   - Her 100ms'de bir değişim
   - Rastgele değer: 1-6 arası
   - Smooth geçişler

---

## Renk Şeması

- **Ana Renk:** Mavi (#2196F3)
- **Arka Plan:** Beyaz
- **Zar Kutusu:** Beyaz + Mavi kenarlık
- **Zar Noktaları:** Mavi
- **Text:** Siyah (ana ekran), Beyaz (splash)

---

## Responsive Davranış

### Tek Zar
```
      ┌────┐
      │    │
      └────┘
```

### İki Zar
```
   ┌────┐ ┌────┐
   │    │ │    │
   └────┘ └────┘
```

### Üç Zar
```
   ┌────┐ ┌────┐ ┌────┐
   │    │ │    │ │    │
   └────┘ └────┘ └────┘
```

### Altı Zar (Wrap ile alt satıra geçer)
```
   ┌────┐ ┌────┐ ┌────┐
   │    │ │    │ │    │
   └────┘ └────┘ └────┘
   
   ┌────┐ ┌────┐ ┌────┐
   │    │ │    │ │    │
   └────┘ └────┘ └────┘
```

---

## Durum Yönetimi

### State Variables
- `numberOfDice`: int (1-6)
- `diceValues`: List<int> (her zarın değeri)
- `isRolling`: bool (animasyon durumu)

### State Değişimleri
1. Zar sayısı değiştiğinde → `numberOfDice` ve `diceValues` güncellenir
2. Zar atılırken → `isRolling = true`, değerler rastgele değişir
3. Animasyon bittiğinde → `isRolling = false`, son değerler sabitlenir

---

## Animasyon Detayları

```dart
Timer.periodic(100ms, callback) {
  if (tick >= 10) {
    stop animation
    isRolling = false
  } else {
    // Her tick'te yeni rastgele değerler
    diceValues = [random(1-6), ...]
  }
}
```

Toplam süre: 10 tick x 100ms = 1000ms (1 saniye)
