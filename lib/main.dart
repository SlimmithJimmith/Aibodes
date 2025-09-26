// Import Flutter's material design components for UI
import 'package:flutter/material.dart';
// Import Provider package for state management
import 'package:provider/provider.dart';
// Import our custom app provider for managing app state
import 'providers/app_provider.dart';
// Import models for navigation
import 'models/property.dart';
// Import our custom screens
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/matches_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/advanced_search_screen.dart';
import 'screens/mortgage_calculator_screen.dart';
import 'screens/map_screen.dart';
import 'screens/property_detail_screen.dart';
import 'screens/premium_features_screen.dart';
import 'screens/virtual_tour_screen.dart';
import 'screens/neighborhood_insights_screen.dart';
import 'screens/agent_integration_screen.dart';

/**
 * Main entry point of the Aibodes application
 * This function initializes and runs the Flutter app
 */
void main() {
  // Start the Flutter app with MyApp as the root widget
  runApp(const MyApp());
}

/**
 * Root widget of the Aibodes application
 * 
 * This class sets up the overall app structure including:
 * - Global state management using Provider
 * - App theme and styling
 * - Navigation structure
 * 
 * @author Aibodes Team
 * @version 1.0.0
 */
class MyApp extends StatelessWidget {
  /**
   * Constructor for MyApp
   * @param key Optional key for widget identification
   */
  const MyApp({Key? key}) : super(key: key);

  /**
   * Builds the main app widget tree
   * 
   * This method creates the app structure with:
   * - Provider for state management
   * - MaterialApp for Material Design
   * - Global theme configuration
   * - MainScreen as the home widget
   * 
   * @param context The build context
   * @return The complete app widget tree
   */
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Create and provide AppProvider instance to all child widgets
      // This allows any widget in the app to access and modify app state
      create: (context) => AppProvider(),
      child: MaterialApp(
        // App title displayed in system UI
        title: 'Äïbodes',
        
        // Global theme configuration for consistent styling
        theme: ThemeData(
          // Primary color scheme - dark theme
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF00BFFF),
          
          // Background color for scaffold (main app background) - Black theme
          scaffoldBackgroundColor: Colors.black,
          
          // App bar styling - black background with white text
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,     // Black app bar background
            foregroundColor: Colors.white,     // White text and icons
            elevation: 0,                      // No shadow/elevation
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Button styling - neon blue background with white text
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BFFF),  // Neon blue button background
              foregroundColor: Colors.white,             // White button text
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),  // More rounded corners
              ),
              elevation: 8,  // Add elevation for glow effect
              shadowColor: const Color(0xFF00BFFF).withOpacity(0.3),
            ),
          ),
          
          // Card styling - dark background with neon glow
          cardTheme: CardThemeData(
            color: const Color(0xFF1A1A1A),         // Dark card background
            elevation: 4,                          // Enhanced shadow for glow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),  // More rounded corners
            ),
            shadowColor: const Color(0xFF00BFFF).withOpacity(0.2),
          ),
        ),
        
        // Set OnboardingScreen as the home widget (first screen shown)
        home: const OnboardingScreen(),
        
        // Route definitions for navigation
            routes: {
              '/main': (context) => const MainScreen(),
              '/advanced-search': (context) => const AdvancedSearchScreen(),
              '/mortgage-calculator': (context) => const MortgageCalculatorScreen(),
              '/map': (context) => const MapScreen(),
              '/premium-features': (context) => const PremiumFeaturesScreen(),
              '/virtual-tour': (context) {
                final propertyId = ModalRoute.of(context)!.settings.arguments as String;
                return VirtualTourScreen(propertyId: propertyId);
              },
              '/neighborhood-insights': (context) {
                final property = ModalRoute.of(context)!.settings.arguments as Property;
                return NeighborhoodInsightsScreen(property: property);
              },
              '/agent-integration': (context) {
                final property = ModalRoute.of(context)?.settings.arguments as Property?;
                return AgentIntegrationScreen(property: property);
              },
              '/property-details': (context) {
                final property = ModalRoute.of(context)!.settings.arguments as Property;
                return PropertyDetailScreen(property: property);
              },
            },
        
        // Hide the debug banner in release builds
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

/**
 * Main screen widget that handles bottom navigation between app sections
 * 
 * This screen provides the main navigation structure with three tabs:
 * - Discover: Swipe through properties (HomeScreen)
 * - Matches: View saved/liked properties (MatchesScreen)  
 * - Profile: User profile and settings (ProfileScreen)
 * 
 * @author Aibodes Team
 * @version 1.0.0
 */
class MainScreen extends StatefulWidget {
  /**
   * Constructor for MainScreen
   * @param key Optional key for widget identification
   */
  const MainScreen({Key? key}) : super(key: key);

  /**
   * Creates the state for this StatefulWidget
   * @return _MainScreenState instance
   */
  @override
  State<MainScreen> createState() => _MainScreenState();
}

/**
 * State class for MainScreen that manages navigation state
 * 
 * This class handles:
 * - Current tab index tracking
 * - Screen switching logic
 * - Bottom navigation bar rendering
 */
class _MainScreenState extends State<MainScreen> {
  /**
   * Index of the currently selected tab (0-2)
   * 0 = Discover tab (HomeScreen)
   * 1 = Matches tab (MatchesScreen)
   * 2 = Profile tab (ProfileScreen)
   */
  int _currentIndex = 0;

  /**
   * List of all available screens in the app
   * Each index corresponds to a tab in the bottom navigation
   */
  final List<Widget> _screens = [
    const HomeScreen(),      // Tab 0: Property discovery/swiping
    const MatchesScreen(),   // Tab 1: Saved/liked properties
    const ProfileScreen(),   // Tab 2: User profile and settings
  ];

  /**
   * Builds the main screen with bottom navigation
   * 
   * This method creates:
   * - A Scaffold with the current screen as body
   * - Bottom navigation bar with three tabs
   * - Tab switching functionality
   * 
   * @param context The build context
   * @return The complete main screen widget
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the currently selected screen
      body: _screens[_currentIndex],
      
      // Bottom navigation bar for tab switching
      bottomNavigationBar: BottomNavigationBar(
        // Index of currently selected tab
        currentIndex: _currentIndex,
        
        // Callback when user taps a tab
        onTap: (index) {
          setState(() {
            _currentIndex = index;  // Update current tab index
          });
        },
        
        // Fixed type ensures all tabs are always visible
        type: BottomNavigationBarType.fixed,
        
        // White background for navigation bar
        backgroundColor: Colors.white,
        
        // Blue color for selected tab
        selectedItemColor: Colors.blue[600],
        
        // Grey color for unselected tabs
        unselectedItemColor: Colors.grey[600],
        
        // Define the three navigation tabs
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),     // Home icon for Discover tab
            label: 'Discover',          // Tab label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite), // Heart icon for Matches tab
            label: 'Matches',           // Tab label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),   // Person icon for Profile tab
            label: 'Profile',           // Tab label
          ),
        ],
      ),
    );
  }
}
