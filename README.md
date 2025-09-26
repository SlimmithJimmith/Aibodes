# Aibodes 🏠💕

A cross-platform real estate app with Tinder-like swiping functionality built with Flutter. Match buyers with sellers through an intuitive swipe interface.

## About Aibodes

Aibodes is a tech startup focused on revolutionizing the real estate industry through innovative mobile applications. Our flagship product combines the familiar Tinder swiping experience with property browsing to create a more engaging and efficient way to find your dream home.

## Features ✨

- **Swipe Interface**: Tinder-like swiping to like or pass on properties
- **Profile System**: Complete user profiles with photo upload from iPhone gallery
- **Editable Profile**: First name, last name, email, phone, address fields
- **Match Saving**: Swipe right to automatically save properties you like
- **20+ Properties**: Diverse real estate listings across major US cities
- **3-Tab Navigation**: Discover, Matches, and Profile screens
- **Activity Tracking**: View your liked, viewed, and matched property counts
- **Property Details**: Detailed property information with photos and descriptions
- **Modern UI**: Beautiful, responsive design with smooth animations
- **Cross-Platform**: Works on both iOS and Android
- **iPhone Optimized**: Fully functional on iPhone 15 Pro Max

## Screenshots 📱

The app includes:
- **Discover Tab**: Swipe through 20+ available properties
- **Matches Tab**: View all your saved/liked properties with details
- **Profile Tab**: Edit your profile, upload photos, view activity stats
- **Property Details**: Detailed view of individual properties
- **Profile Editor**: Complete profile management with photo upload

## Getting Started 🚀

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator (for testing)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/SlimmithJimmith/Aibodes.git
   cd Aibodes
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
- **HomeScreen**: Main swiping interface with 3-tab navigation
- **MatchesScreen**: View all your saved/liked properties
- **ProfileScreen**: Display user profile and activity stats
- **ProfileEditScreen**: Edit profile with photo upload functionality
- **PropertyDetailScreen**: Detailed property information

## Features in Detail 🎯

### Swiping Functionality
- Swipe right to like and save a property
- Swipe left to pass on a property
- Visual feedback for swipe actions
- Automatic saving of liked properties to Matches tab
- Track viewed properties for activity stats

### Property Information
- 20+ diverse properties across major US cities
- High-quality property images from Unsplash
- Detailed property specifications (bedrooms, bathrooms, area)
- Location and pricing information
- Property type classification (house, condo, apartment, etc.)

### Profile System
- Complete user profile with photo upload from iPhone gallery
- Editable fields: first name, last name, email, phone, address
- Activity tracking: liked, viewed, and matched property counts
- Beautiful profile display with user stats
- Profile editing with validation and error handling

### Match Saving System
- Automatic saving of liked properties
- Dedicated Matches tab to view all saved properties
- Property details accessible from saved properties
- Activity statistics and user engagement tracking

## Dependencies 📦

- `flutter_swiper_view`: For swipeable card functionality
- `provider`: For state management
- `cached_network_image`: For optimized image loading
- `shared_preferences`: For local data persistence
- `http`: For API communication
- `flutter_staggered_animations`: For smooth animations
- `image_picker`: For profile photo upload from iPhone gallery
- `path_provider`: For file system access

## Property Listings 🏠

The app includes 20+ diverse properties across major US cities:

- **Beachfront Villa** (Malibu, CA) - $2.5M
- **Urban Loft** (SoHo, NY) - $380K
- **Mountain Cabin** (Aspen, CO) - $420K
- **Historic Brownstone** (Brooklyn Heights, NY) - $850K
- **Modern Condo** (Chicago, IL) - $520K
- **Garden Apartment** (Portland, OR) - $320K
- **Luxury Townhouse** (Georgetown, DC) - $950K
- **Minimalist Studio** (Seattle, WA) - $240K
- **Ranch Style Home** (Austin, TX) - $480K
- **Waterfront Condo** (Miami, FL) - $1.8M
- **Victorian House** (San Francisco, CA) - $720K
- **Modern Apartment** (Denver, CO) - $410K
- **Penthouse Suite** (Las Vegas, NV) - $2.2M
- **Cottage Style Home** (Charleston, SC) - $380K
- **Contemporary Loft** (Minneapolis, MN) - $550K
- **+ 5 more diverse properties**

## Future Enhancements 🚀

- [x] User authentication and profiles ✅
- [x] Property favoriting system ✅
- [ ] Real-time chat between buyers and sellers
- [ ] Advanced filtering and search
- [ ] Push notifications for matches
- [ ] Map integration for property locations
- [ ] Virtual property tours
- [ ] Payment integration
- [ ] Social sharing features
- [ ] Backend API integration
- [ ] User registration and login

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