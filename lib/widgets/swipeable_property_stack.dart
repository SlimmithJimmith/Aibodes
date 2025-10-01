import 'package:flutter/material.dart';
import '../models/property.dart';
import 'property_card.dart';

class SwipeablePropertyStack extends StatefulWidget {
  final List<Property> properties;
  final Function(Property property, SwipeDirection direction) onSwipe;
  final Function(Property property)? onTap;
  final bool isBuyer; // Add user type parameter

  const SwipeablePropertyStack({
    Key? key,
    required this.properties,
    required this.onSwipe,
    this.onTap,
    this.isBuyer = true, // Default to buyer
  }) : super(key: key);

  @override
  State<SwipeablePropertyStack> createState() => _SwipeablePropertyStackState();
}

class _SwipeablePropertyStackState extends State<SwipeablePropertyStack> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onSwipe(SwipeDirection direction) {
    if (_currentIndex < widget.properties.length) {
      final property = widget.properties[_currentIndex];
      widget.onSwipe(property, direction);
    }
  }

  void _handleSwipeLeft() {
    print('SwipeablePropertyStack: Swipe left handled');
    _onSwipe(SwipeDirection.left);
    _moveToNext();
  }

  void _handleSwipeRight() {
    print('SwipeablePropertyStack: Swipe right handled');
    _onSwipe(SwipeDirection.right);
    _moveToNext();
  }

  void _moveToNext() {
    if (_currentIndex < widget.properties.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.properties.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: widget.properties.length,
        itemBuilder: (context, index) {
          return PropertyCard(
            property: widget.properties[index],
            isBuyer: widget.isBuyer, // Pass user type to PropertyCard
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap!(widget.properties[index]);
              }
            },
            onSwipeLeft: _handleSwipeLeft,
            onSwipeRight: _handleSwipeRight,
          );
        },
        // Disable PageView's built-in swipe detection
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No more properties',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new listings!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum SwipeDirection {
  left,
  right,
}
