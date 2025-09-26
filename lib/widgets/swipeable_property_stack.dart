import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import '../models/property.dart';
import 'property_card.dart';

class SwipeablePropertyStack extends StatefulWidget {
  final List<Property> properties;
  final Function(Property property, SwipeDirection direction) onSwipe;
  final Function(Property property)? onTap;

  const SwipeablePropertyStack({
    Key? key,
    required this.properties,
    required this.onSwipe,
    this.onTap,
  }) : super(key: key);

  @override
  State<SwipeablePropertyStack> createState() => _SwipeablePropertyStackState();
}

class _SwipeablePropertyStackState extends State<SwipeablePropertyStack> {
  late SwiperController _swiperController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _swiperController = SwiperController();
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  void _onSwipe(SwipeDirection direction) {
    if (_currentIndex < widget.properties.length) {
      final property = widget.properties[_currentIndex];
      widget.onSwipe(property, direction);
    }
  }

  void _handleSwipeLeft() {
    _onSwipe(SwipeDirection.left);
    _moveToNext();
  }

  void _handleSwipeRight() {
    _onSwipe(SwipeDirection.right);
    _moveToNext();
  }

  void _moveToNext() {
    if (_currentIndex < widget.properties.length - 1) {
      _swiperController.next();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.properties.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Swiper(
        controller: _swiperController,
        itemCount: widget.properties.length,
        onIndexChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        onTap: (index) {
          if (widget.onTap != null) {
            widget.onTap!(widget.properties[index]);
          }
        },
        itemBuilder: (context, index) {
          return PropertyCard(
            property: widget.properties[index],
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap!(widget.properties[index]);
              }
            },
            onSwipeLeft: _handleSwipeLeft,
            onSwipeRight: _handleSwipeRight,
          );
        },
        scrollDirection: Axis.horizontal,
        loop: false,
        scale: 0.8,
        viewportFraction: 0.9,
        physics: const BouncingScrollPhysics(),
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
