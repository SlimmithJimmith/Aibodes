# Flutter Setup Guide 🚀

This guide will help you set up Flutter on your system to run the PropertySwipe app.

## Prerequisites

- macOS (for iOS development)
- Xcode (for iOS development)
- Android Studio (for Android development)

## Installation Steps

### 1. Install Flutter

#### Option A: Using Homebrew (Recommended for macOS)
```bash
brew install --cask flutter
```

#### Option B: Manual Installation
1. Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/macos)
2. Extract the zip file to a location like `/Users/yourusername/development/`
3. Add Flutter to your PATH:
   ```bash
   export PATH="$PATH:/Users/yourusername/development/flutter/bin"
   ```
4. Add this line to your `~/.zshrc` or `~/.bash_profile`:
   ```bash
   export PATH="$PATH:/Users/yourusername/development/flutter/bin"
   ```

### 2. Verify Installation
```bash
flutter doctor
```

### 3. Install Dependencies
```bash
cd /Users/jameswatson/GitGoing
flutter pub get
```

### 4. Run the App

#### For iOS Simulator:
```bash
flutter run -d ios
```

#### For Android Emulator:
```bash
flutter run -d android
```

#### For Web (if supported):
```bash
flutter run -d web
```

## Troubleshooting

### Flutter Doctor Issues

If `flutter doctor` shows issues:

1. **Android Studio not found**: Install Android Studio and set up Android SDK
2. **Xcode not found**: Install Xcode from App Store
3. **iOS Simulator not found**: Install Xcode command line tools:
   ```bash
   xcode-select --install
   ```

### Common Issues

1. **"flutter: command not found"**: Make sure Flutter is in your PATH
2. **"No devices found"**: Start an iOS Simulator or Android Emulator
3. **Build errors**: Run `flutter clean` and `flutter pub get`

## Development Tips

1. **Hot Reload**: Press `r` in the terminal while the app is running
2. **Hot Restart**: Press `R` in the terminal while the app is running
3. **Quit**: Press `q` in the terminal to quit the app

## Next Steps

Once Flutter is installed and the app is running:

1. Explore the swipe functionality
2. Check out the matches screen
3. View property details
4. Customize the app for your needs

Happy coding! 🎉
