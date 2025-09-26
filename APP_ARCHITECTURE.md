# PropertySwipe App Architecture 🏗️

## High-Level Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    PropertySwipe App                        │
├─────────────────────────────────────────────────────────────┤
│  Main Screen (Bottom Navigation)                            │
│  ├── Discover Tab (Home Screen)                             │
│  ├── Matches Tab (Saved Properties)                         │
│  └── Profile Tab (User Profile)                             │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

```
User Action → Screen → Provider → Model → UI Update
     ↓           ↓        ↓        ↓         ↓
   Swipe → HomeScreen → AppProvider → Property → Matches Tab
```

## Component Structure

### 1. Models (Data Classes)
```
User
├── id, firstName, lastName
├── email, phone, address
├── profileImage
└── type (buyer/seller/both)

Property
├── id, title, description
├── price, location
├── bedrooms, bathrooms, area
├── images (photo URLs)
└── type (house/apartment/condo)

Match
├── id, buyerId, sellerId
├── propertyId
├── matchedAt (timestamp)
└── status (pending/accepted/declined)
```

### 2. Screens (App Pages)
```
MainScreen
├── Bottom Navigation (3 tabs)
├── Tab 0: HomeScreen (swipe properties)
├── Tab 1: MatchesScreen (saved properties)
└── Tab 2: ProfileScreen (user profile)

HomeScreen
├── User welcome message
├── SwipeablePropertyStack
└── Action buttons (X, Heart)

MatchesScreen
├── List of liked properties
├── Property cards with details
└── Empty state message

ProfileScreen
├── Profile picture
├── User information
├── Activity stats
└── Edit button

ProfileEditScreen
├── Photo upload
├── Form fields (name, email, etc.)
├── Validation
└── Save button
```

### 3. Widgets (Reusable Components)
```
PropertyCard
├── Property image
├── Title and location
├── Price and details
└── Swipe gestures

SwipeablePropertyStack
├── Stack of property cards
├── Swipe detection
├── Navigation between cards
└── Callback functions
```

### 4. Provider (State Management)
```
AppProvider
├── _availableProperties (properties to swipe)
├── _likedProperties (saved properties)
├── _viewedProperties (viewed properties)
├── _matches (all matches)
├── _currentUser (user info)
├── swipeProperty() (handle swipes)
├── viewProperty() (track views)
├── updateUser() (update profile)
└── initializeApp() (setup data)
```

## How Data Moves Through the App

### 1. App Startup
```
main.dart → AppProvider.initializeApp() → Sample data loaded → UI displays
```

### 2. User Swipes Right
```
User swipes → PropertyCard detects → AppProvider.swipeProperty() → 
Property moved to _likedProperties → Match created → UI updates
```

### 3. User Views Profile
```
User taps Profile tab → ProfileScreen loads → 
Displays _currentUser data → Shows activity stats
```

### 4. User Edits Profile
```
User taps Edit → ProfileEditScreen opens → 
User changes data → AppProvider.updateUser() → 
ProfileScreen updates → UI reflects changes
```

## Key Relationships

### Provider → Screens
- All screens read from AppProvider
- Screens call Provider methods to update data
- Provider notifies screens when data changes

### Models → Provider
- Provider stores lists of Model objects
- Provider methods create/update Model objects
- Models define the data structure

### Widgets → Screens
- Screens use Widgets to display data
- Widgets handle user interactions
- Widgets call Screen callbacks

## File Dependencies

```
main.dart
├── imports all screens
├── sets up navigation
└── configures app theme

screens/
├── import models
├── import providers
├── import widgets
└── handle user interactions

providers/
├── import models
├── manage app state
└── provide data to screens

widgets/
├── import models
├── display data
└── handle gestures

models/
├── define data structure
├── handle serialization
└── provide utility methods
```

## Common Patterns

### 1. State Management Pattern
```dart
// Screen reads from provider
final user = context.watch<AppProvider>().currentUser;

// Screen calls provider method
context.read<AppProvider>().swipeProperty(property, direction);
```

### 2. Navigation Pattern
```dart
// Navigate to new screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);
```

### 3. Form Handling Pattern
```dart
// Form with validation
Form(
  key: _formKey,
  child: TextFormField(
    validator: (value) => value?.isEmpty == true ? 'Required' : null,
  ),
)
```

## Memory Management

### What Gets Created When:
- **App starts**: AppProvider, sample data, initial screens
- **User swipes**: New Match objects, updated lists
- **User edits profile**: New User object with updated fields
- **User views property**: Property added to viewed list

### What Gets Disposed:
- **Controllers**: TextEditingController in forms
- **Streams**: Provider listeners when screens close
- **Images**: Cached images when not needed

## Performance Considerations

### Efficient Updates:
- Only rebuild widgets that need to change
- Use `context.watch()` for reactive updates
- Use `context.read()` for one-time actions

### Image Loading:
- Images are cached automatically
- Large images are resized before display
- Network images load asynchronously

## Security Notes

### Data Storage:
- User data stored in memory (not persistent)
- Profile images stored as file paths
- No sensitive data in logs

### Permissions:
- Photo library access for profile pictures
- Network access for property images
- No location or camera permissions needed

---

**This architecture makes the app easy to understand, modify, and extend!** 🎯
