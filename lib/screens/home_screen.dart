// Import Flutter's material design components
import 'package:flutter/material.dart';
// Import Provider package for state management
import 'package:provider/provider.dart';
// Import Google Fonts for beautiful typography
import 'package:google_fonts/google_fonts.dart';
// Import our custom app provider for managing app state
import '../providers/app_provider.dart';
// Import custom widgets
import '../widgets/swipeable_property_stack.dart';
// Import other screens for navigation
import 'property_detail_screen.dart';
import 'profile_screen.dart';
import 'matches_screen.dart';

/**
 * HomeScreen widget - The main swiping interface for property discovery
 * 
 * This screen provides the primary user interface for the Aibodes app:
 * - Displays available properties in a swipeable stack
 * - Shows user welcome message and property count
 * - Provides navigation to other app sections
 * - Handles property swiping interactions
 * - Tracks property views for analytics
 * 
 * The screen automatically initializes the app with sample data when first loaded.
 * 
 * @author Aibodes Team
 * @version 1.0.0
 */
class HomeScreen extends StatefulWidget {
  /**
   * Constructor for HomeScreen
   * @param key Optional key for widget identification
   */
  const HomeScreen({Key? key}) : super(key: key);

  /**
   * Creates the state for this StatefulWidget
   * @return _HomeScreenState instance
   */
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/**
 * State class for HomeScreen that manages the main swiping interface
 * 
 * This class handles:
 * - App initialization on screen load
 * - User interactions with property cards
 * - Navigation to other screens
 * - Swipe feedback and animations
 */
class _HomeScreenState extends State<HomeScreen> {
  /**
   * Initializes the screen and sets up the app
   * 
   * This method is called once when the widget is first created.
   * It ensures the app is initialized with sample data after the
   * widget tree is built.
   */
  @override
  void initState() {
    super.initState();
    
    // Initialize the app after the widget tree is built
    // This ensures all widgets are ready before initializing data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().initializeApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Aibödes',
          style: GoogleFonts.dancingScript(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/advanced-search');
            },
            tooltip: 'Advanced Search',
          ),
          IconButton(
            icon: const Icon(Icons.map, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/map');
            },
            tooltip: 'Property Map',
          ),
        IconButton(
          icon: const Icon(Icons.calculate, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/mortgage-calculator');
          },
          tooltip: 'Mortgage Calculator',
        ),
        IconButton(
          icon: const Icon(Icons.star, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/premium-features');
          },
          tooltip: 'Premium Features',
        ),
        IconButton(
          icon: const Icon(Icons.location_city, color: Colors.white),
          onPressed: () {
            // Show neighborhood insights for the first available property
            final properties = context.read<AppProvider>().availableProperties;
            if (properties.isNotEmpty) {
              Navigator.pushNamed(
                context,
                '/neighborhood-insights',
                arguments: properties.first,
              );
            }
          },
          tooltip: 'Neighborhood Insights',
        ),
        IconButton(
          icon: const Icon(Icons.people, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/agent-integration');
          },
          tooltip: 'Connect with Agents',
        ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MatchesScreen(),
                ),
              );
            },
            tooltip: 'Matches',
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            tooltip: 'Profile',
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          if (appProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              // User info
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue[100],
                      child: Text(
                        appProvider.currentUser?.firstName.substring(0, 1) ?? 'U',
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back, ${appProvider.currentUser?.firstName ?? 'User'}!',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${appProvider.availableProperties.length} properties available',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Swipeable properties
              Expanded(
                child: SwipeablePropertyStack(
                  properties: appProvider.availableProperties,
                  onSwipe: (property, direction) {
                    appProvider.swipeProperty(property, direction);
                    _showSwipeFeedback(direction);
                  },
                  onTap: (property) {
                    appProvider.viewProperty(property);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertyDetailScreen(
                          property: property,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Action buttons
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.close,
                      color: Colors.red,
                      onTap: () {
                        if (appProvider.availableProperties.isNotEmpty) {
                          appProvider.swipeProperty(
                            appProvider.availableProperties.first,
                            SwipeDirection.left,
                          );
                        }
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.favorite,
                      color: Colors.green,
                      onTap: () {
                        if (appProvider.availableProperties.isNotEmpty) {
                          appProvider.swipeProperty(
                            appProvider.availableProperties.first,
                            SwipeDirection.right,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  void _showSwipeFeedback(SwipeDirection direction) {
    final message = direction == SwipeDirection.right ? 'Liked!' : 'Passed';
    final color = direction == SwipeDirection.right ? Colors.green : Colors.red;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
