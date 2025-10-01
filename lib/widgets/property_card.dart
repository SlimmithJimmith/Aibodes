import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/property.dart';

class PropertyCard extends StatefulWidget {
  final Property property;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onTap;
  final bool isBuyer; // Add user type parameter

  const PropertyCard({
    Key? key,
    required this.property,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onTap,
    this.isBuyer = true, // Default to buyer
  }) : super(key: key);

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late AnimationController _borderController;
  
  late Animation<double> _heartScale;
  late Animation<double> _heartOpacity;
  late Animation<double> _borderOpacity;
  
  bool _showHeart = false;
  bool _showBorder = false;
  Color _borderColor = const Color(0xFF00FF7F); // Default green for like
  bool _hasTriggeredSwipe = false; // Prevent multiple triggers

  @override
  void initState() {
    super.initState();
    
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _borderController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _heartScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: Curves.elasticOut,
    ));

    _heartOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _borderOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _borderController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _heartController.dispose();
    _borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onPanStart: (details) {
        _hasTriggeredSwipe = false; // Reset flag on new pan
      },
      onPanEnd: (details) {
        if (_hasTriggeredSwipe) return; // Prevent multiple triggers
        
        // Check for significant swipe
        if (details.velocity.pixelsPerSecond.dx > 300) {
          // Swipe right - like
          print('Swipe right detected - showing animation');
          _hasTriggeredSwipe = true;
          _showSwipeAnimation(true);
          widget.onSwipeRight?.call();
        } else if (details.velocity.pixelsPerSecond.dx < -300) {
          // Swipe left - dislike
          print('Swipe left detected - showing animation');
          _hasTriggeredSwipe = true;
          _showSwipeAnimation(false);
          widget.onSwipeLeft?.call();
        }
      },
      child: AnimatedBuilder(
        animation: _borderController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0), // No border radius for full screen
              border: _showBorder ? Border.all(
                color: _borderColor.withOpacity(_borderOpacity.value),
                width: 4,
              ) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                if (_showBorder)
                  BoxShadow(
                    color: _borderColor.withOpacity(0.4 * _borderOpacity.value),
                    blurRadius: 25,
                    spreadRadius: 3,
                  ),
              ],
            ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0), // No border radius for full screen
          child: Stack(
            children: [
              // Property Image
              Container(
                height: double.infinity,
                width: double.infinity,
                    child: widget.property.images.isNotEmpty
                    ? CachedNetworkImage(
                            imageUrl: widget.property.images.first,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.home,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.home,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
              ),
              
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.3, 1.0],
                  ),
                ),
              ),
              
              // Property details
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price and type
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                                widget.property.formattedPrice,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                                  widget.property.type.displayName,
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Title
                      Text(
                            widget.property.title,
                        style: GoogleFonts.dancingScript(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Location
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                                  widget.property.location,
                              style: GoogleFonts.quicksand(
                                color: Colors.white70,
                                fontSize: 14,
                                letterSpacing: 0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Property details
                      Text(
                            widget.property.propertyDetails,
                        style: GoogleFonts.quicksand(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Neon heart animation overlay (will be shown when swiping right)
              _buildNeonHeartOverlay(),
            ],
          ),
        ),
          );
        },
      ),
    );
  }

  void _showSwipeAnimation(bool isLike) {
    setState(() {
      _showHeart = isLike; // Only show heart for likes
      _showBorder = true;
      if (isLike) {
        // Use blue for buyer, green for seller when liking
        _borderColor = widget.isBuyer ? const Color(0xFF00BFFF) : const Color(0xFF00FF7F);
      } else {
        // Red for dislike regardless of user type
        _borderColor = const Color(0xFFFF4444);
      }
    });
    
    _borderController.forward();
    if (isLike) {
      _heartController.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              _showHeart = false;
              _showBorder = false;
            });
            _heartController.reset();
            _borderController.reset();
          }
        });
      });
    } else {
      // For dislike, just show border animation
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _showBorder = false;
          });
          _borderController.reset();
        }
      });
    }
  }

  Widget _buildNeonHeartOverlay() {
    if (!_showHeart) return const SizedBox.shrink();
    
    return AnimatedBuilder(
      animation: _heartController,
      builder: (context, child) {
        return Center(
          child: Transform.scale(
            scale: _heartScale.value,
            child: Opacity(
              opacity: _heartOpacity.value,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _borderColor.withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                      color: _borderColor.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.favorite,
                  color: _borderColor,
                  size: 60,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}
