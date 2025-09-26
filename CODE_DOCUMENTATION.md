# PropertySwipe App - Code Documentation 📚

## Overview
This document explains the PropertySwipe app code in simple terms for developers with intermediate programming experience (C++, Java, OOP background).

## Table of Contents
1. [Project Structure](#project-structure)
2. [Data Models](#data-models)
3. [State Management](#state-management)
4. [Screens & UI](#screens--ui)
5. [Key Features Explained](#key-features-explained)
6. [How to Modify the App](#how-to-modify-the-app)

---

## Project Structure

```
lib/
├── models/           # Data classes (like structs in C++)
├── screens/          # Different app pages
├── widgets/          # Reusable UI components
├── providers/        # App state management
└── main.dart         # App starting point
```

**Think of it like this:**
- `models/` = Your data structures (like classes in Java)
- `screens/` = Different pages of your app
- `widgets/` = Reusable UI pieces (like components)
- `providers/` = Global app state (like static variables)

---

## Data Models

### 1. User Model (`lib/models/user.dart`)

**What it does:** Stores user information (like a user profile)

```dart
class User {
  final String id;           // Unique user ID
  String firstName;          // User's first name
  String lastName;           // User's last name
  String email;              // User's email
  String? profileImage;      // Path to profile photo (optional)
  String? address;           // User's address (optional)
  String? phoneNumber;       // User's phone (optional)
  final UserType type;       // Buyer, Seller, or Both
  // ... more fields
}
```

**Key Methods:**
- `fullName` - Combines first and last name
- `copyWith()` - Creates a new user with some fields changed
- `toJson()` / `fromJson()` - Converts to/from JSON for storage

**How to modify:** Add new fields like `age`, `preferredLocation`, etc.

### 2. Property Model (`lib/models/property.dart`)

**What it does:** Stores property information (like a house listing)

```dart
class Property {
  final String id;           // Unique property ID
  final String title;        // "Beautiful Downtown Apartment"
  final String description;  // Property description
  final double price;        // Property price
  final String location;     // "New York, NY"
  final int bedrooms;        // Number of bedrooms
  final int bathrooms;       // Number of bathrooms
  final double area;         // Square footage
  final List<String> images; // URLs to property photos
  final PropertyType type;   // House, Apartment, Condo, etc.
  // ... more fields
}
```

**How to modify:** Add fields like `garage`, `pool`, `yearBuilt`, etc.

### 3. Match Model (`lib/models/match.dart`)

**What it does:** Tracks when a user likes a property

```dart
class Match {
  final String id;           // Unique match ID
  final String buyerId;      // Who liked the property
  final String sellerId;     // Who owns the property
  final String propertyId;   // Which property was liked
  final DateTime matchedAt;  // When the match happened
  final MatchStatus status;  // Pending, Accepted, Declined
}
```

---

## State Management

### AppProvider (`lib/providers/app_provider.dart`)

**What it does:** Manages the entire app's state (like a global manager)

**Key Variables:**
```dart
class AppProvider extends ChangeNotifier {
  List<Property> _availableProperties = [];  // Properties to swipe
  List<Property> _likedProperties = [];      // Properties user liked
  List<Property> _viewedProperties = [];     // Properties user viewed
  List<Match> _matches = [];                 // All matches
  User? _currentUser;                        // Current user info
}
```

**Key Methods:**
- `initializeApp()` - Sets up the app with sample data
- `swipeProperty()` - Handles when user swipes left/right
- `viewProperty()` - Tracks when user views a property
- `updateUser()` - Updates user profile information

**How it works:** Think of it like a database that all screens can read from and write to.

---

## Screens & UI

### 1. Main Screen (`lib/main.dart`)

**What it does:** Sets up the app and bottom navigation

```dart
class MainScreen extends StatefulWidget {
  // Creates the 3-tab navigation:
  // Tab 0: Discover (swipe properties)
  // Tab 1: Matches (view saved properties)  
  // Tab 2: Profile (user profile)
}
```

### 2. Home Screen (`lib/screens/home_screen.dart`)

**What it does:** The main swiping interface

**Key Components:**
- **User Welcome** - Shows "Welcome back, [Name]!"
- **Property Stack** - The swipeable cards
- **Action Buttons** - Red X and Green Heart buttons

**How to modify:**
- Change the welcome message
- Add more action buttons
- Modify the property display

### 3. Profile Screen (`lib/screens/profile_screen.dart`)

**What it does:** Shows user profile and stats

**Key Components:**
- **Profile Picture** - User's photo
- **User Info** - Name, email, phone, address
- **Activity Stats** - Liked, Matches, Viewed counts
- **Edit Button** - Opens profile editor

### 4. Profile Edit Screen (`lib/screens/profile_edit_screen.dart`)

**What it does:** Allows users to edit their profile

**Key Features:**
- **Photo Upload** - Tap camera to select from iPhone gallery
- **Form Fields** - First name, last name, email, phone, address
- **Validation** - Checks if email is valid, phone format, etc.
- **Save Button** - Updates the profile

**How the photo upload works:**
```dart
Future<void> _pickImage() async {
  final XFile? image = await _picker.pickImage(
    source: ImageSource.gallery,  // Opens iPhone photo library
    maxWidth: 800,                // Resizes image
    maxHeight: 800,
    imageQuality: 85,             // Compresses image
  );
}
```

### 5. Matches Screen (`lib/screens/matches_screen.dart`)

**What it does:** Shows all properties the user has liked

**Key Components:**
- **Property Cards** - Shows saved properties with photos
- **Property Details** - Tap to see full property info
- **Empty State** - Shows message when no properties saved

---

## Key Features Explained

### 1. Swiping System

**How it works:**
1. User swipes right on a property
2. `swipeProperty()` method is called
3. Property is moved from `availableProperties` to `likedProperties`
4. A match is created
5. UI updates to show next property

**Code Flow:**
```dart
// In SwipeablePropertyStack
onSwipe: (property, direction) {
  appProvider.swipeProperty(property, direction);  // Save the swipe
  _showSwipeFeedback(direction);                   // Show "Liked!" or "Passed"
}
```

### 2. Profile Photo Upload

**How it works:**
1. User taps camera icon
2. `_pickImage()` opens iPhone photo library
3. User selects a photo
4. Photo is stored as a file path
5. Profile screen shows the new photo

**Technical Details:**
- Uses `image_picker` package
- Photos are resized to 800x800 pixels
- Quality is compressed to 85% to save space
- File path is stored in user profile

### 3. Property Data

**Where properties come from:**
- All properties are hardcoded in `_generateSampleProperties()`
- 20+ properties across major US cities
- Each property has photos from Unsplash
- Properties include: price, location, bedrooms, bathrooms, area

**How to add more properties:**
```dart
Property(
  id: 'prop_21',
  title: 'Your New Property',
  description: 'Amazing property description',
  price: 500000,
  location: 'Your City, State',
  bedrooms: 3,
  bathrooms: 2,
  area: 1500,
  images: ['https://your-image-url.com'],
  type: PropertyType.house,
  sellerId: 'seller_21',
  createdAt: DateTime.now(),
)
```

---

## How to Modify the App

### 1. Adding New User Fields

**Step 1:** Update the User model
```dart
class User {
  // ... existing fields
  String? age;              // Add new field
  String? occupation;       // Add another field
}
```

**Step 2:** Update the profile edit screen
```dart
// Add new text field
_buildTextField(
  controller: _ageController,
  label: 'Age',
  icon: Icons.cake,
)
```

**Step 3:** Update the profile display screen
```dart
// Show the new field
_buildInfoRow(Icons.cake, 'Age', user.age ?? 'Not specified'),
```

### 2. Adding New Property Types

**Step 1:** Update the PropertyType enum
```dart
enum PropertyType {
  house,
  apartment,
  condo,
  townhouse,
  studio,
  loft,
  mansion,    // Add new type
  farmhouse,  // Add another type
}
```

**Step 2:** Update the display name
```dart
String get displayName {
  switch (this) {
    // ... existing cases
    case PropertyType.mansion:
      return 'Mansion';
    case PropertyType.farmhouse:
      return 'Farmhouse';
  }
}
```

### 3. Changing the UI Colors

**In `lib/main.dart`:**
```dart
theme: ThemeData(
  primarySwatch: Colors.blue,  // Change to Colors.green, Colors.red, etc.
  primaryColor: Colors.blue[600],
  // ... other theme settings
),
```

### 4. Adding New Screens

**Step 1:** Create new screen file
```dart
// lib/screens/new_screen.dart
class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Screen')),
      body: Center(child: Text('Hello World')),
    );
  }
}
```

**Step 2:** Add to navigation
```dart
// In main.dart
final List<Widget> _screens = [
  const HomeScreen(),
  const MatchesScreen(),
  const ProfileScreen(),
  const NewScreen(),  // Add your new screen
];
```

### 5. Modifying Property Cards

**In `lib/widgets/property_card.dart`:**
- Change the card design
- Add new information fields
- Modify the swipe gestures
- Change the photo display

---

## Common Modifications

### 1. Change App Name
- Update `pubspec.yaml` → `name: your_new_app_name`
- Update `lib/main.dart` → `title: 'Your New App Name'`

### 2. Add More Properties
- Edit `_generateSampleProperties()` in `app_provider.dart`
- Add new Property objects with your data

### 3. Change Default User
- Edit `initializeApp()` in `app_provider.dart`
- Update the sample user data

### 4. Modify Swipe Sensitivity
- In `property_card.dart`, change the velocity threshold:
```dart
if (details.velocity.pixelsPerSecond.dx > 500) {  // Change 500 to make easier/harder
```

### 5. Add New Dependencies
- Add to `pubspec.yaml` under `dependencies:`
- Run `flutter pub get`
- Import in your code: `import 'package:package_name/package_name.dart';`

---

## Troubleshooting

### Common Issues:

1. **App won't build:** Run `flutter clean` then `flutter pub get`
2. **Photos not uploading:** Check iPhone permissions in Settings
3. **Properties not showing:** Check internet connection for images
4. **App crashes:** Check the console for error messages

### Getting Help:
- Check Flutter documentation: https://flutter.dev/docs
- Look at the error messages in the console
- Test changes on a simulator first before iPhone

---

## Next Steps

1. **Test the app** - Try all features on your iPhone
2. **Make small changes** - Start with colors, text, or adding properties
3. **Add new features** - Use this guide to add what you need
4. **Ask questions** - The code is well-commented and documented

**Remember:** Start small, test often, and don't be afraid to experiment! 🚀
