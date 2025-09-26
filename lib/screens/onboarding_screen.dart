import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'step_by_step_onboarding.dart';

/**
 * Onboarding Screen - Beautiful first-time user experience
 * 
 * Features:
 * - Black background with neon-style buttons
 * - Elegant typography with cursive fonts
 * - Seamless buyer/seller selection
 * - Premium iPhone-like design aesthetic
 * 
 * @author Aibodes Development Team
 * @version 1.0.0
 */
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _glowController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _startAnimations();
  }

  /**
   * Starts the entrance animations in sequence
   */
  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _fadeController.forward();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _slideController.forward();
    
    await Future.delayed(const Duration(milliseconds: 500));
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF000000),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo/Title
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Aibödes',
                        style: GoogleFonts.dancingScript(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your Real Estate Journey Starts Here',
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),

                // "Pick One" Title
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Pick One',
                    style: GoogleFonts.dancingScript(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Buyer and Seller Buttons - Side by Side Layout
                SlideTransition(
                  position: _slideAnimation,
                  child: Row(
                    children: [
                      // Buyer Button - Left
                      Expanded(
                        child: _buildNeonButton(
                          title: 'Buyer',
                          subtitle: 'Find Your Dream Home',
                          color: const Color(0xFF00BFFF),
                          icon: Icons.home,
                          onTap: () => _navigateToBuyerFlow(),
                          isLarge: true,
                        ),
                      ),
                      
                      const SizedBox(width: 20),
                      
                      // Seller Button - Right
                      Expanded(
                        child: _buildNeonButton(
                          title: 'Seller',
                          subtitle: 'List Your Property',
                          color: const Color(0xFF00FF7F),
                          icon: Icons.sell,
                          onTap: () => _navigateToSellerFlow(),
                          isLarge: true,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // Subtle hint text
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Choose your path to begin',
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: Colors.white38,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /**
   * Builds a neon-style button with glow effect
   */
  Widget _buildNeonButton({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
    bool isLarge = false,
  }) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            height: isLarge ? 280 : 200,
            width: isLarge ? double.infinity : null,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3 * _glowAnimation.value),
                  blurRadius: 25 * _glowAnimation.value,
                  spreadRadius: 3 * _glowAnimation.value,
                ),
                BoxShadow(
                  color: color.withOpacity(0.15 * _glowAnimation.value),
                  blurRadius: 50 * _glowAnimation.value,
                  spreadRadius: 6 * _glowAnimation.value,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.15),
                    color.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with glow
                  Container(
                    padding: EdgeInsets.all(isLarge ? 20 : 16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.25),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.4),
                          blurRadius: isLarge ? 20 : 15,
                          spreadRadius: isLarge ? 3 : 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      size: isLarge ? 48 : 32,
                      color: color,
                    ),
                  ),
                  
                  SizedBox(height: isLarge ? 20 : 16),
                  
                  // Title
                  Text(
                    title,
                    style: GoogleFonts.dancingScript(
                      fontSize: isLarge ? 36 : 28,
                      fontWeight: FontWeight.bold,
                      color: color,
                      letterSpacing: 1.2,
                    ),
                  ),
                  
                  SizedBox(height: isLarge ? 12 : 8),
                  
                  // Subtitle
                  Text(
                    subtitle,
                    style: GoogleFonts.quicksand(
                      fontSize: isLarge ? 16 : 12,
                      color: Colors.white70,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /**
   * Navigates to buyer onboarding flow
   */
  void _navigateToBuyerFlow() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const StepByStepOnboarding(isBuyer: true),
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

  /**
   * Navigates to seller onboarding flow
   */
  void _navigateToSellerFlow() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const StepByStepOnboarding(isBuyer: false),
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

/**
 * Buyer Onboarding Screen - Collects buyer information
 * 
 * Features:
 * - Elegant form design with smooth animations
 * - Collects name, demographics, and income information
 * - Maintains consistent black theme with blue accents
 * 
 * @author Aibodes Development Team
 * @version 1.0.0
 */
class BuyerOnboardingScreen extends StatefulWidget {
  const BuyerOnboardingScreen({Key? key}) : super(key: key);

  @override
  State<BuyerOnboardingScreen> createState() => _BuyerOnboardingScreenState();
}

class _BuyerOnboardingScreenState extends State<BuyerOnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _incomeController = TextEditingController();
  
  String _selectedGender = '';
  String _selectedMaritalStatus = '';
  String _selectedOccupation = '';

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF000000),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    
                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Title
                    Text(
                      'Tell Us About Yourself',
                      style: GoogleFonts.dancingScript(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Help us find your perfect home',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        color: Colors.white70,
                        letterSpacing: 0.5,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            icon: Icons.person,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 24),
                          
                          _buildTextField(
                            controller: _ageController,
                            label: 'Age',
                            icon: Icons.cake,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your age';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid age';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 24),
                          
                          _buildDropdownField(
                            label: 'Gender',
                            icon: Icons.person_outline,
                            value: _selectedGender,
                            items: ['Male', 'Female', 'Other', 'Prefer not to say'],
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                          
                          const SizedBox(height: 24),
                          
                          _buildDropdownField(
                            label: 'Marital Status',
                            icon: Icons.favorite,
                            value: _selectedMaritalStatus,
                            items: ['Single', 'Married', 'Divorced', 'Widowed'],
                            onChanged: (value) {
                              setState(() {
                                _selectedMaritalStatus = value!;
                              });
                            },
                          ),
                          
                          const SizedBox(height: 24),
                          
                          _buildTextField(
                            controller: _incomeController,
                            label: 'Estimated Annual Income',
                            icon: Icons.attach_money,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your income';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid income';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 24),
                          
                          _buildDropdownField(
                            label: 'Occupation',
                            icon: Icons.work,
                            value: _selectedOccupation,
                            items: [
                              'Software Engineer',
                              'Doctor',
                              'Teacher',
                              'Business Owner',
                              'Sales',
                              'Marketing',
                              'Finance',
                              'Other'
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedOccupation = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Continue Button
                    _buildContinueButton(),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /**
   * Builds a styled text field with neon blue accent
   */
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00BFFF).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00BFFF).withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: GoogleFonts.quicksand(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.quicksand(
            color: Colors.white70,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF00BFFF),
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  /**
   * Builds a styled dropdown field
   */
  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00BFFF).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00BFFF).withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value.isEmpty ? null : value,
        onChanged: onChanged,
        style: GoogleFonts.quicksand(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.quicksand(
            color: Colors.white70,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF00BFFF),
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        dropdownColor: const Color(0xFF1A1A1A),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /**
   * Builds the continue button with neon effect
   */
  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF00BFFF),
            Color(0xFF0080FF),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00BFFF).withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _handleContinue,
          child: Center(
            child: Text(
              'Continue',
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /**
   * Handles the continue button tap
   */
  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      // Save buyer information and navigate to main screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Welcome to Aibodes!',
            style: GoogleFonts.quicksand(),
          ),
          backgroundColor: const Color(0xFF00BFFF),
        ),
      );
      
      // Navigate to main screen
      Navigator.pushReplacementNamed(context, '/main');
    }
  }
}

/**
 * Seller Onboarding Screen - Placeholder for seller flow
 * 
 * @author Aibodes Development Team
 * @version 1.0.0
 */
class SellerOnboardingScreen extends StatelessWidget {
  const SellerOnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Seller Flow',
              style: GoogleFonts.dancingScript(
                fontSize: 36,
                color: const Color(0xFF00FF7F),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Coming Soon!',
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FF7F),
                foregroundColor: Colors.black,
              ),
              child: Text(
                'Go Back',
                style: GoogleFonts.quicksand(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
