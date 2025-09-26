# Aibodes - Quick Reference Guide 🚀

## Most Common Modifications

### 1. Change App Name & Colors
```dart
// In lib/main.dart
title: 'Your New App Name',
primarySwatch: Colors.green,  // Change from Colors.blue
```

### 2. Add a New Property
```dart
// In lib/providers/app_provider.dart, add to _generateSampleProperties():
Property(
  id: 'prop_21',
  title: 'Your Property Name',
  description: 'Amazing property description',
  price: 500000,
  location: 'Your City, State',
  bedrooms: 3,
  bathrooms: 2,
  area: 1500,
  images: ['https://images.unsplash.com/photo-1234567890'],
  type: PropertyType.house,
  sellerId: 'seller_21',
  createdAt: DateTime.now(),
),
```

### 3. Change Default User Info
```dart
// In lib/providers/app_provider.dart, in initializeApp():
_currentUser = User(
  id: 'user_1',
  firstName: 'Your',        // Change this
  lastName: 'Name',         // Change this
  email: 'your@email.com',  // Change this
  // ... rest stays the same
);
```

### 4. Add New User Field
```dart
// Step 1: In lib/models/user.dart, add to User class:
String? age;  // Add this line

// Step 2: In constructor, add:
this.age,

// Step 3: In copyWith method, add:
String? age,

// Step 4: In toJson/fromJson, add:
'age': age,
age: json['age'],
```

### 5. Change Swipe Sensitivity
```dart
// In lib/widgets/property_card.dart, change:
if (details.velocity.pixelsPerSecond.dx > 500) {  // Make 500 smaller for easier swiping
```

## File Locations

| What You Want to Change | File Location |
|------------------------|---------------|
| App name, colors, theme | `lib/main.dart` |
| Add/remove properties | `lib/providers/app_provider.dart` |
| User profile fields | `lib/models/user.dart` |
| Property information | `lib/models/property.dart` |
| Swipe behavior | `lib/widgets/property_card.dart` |
| Profile editing | `lib/screens/profile_edit_screen.dart` |
| Property display | `lib/screens/matches_screen.dart` |

## Common Commands

```bash
# Get new dependencies
flutter pub get

# Clean and rebuild
flutter clean
flutter pub get

# Run on iPhone
flutter run -d 00008130-00146DDC2120001C

# Build for iPhone
flutter build ios --release
```

## Quick Tips

- **Always test on simulator first** before iPhone
- **Make small changes** and test each one
- **Check console** for error messages
- **Backup your code** before major changes
- **Start with simple changes** like colors and text

## Need Help?

1. Check the full documentation: `CODE_DOCUMENTATION.md`
2. Look at existing code for examples
3. Test changes step by step
4. Ask your business partner for help!

**Happy coding!** 🎉
