/**
 * Virtual Tour Screen for Aibodes
 * 
 * This screen displays 360° virtual property tours with interactive hotspots,
 * photo galleries, and immersive viewing experiences.
 * 
 * @author Aibodes Team
 * @version 1.0.0
 */
import 'package:flutter/material.dart';
import '../services/virtual_tour_service.dart';

/**
 * Virtual Tour Screen widget
 * 
 * Displays interactive virtual tours with hotspots and photo galleries.
 */
class VirtualTourScreen extends StatefulWidget {
  /// Property ID for the virtual tour
  final String propertyId;
  
  /// Virtual tour to display (optional)
  final VirtualTour? tour;

  const VirtualTourScreen({
    super.key,
    required this.propertyId,
    this.tour,
  });

  @override
  State<VirtualTourScreen> createState() => _VirtualTourScreenState();
}

/**
 * State class for VirtualTourScreen
 * 
 * Manages the virtual tour viewing experience and user interactions.
 */
class _VirtualTourScreenState extends State<VirtualTourScreen>
    with TickerProviderStateMixin {
  /// Virtual tour service instance
  final VirtualTourService _tourService = VirtualTourService();
  
  /// Tab controller for tour sections
  late TabController _tabController;
  
  /// Current virtual tour
  VirtualTour? _currentTour;
  
  /// Photo galleries for the property
  List<PhotoGallery> _galleries = [];
  
  /// Loading state
  bool _isLoading = true;
  
  /// Current photo index in gallery
  int _currentPhotoIndex = 0;
  
  /// Page controller for photo gallery
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
    _loadTourData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  /**
   * Load virtual tour data
   */
  Future<void> _loadTourData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Load virtual tour
      if (widget.tour != null) {
        _currentTour = widget.tour;
      } else {
        final tours = await _tourService.getToursForProperty(widget.propertyId);
        if (tours.isNotEmpty) {
          _currentTour = tours.first;
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading virtual tour: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentTour?.title ?? 'Virtual Tour',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: '360° Tour'),
            Tab(text: 'Photo Gallery'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentTour == null
              ? _buildNoTourFound()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildVirtualTourView(),
                    _buildPhotoGalleryView(),
                  ],
                ),
    );
  }

  /**
   * Build no tour found message
   * 
   * @return Widget displaying no tour message
   */
  Widget _buildNoTourFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.video_camera_back,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Virtual Tour Available',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This property doesn\'t have a virtual tour yet.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Go Back'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * Build virtual tour view
   * 
   * @return Widget displaying the 360° virtual tour
   */
  Widget _buildVirtualTourView() {
    return Stack(
      children: [
        // 360° image viewer (placeholder)
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[100]!,
                Colors.blue[200]!,
              ],
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.panorama,
                  size: 100,
                  color: Colors.white,
                ),
                SizedBox(height: 16),
                Text(
                  '360° Virtual Tour',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Interactive 360° viewing experience',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Hotspots overlay
        if (_currentTour != null)
          ..._currentTour!.hotspots.map((hotspot) => _buildHotspot(hotspot)),
        
        // Tour controls
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: _buildTourControls(),
        ),
      ],
    );
  }

  /**
   * Build hotspot widget
   * 
   * @param hotspot Hotspot to display
   * @return Widget displaying the hotspot
   */
  Widget _buildHotspot(TourHotspot hotspot) {
    return Positioned(
      left: hotspot.x,
      top: hotspot.y,
      child: GestureDetector(
        onTap: () => _showHotspotInfo(hotspot),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            _getHotspotIcon(hotspot.type),
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  /**
   * Get hotspot icon
   * 
   * @param type Hotspot type
   * @return IconData for the hotspot type
   */
  IconData _getHotspotIcon(HotspotType type) {
    switch (type) {
      case HotspotType.info:
        return Icons.info;
      case HotspotType.room:
        return Icons.room;
      case HotspotType.feature:
        return Icons.star;
      case HotspotType.amenity:
        return Icons.local_activity;
    }
  }

  /**
   * Show hotspot information
   * 
   * @param hotspot Hotspot to show info for
   */
  void _showHotspotInfo(TourHotspot hotspot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(hotspot.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(hotspot.description),
            const SizedBox(height: 16),
            if (hotspot.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  hotspot.imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /**
   * Build tour controls
   * 
   * @return Widget displaying tour controls
   */
  Widget _buildTourControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.rotate_left,
            onPressed: () => _rotateLeft(),
          ),
          _buildControlButton(
            icon: Icons.zoom_in,
            onPressed: () => _zoomIn(),
          ),
          _buildControlButton(
            icon: Icons.zoom_out,
            onPressed: () => _zoomOut(),
          ),
          _buildControlButton(
            icon: Icons.rotate_right,
            onPressed: () => _rotateRight(),
          ),
        ],
      ),
    );
  }

  /**
   * Build control button
   * 
   * @param icon Button icon
   * @param onPressed Button callback
   * @return Widget displaying the control button
   */
  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  /**
   * Build photo gallery view
   * 
   * @return Widget displaying the photo gallery
   */
  Widget _buildPhotoGalleryView() {
    if (_currentTour == null) {
      return const Center(
        child: Text('No photos available'),
      );
    }

    // Mock photo gallery for demonstration
    final photos = [
      'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800',
      'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
      'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?w=800',
      'https://images.unsplash.com/photo-1560448204-61dc36dc98c8?w=800',
      'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?w=800',
    ];

    return Stack(
      children: [
        // Photo viewer
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPhotoIndex = index;
            });
          },
          itemCount: photos.length,
          itemBuilder: (context, index) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.network(
                photos[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        
        // Photo counter
        Positioned(
          top: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentPhotoIndex + 1} / ${photos.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        
        // Gallery controls
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: _buildGalleryControls(photos),
        ),
      ],
    );
  }

  /**
   * Build gallery controls
   * 
   * @param photos List of photo URLs
   * @return Widget displaying gallery controls
   */
  Widget _buildGalleryControls(List<String> photos) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Thumbnail strip
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final isSelected = index == _currentPhotoIndex;
                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        photos[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Navigation controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: Icons.arrow_back_ios,
                    onPressed: _currentPhotoIndex > 0 ? _previousPhoto : () {},
              ),
              _buildControlButton(
                icon: Icons.fullscreen,
                onPressed: () => _showFullscreenPhoto(photos[_currentPhotoIndex]),
              ),
              _buildControlButton(
                icon: Icons.arrow_forward_ios,
                    onPressed: _currentPhotoIndex < photos.length - 1 ? _nextPhoto : () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== TOUR CONTROLS ====================

  /**
   * Rotate left
   */
  void _rotateLeft() {
    // In a real implementation, this would rotate the 360° view
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rotating left...'),
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  /**
   * Rotate right
   */
  void _rotateRight() {
    // In a real implementation, this would rotate the 360° view
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rotating right...'),
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  /**
   * Zoom in
   */
  void _zoomIn() {
    // In a real implementation, this would zoom in the view
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Zooming in...'),
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  /**
   * Zoom out
   */
  void _zoomOut() {
    // In a real implementation, this would zoom out the view
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Zooming out...'),
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  // ==================== GALLERY CONTROLS ====================

  /**
   * Go to previous photo
   */
  void _previousPhoto() {
    if (_currentPhotoIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /**
   * Go to next photo
   */
  void _nextPhoto() {
    if (_currentPhotoIndex < 4) { // Mock photo count
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /**
   * Show fullscreen photo
   * 
   * @param photoUrl Photo URL to display
   */
  void _showFullscreenPhoto(String photoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullscreenPhotoViewer(photoUrl: photoUrl),
      ),
    );
  }
}

/**
 * Fullscreen Photo Viewer widget
 * 
 * Displays a single photo in fullscreen mode with zoom and pan capabilities.
 */
class FullscreenPhotoViewer extends StatefulWidget {
  /// Photo URL to display
  final String photoUrl;

  const FullscreenPhotoViewer({
    super.key,
    required this.photoUrl,
  });

  @override
  State<FullscreenPhotoViewer> createState() => _FullscreenPhotoViewerState();
}

/**
 * State class for FullscreenPhotoViewer
 * 
 * Manages fullscreen photo viewing with zoom and pan capabilities.
 */
class _FullscreenPhotoViewerState extends State<FullscreenPhotoViewer> {
  /// Transformation controller for zoom and pan
  late TransformationController _transformationController;
  
  /// Whether the photo is zoomed
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(_isZoomed ? Icons.zoom_out : Icons.zoom_in),
            onPressed: _toggleZoom,
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          transformationController: _transformationController,
          onInteractionUpdate: (details) {
            setState(() {
              _isZoomed = _transformationController.value.getMaxScaleOnAxis() > 1.0;
            });
          },
          child: Image.network(
            widget.photoUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 100,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /**
   * Toggle zoom
   */
  void _toggleZoom() {
    if (_isZoomed) {
      _transformationController.value = Matrix4.identity();
    } else {
      _transformationController.value = Matrix4.identity()..scale(2.0);
    }
    setState(() {
      _isZoomed = !_isZoomed;
    });
  }
}
