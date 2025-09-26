# PropertySwipe Demo Guide 🎬

This guide will walk you through the key features of the PropertySwipe app.

## App Overview

PropertySwipe is a real estate app that combines the familiar Tinder swiping interface with property browsing. Users can swipe through properties, like the ones they're interested in, and get matched with sellers.

## Key Features Demo

### 1. Home Screen - Property Discovery 🏠

**What you'll see:**
- Welcome message with user name
- Number of available properties
- Swipeable property cards with:
  - High-quality property images
  - Price and property type
  - Location and basic details
  - Bedrooms, bathrooms, and square footage

**How to interact:**
- **Swipe Right**: Like a property (creates a potential match)
- **Swipe Left**: Pass on a property
- **Tap Card**: View detailed property information
- **Use Action Buttons**: Red X to pass, Green heart to like

### 2. Property Details Screen 📋

**What you'll see:**
- Full-screen property images
- Detailed property information
- Property specifications (bedrooms, bathrooms, area)
- Property description
- Contact options

**How to interact:**
- **Back Button**: Return to home screen
- **Heart Icon**: Add to favorites
- **Share Icon**: Share property
- **Send Message**: Contact seller
- **Call Now**: Call seller directly

### 3. Matches Screen 💕

**What you'll see:**
- List of all your property matches
- Match status (Pending, Accepted, Declined)
- Match timestamp
- Contact options for each match

**How to interact:**
- **View Details**: See match information
- **Contact Seller**: Open chat or contact form
- **Match Status**: See current status of each match

## Sample Data

The app comes with 5 sample properties:

1. **Modern Downtown Apartment** - $450K, 2 bed/2 bath, 1200 sq ft
2. **Cozy Family House** - $650K, 4 bed/3 bath, 2500 sq ft
3. **Luxury Penthouse** - $1.2M, 3 bed/3 bath, 2000 sq ft
4. **Charming Studio** - $280K, 1 bed/1 bath, 600 sq ft
5. **Spacious Townhouse** - $750K, 3 bed/2 bath, 1800 sq ft

## User Flow Example

1. **Start the app** - You'll see the home screen with available properties
2. **Swipe through properties** - Use swipe gestures or action buttons
3. **Like a property** - Swipe right or tap the green heart
4. **View matches** - Go to the Matches tab to see your matches
5. **Contact sellers** - Use the contact options to reach out

## Tips for Testing

- **Try different swipe speeds** - Fast swipes vs slow swipes
- **Use both gesture and button controls** - Test both interaction methods
- **Check the matches screen** - See how matches are created and managed
- **Explore property details** - Tap on cards to see full information
- **Test the refresh functionality** - Use the refresh button to reset the app

## Expected Behavior

- **Smooth animations** - Cards should animate smoothly when swiped
- **Visual feedback** - Snackbar messages for like/pass actions
- **Match creation** - Liking a property should create a match
- **Navigation** - Smooth transitions between screens
- **Responsive design** - App should work on different screen sizes

## Troubleshooting Demo Issues

If something doesn't work as expected:

1. **Check Flutter installation** - Run `flutter doctor`
2. **Restart the app** - Use the refresh button or restart Flutter
3. **Check console output** - Look for error messages
4. **Verify dependencies** - Run `flutter pub get`

## Next Steps After Demo

Once you've explored the basic functionality:

1. **Customize the UI** - Modify colors, fonts, and layouts
2. **Add real data** - Connect to a real estate API
3. **Implement authentication** - Add user login/signup
4. **Add more features** - Chat, favorites, search, etc.
5. **Deploy the app** - Build for iOS/Android app stores

Happy exploring! 🎉
