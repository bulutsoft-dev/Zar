# Zar Pro - Professional Dice Rolling Application

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

**Developed by Bulutsoft**

Modern, professional dice rolling application with session management, persistence, and sharp UI design.

## 🎯 Features

### Core Features
- 🎲 Roll 1-6 dice at once
- 💾 Session-based gaming system
- 📊 Real-time statistics and history tracking
- 🌓 Light/Dark theme toggle
- 💾 Persistent session storage
- 📱 Professional sharp-edged UI design
- 📳 Haptic feedback
- ✨ Smooth animations

### Session Management
- **Sessionless Mode**: Roll dice without starting a game (default)
- **Start New Game**: Begin a tracked session from the navbar
- **Save Sessions**: Save game sessions with custom names
- **History View**: View current session roll history
- **Saved Games**: Access all previously saved game sessions
- **Session Details**: View detailed statistics and roll history for any saved session

### UI/UX
- **Sharp Corners**: All UI elements have rectangular, sharp-edged design (borderRadius: 0)
- **Bulutsoft Branding**: Company name prominently displayed in navbar
- **Theme Toggle**: Switch between light and dark themes seamlessly
- **Responsive Design**: Optimized for mobile devices
- **Professional Gradients**: Premium color palette with gradient effects
- **Session Indicators**: Visual feedback for active game sessions

## 🏗️ Architecture

### Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/
│   └── game_session.dart          # Data models for sessions and rolls
├── providers/
│   ├── theme_provider.dart        # Theme management
│   └── session_provider.dart      # Session state management
├── screens/
│   ├── splash_screen.dart         # Animated splash screen
│   ├── home_screen.dart           # Main dice rolling screen
│   ├── history_screen.dart        # Current session history
│   ├── saved_sessions_screen.dart # List of saved sessions
│   └── session_detail_screen.dart # Detailed session view
├── widgets/
│   ├── dice_widget.dart           # Animated dice component
│   └── custom_app_bar.dart        # Custom navigation bar
└── utils/
    ├── app_colors.dart            # Color palette
    └── constants.dart             # App constants
```

### State Management

The app uses **Provider** pattern for state management:

- **ThemeProvider**: Manages light/dark theme state with persistence
- **SessionProvider**: Manages game sessions, roll history, and persistence

### Data Persistence

- **SharedPreferences**: Used for storing:
  - Theme preference
  - Saved game sessions
  - Session history (up to 100 sessions)

### Models

**GameSession**
- `id`: Unique session identifier (UUID)
- `name`: User-defined session name
- `createdAt`: Session creation timestamp
- `updatedAt`: Last update timestamp
- `rolls`: List of DiceRoll objects

**DiceRoll**
- `values`: List of dice values rolled
- `timestamp`: Roll timestamp
- `total`: Sum of all dice values

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  provider: ^6.1.1           # State management
  shared_preferences: ^2.2.2  # Local storage
  uuid: ^4.3.3                # UUID generation
  intl: ^0.18.1               # Date formatting
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

### Installation

1. Clone the repository
```bash
git clone https://github.com/bulutsoft-dev/Zar.git
cd Zar
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

### Building

**Android APK**
```bash
flutter build apk --release
```

**Android App Bundle**
```bash
flutter build appbundle --release
```

**iOS**
```bash
flutter build ios --release
```

## 🎮 How to Use

### Basic Dice Rolling
1. Open the app (starts in sessionless mode)
2. Select number of dice (1-6)
3. Tap "ZAR AT" (Roll Dice) button
4. View total sum instantly

### Session-Based Gaming
1. Tap the **Play icon** (▶) in the navbar to start a new game
2. Roll dice as many times as you want
3. Tap the **History icon** to view current session rolls
4. Tap the **Stop icon** (⏹) to end the game
5. Choose to save the game with a custom name or discard it

### Managing Saved Games
1. Tap the **Folder icon** in the navbar
2. View list of all saved game sessions
3. Tap any session to view detailed statistics and roll history
4. Delete sessions by tapping the delete icon

### Theme Toggle
- Tap the **Sun/Moon icon** in the navbar to toggle between light and dark themes
- Theme preference is saved automatically

## 🎨 Design System

### Color Palette

**Dark Theme**
- Primary: `#1A1A2E`
- Secondary: `#16213E`
- Accent: `#0F3460`
- Highlight: `#E94560`
- Gold: `#FFD700`
- Purple: `#9B59B6`

**Light Theme**
- Primary: `#F5F5F5`
- Secondary: `#FFFFFF`
- Accent: `#E8E8E8`
- Highlight: `#E94560`
- Text: `#1A1A2E`

### UI Principles
- **Sharp Corners**: All borders have 0 radius for a modern, professional look
- **Consistent Spacing**: 8dp grid system
- **Gradients**: Subtle gradients for depth
- **High Contrast**: Ensures readability in both themes
- **Animation**: Smooth transitions (200-500ms)

## 📱 Screenshots

*(Screenshots would be inserted here in a real README)*

## 🔧 Configuration

### Constants (lib/utils/constants.dart)
```dart
class AppConstants {
  static const int maxRollHistory = 50;      // Max rolls per session
  static const int maxSavedSessions = 100;   // Max saved sessions
  static const int rollAnimationTicks = 15;  // Animation duration
  // ... more constants
}
```

### Customization

**Change App Name**
Edit in `lib/utils/constants.dart`:
```dart
static const String appName = 'YOUR APP NAME';
static const String companyName = 'YOUR COMPANY';
```

**Adjust Theme Colors**
Edit in `lib/utils/app_colors.dart`:
```dart
static const Color highlightColor = Color(0xFFYOURCOLOR);
```

## 🧪 Testing

```bash
flutter test
```

## 📄 License

This project is developed by **Bulutsoft**.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

For support, please contact Bulutsoft.

---

**Made with ❤️ by Bulutsoft**
