# Localization System Implementation

## Overview
A professional localization system has been implemented for the Zar Pro app with support for multiple languages. The app supports Turkish (default), English, German, Spanish, Arabic, and Russian.

## Architecture

### 1. Core Components

#### Language Provider (`lib/providers/language_provider.dart`)
- Manages the app's current locale
- Stores language preference using SharedPreferences
- Provides `toggleLanguage()` and `setLanguage()` methods
- Default language: Turkish (`tr`)

#### ARB Files (`lib/l10n/`)
- `app_tr.arb` - Turkish translations (default/template)
- `app_en.arb` - English translations
- `app_de.arb` - German translations
- `app_es.arb` - Spanish translations
- `app_ar.arb` - Arabic translations
- `app_ru.arb` - Russian translations
- Contains all app strings with placeholders for dynamic content

#### Configuration Files
- `l10n.yaml` - Localization configuration
- `pubspec.yaml` - Includes `flutter_localizations` and `generate: true`

### 2. Implementation Details

#### Main App Setup (`lib/main.dart`)
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => LanguageProvider()),
    // ... other providers
  ],
  child: Consumer<LanguageProvider>(
    builder: (context, languageProvider, _) {
      return MaterialApp(
        locale: languageProvider.locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('tr', ''), // Turkish
          Locale('en', ''), // English
          Locale('de', ''), // German
          Locale('es', ''), // Spanish
          Locale('ar', ''), // Arabic
          Locale('ru', ''), // Russian
        ],
        // ...
      );
    },
  ),
)
```

#### Usage in Screens
```dart
final l10n = AppLocalizations.of(context)!;

Text(l10n.appName)  // Simple string
Text(l10n.turn(playerName))  // String with placeholder
Text(l10n.rollsCount(count))  // String with number
```

### 3. Language Selector

Located in Language Selection Dialog (`lib/widgets/language_selection_dialog.dart`):
- Select between Turkish (🇹🇷), English (🇬🇧), German (🇩🇪), Spanish (🇪🇸), Arabic (🇸🇦), and Russian (🇷🇺)
- Beautiful dialog with language flags and native names
- Instantly updates all app text
- Selection is persisted across app restarts
- Shows automatically on first launch

### 4. Localized Screens

**Fully Localized:**
- ✅ Splash Screen
- ✅ Home Screen (dice rolling)
- ✅ Settings Screen
- ✅ New Game Setup Screen
- ✅ Custom App Bar
- ✅ Dialog Components

**Partially Localized (can be completed as needed):**
- History Screen
- Saved Games Screen
- Session Detail Screen
- How to Use Screen

### 5. Supported Languages

- 🇹🇷 **Turkish (Türkçe)** - Default language, complete translations
- 🇬🇧 **English** - Complete translations  
- 🇩🇪 **German (Deutsch)** - Complete translations
- 🇪🇸 **Spanish (Español)** - Complete translations
- 🇸🇦 **Arabic (العربية)** - Complete translations with RTL support
- 🇷🇺 **Russian (Русский)** - Complete translations

### 6. Features

- **Automatic Locale Detection**: Falls back to Turkish if system language is not supported
- **Persistent Selection**: User's language choice is saved
- **Dynamic Updates**: UI updates immediately when language is changed
- **Type-Safe**: All strings are accessed through generated Dart code
- **Placeholder Support**: Handles dynamic content like player names, counts, etc.

## Building the App

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Run `flutter pub get` to install dependencies

### Generate Localization Files
Flutter will automatically generate localization files when you build:
```bash
flutter pub get
# Localization files are generated automatically
```

Or manually generate:
```bash
flutter gen-l10n
```

### Build Commands
```bash
# Development
flutter run

# Release APK
flutter build apk --release

# Release App Bundle
flutter build appbundle --release
```

## Adding New Languages

1. Create a new ARB file: `lib/l10n/app_[language_code].arb`
2. Copy content from `app_en.arb` as a template (simple key-value pairs)
3. Translate all 123 strings to the new language
4. Add the locale to `supportedLocales` in `main.dart`
5. Update the `toggleLanguage()` method in `language_provider.dart`
6. Add language option to `language_selection_dialog.dart` with appropriate flag emoji
7. Add helper methods (`isLanguageName`) in `language_provider.dart`
8. Update `currentLanguageName` getter in `language_provider.dart`
9. Run `flutter gen-l10n` to generate localization code

## Adding New Strings

1. Add to `lib/l10n/app_tr.arb` (template file):
```json
{
  "myNewString": "Yeni Metin",
  "@myNewString": {
    "description": "Description of the string"
  }
}
```

2. Add translation to `lib/l10n/app_en.arb`:
```json
{
  "myNewString": "New Text"
}
```

3. Use in code:
```dart
Text(AppLocalizations.of(context)!.myNewString)
```

## String Placeholders

For strings with dynamic content:

ARB file:
```json
{
  "greeting": "Merhaba, {name}!",
  "@greeting": {
    "description": "Greeting message",
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  }
}
```

Usage:
```dart
Text(l10n.greeting(userName))
```

## Best Practices

1. **Always use localization keys** - Never hardcode strings in UI
2. **Provide context** - Use the `@description` field for translator guidance
3. **Test both languages** - Switch languages to verify all strings display correctly
4. **Keep ARB files in sync** - Ensure all languages have the same keys
5. **Use meaningful key names** - Makes code more readable and maintainable

## Troubleshooting

### Strings not updating
- Run `flutter clean`
- Run `flutter pub get`
- Restart the app

### Missing localization
- Check that the key exists in both ARB files
- Verify the locale is in `supportedLocales`
- Ensure `generate: true` is in `pubspec.yaml`

### Build errors
- Make sure all placeholders match in ARB files
- Check JSON syntax in ARB files
- Verify all required fields are present

## Notes

- The localization system uses Flutter's official `intl` package
- Generated files are in `.dart_tool/flutter_gen/`
- ARB files use ICU message format for plurals and selects
- The system supports RTL languages (though not currently implemented)
