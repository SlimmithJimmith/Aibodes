import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'onboarding_screen.dart';

/**
 * Animated Splash Screen
 * 
 * Features:
 * - Beautiful heart-house logo animation
 * - Smooth entrance animations with scaling and fading
 * - Proper diacritics positioning for "Äïbodes"
 * - Dark green background matching the logo design
 * - Automatic transition to onboarding after animation
 * 
 * @author Aibödes Development Team
 * @version 1.0.0
 */
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _backgroundController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _backgroundOpacity;

  @override
  void initState() {
    super.initState();
    
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    // Background animation controller
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale and opacity animations
    _logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Text animations
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    _textSlide = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));

    // Background animation
    _backgroundOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeIn,
    ));
  }

  void _startAnimationSequence() async {
    // Start background animation immediately
    _backgroundController.forward();
    
    // Wait a moment, then start logo animation
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    
    // Wait for logo to be mostly done, then start text animation
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();
    
    // Wait for all animations to complete, then navigate to onboarding
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B5E20), // Dark green background
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  const Color(0xFF1B5E20).withOpacity(_backgroundOpacity.value),
                  const Color(0xFF0D3B0D).withOpacity(_backgroundOpacity.value),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScale.value,
                        child: Opacity(
                          opacity: _logoOpacity.value,
                          child: _buildLogo(),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Animated App Name
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _textSlide.value),
                        child: Opacity(
                          opacity: _textOpacity.value,
                          child: _buildAppName(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      child: CustomPaint(
        painter: HeartHouseLogoPainter(),
        size: const Size(120, 120),
      ),
    );
  }

  Widget _buildAppName() {
    return Text(
      'Aibödes',
      style: GoogleFonts.quicksand(
        fontSize: 32,
        fontWeight: FontWeight.w300,
        color: const Color(0xFFF5F5DC), // Light cream color
        letterSpacing: 2.0,
        height: 1.2,
      ),
    );
  }
}

/**
 * Custom painter for the heart-house logo
 * Creates a beautiful heart shape with a house inside
 */
class HeartHouseLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF5F5DC) // Light cream color
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    final strokePaint = Paint()
      ..color = const Color(0xFFF5F5DC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final heartSize = size.width * 0.4;

    // Draw heart shape
    _drawHeart(canvas, centerX, centerY, heartSize, paint, strokePaint);
    
    // Draw house inside heart
    _drawHouse(canvas, centerX, centerY, heartSize * 0.6, paint, strokePaint);
  }

  void _drawHeart(Canvas canvas, double centerX, double centerY, double size, Paint fillPaint, Paint strokePaint) {
    final path = Path();
    
    // Heart shape using cubic bezier curves - more accurate heart shape
    final leftX = centerX - size * 0.5;
    final rightX = centerX + size * 0.5;
    final topY = centerY - size * 0.4;
    final bottomY = centerY + size * 0.3;
    
    // Start from bottom point
    path.moveTo(centerX, bottomY);
    
    // Left curve - more pronounced
    path.cubicTo(
      leftX, bottomY - size * 0.15,
      leftX, topY + size * 0.2,
      leftX + size * 0.15, topY + size * 0.1,
    );
    
    // Top left curve - creating the heart's left lobe
    path.cubicTo(
      leftX + size * 0.25, topY - size * 0.1,
      centerX - size * 0.1, topY - size * 0.1,
      centerX, topY,
    );
    
    // Top right curve - creating the heart's right lobe
    path.cubicTo(
      centerX + size * 0.1, topY - size * 0.1,
      rightX - size * 0.25, topY - size * 0.1,
      rightX - size * 0.15, topY + size * 0.1,
    );
    
    // Right curve - more pronounced
    path.cubicTo(
      rightX, topY + size * 0.2,
      rightX, bottomY - size * 0.15,
      centerX, bottomY,
    );
    
    path.close();
    
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  void _drawHouse(Canvas canvas, double centerX, double centerY, double size, Paint fillPaint, Paint strokePaint) {
    // House base (rectangle) - positioned higher in the heart
    final houseWidth = size * 0.7;
    final houseHeight = size * 0.5;
    final houseLeft = centerX - houseWidth / 2;
    final houseTop = centerY - houseHeight / 2 - size * 0.1; // Move up slightly
    
    final houseRect = Rect.fromLTWH(houseLeft, houseTop, houseWidth, houseHeight);
    canvas.drawRect(houseRect, fillPaint);
    canvas.drawRect(houseRect, strokePaint);
    
    // House roof (triangle) - more pointed like in the image
    final roofHeight = size * 0.45;
    final roofTop = houseTop - roofHeight;
    
    final roofPath = Path();
    roofPath.moveTo(centerX, roofTop);
    roofPath.lineTo(houseLeft - size * 0.05, houseTop);
    roofPath.lineTo(houseLeft + houseWidth + size * 0.05, houseTop);
    roofPath.close();
    
    canvas.drawPath(roofPath, fillPaint);
    canvas.drawPath(roofPath, strokePaint);
    
    // Door (rounded arch) - more prominent
    final doorWidth = size * 0.3;
    final doorHeight = size * 0.35;
    final doorLeft = centerX - doorWidth / 2;
    final doorTop = houseTop + houseHeight - doorHeight;
    
    final doorRect = Rect.fromLTWH(doorLeft, doorTop, doorWidth, doorHeight);
    final doorPath = Path();
    doorPath.addRRect(RRect.fromRectAndRadius(doorRect, const Radius.circular(12)));
    
    canvas.drawPath(doorPath, fillPaint);
    canvas.drawPath(doorPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
