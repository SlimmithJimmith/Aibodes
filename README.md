# Aidobes - PropertySwipe 🏠💕

A cross-platform real estate app with Tinder-like swiping functionality built with Flutter. Match buyers with sellers through an intuitive swipe interface.

## About Aidobes

Aidobes is a tech startup focused on revolutionizing the real estate industry through innovative mobile applications. Our flagship product, PropertySwipe, combines the familiar Tinder swiping experience with property browsing to create a more engaging and efficient way to find your dream home.

## Features ✨

- **Swipe Interface**: Tinder-like swiping to like or pass on properties
- **Property Details**: Detailed property information with photos and descriptions
- **Matching System**: Get matched with sellers when you like their properties
- **Modern UI**: Beautiful, responsive design with smooth animations
- **Cross-Platform**: Works on both iOS and Android

## Screenshots 📱

The app includes:
- **Home Screen**: Swipe through available properties
- **Matches Screen**: View your property matches
- **Property Details**: Detailed view of individual properties

## Getting Started 🚀

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator (for testing)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/SlimmithJimmith/Aidobes.git
   cd Aidobes
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure 📁

```
lib/
├── models/           # Data models (Property, User, Match)
├── screens/          # App screens (Home, Matches, Property Details)
├── widgets/          # Reusable widgets (PropertyCard, SwipeableStack)
├── providers/        # State management (AppProvider)
└── main.dart         # App entry point
```

## Key Components 🔧

### Models
- **Property**: Represents a real estate listing
- **User**: Represents app users (buyers/sellers)
- **Match**: Represents matches between buyers and sellers

### Widgets
- **PropertyCard**: Individual property display card
- **SwipeablePropertyStack**: Stack of swipeable property cards

### Screens
- **HomeScreen**: Main swiping interface
- **MatchesScreen**: View and manage matches
- **PropertyDetailScreen**: Detailed property information

## Features in Detail 🎯

### Swiping Functionality
- Swipe right to like a property
- Swipe left to pass on a property
- Visual feedback for swipe actions
- Automatic matching when both parties like

### Property Information
- High-quality property images
- Detailed property specifications
- Location and pricing information
- Property type classification

### Matching System
- Real-time match notifications
- Match status tracking
- Contact seller functionality
- Match history

## Dependencies 📦

- `flutter_swiper_view`: For swipeable card functionality
- `provider`: For state management
- `cached_network_image`: For optimized image loading
- `shared_preferences`: For local data persistence
- `http`: For API communication
- `flutter_staggered_animations`: For smooth animations

## Future Enhancements 🚀

- [ ] User authentication and profiles
- [ ] Real-time chat between buyers and sellers
- [ ] Advanced filtering and search
- [ ] Push notifications for matches
- [ ] Property favoriting system
- [ ] Map integration for property locations
- [ ] Virtual property tours
- [ ] Payment integration
- [ ] Social sharing features

## Contributing 🤝

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments 🙏

- Flutter team for the amazing framework
- Tinder for the swipe interface inspiration
- Unsplash for the beautiful property images

---

**Happy Swiping! 🏠💕**