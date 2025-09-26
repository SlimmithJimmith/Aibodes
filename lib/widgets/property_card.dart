import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/property.dart';

class PropertyCard extends StatefulWidget {
  final Property property;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onTap;

  const PropertyCard({
    Key? key,
    required this.property,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onTap,
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
      onPanEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 500) {
          _showHeartAnimation();
          widget.onSwipeRight?.call();
        } else if (details.velocity.pixelsPerSecond.dx < -500) {
          widget.onSwipeLeft?.call();
        }
      },
      child: AnimatedBuilder(
        animation: _borderController,
        builder: (context, child) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: _showBorder ? Border.all(
                color: const Color(0xFF00FF7F).withOpacity(_borderOpacity.value),
                width: 3,
              ) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                if (_showBorder)
                  BoxShadow(
                    color: const Color(0xFF00FF7F).withOpacity(0.3 * _borderOpacity.value),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
              ],
            ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
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

  void _showHeartAnimation() {
    setState(() {
      _showHeart = true;
      _showBorder = true;
    });
    
    _borderController.forward();
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
                  color: const Color(0xFF00FF7F).withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00FF7F).withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Color(0xFF00FF7F),
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
