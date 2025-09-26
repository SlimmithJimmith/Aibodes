import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

/**
 * Step-by-Step Onboarding System
 * 
 * Features:
 * - Single question per screen with smooth animations
 * - Beautiful transitions between steps
 * - Input validation for each field
 * - Separate flows for buyers and sellers
 * 
 * @author Aibodes Development Team
 * @version 1.0.0
 */
class StepByStepOnboarding extends StatefulWidget {
  final bool isBuyer;
  
  const StepByStepOnboarding({
    Key? key,
    required this.isBuyer,
  }) : super(key: key);

  @override
  State<StepByStepOnboarding> createState() => _StepByStepOnboardingState();
}

class _StepByStepOnboardingState extends State<StepByStepOnboarding>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  int _currentStep = 0;
  final _formData = <String, dynamic>{};
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Define steps for buyer and seller
  late List<OnboardingStep> _steps;

  @override
  void initState() {
    super.initState();
    
    _initializeAnimations();
    _initializeSteps();
    _startAnimations();
    
    // Add listener to text controller to update button state
    _textController.addListener(() {
      setState(() {
        // This will trigger a rebuild and update the button state
      });
    });
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
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
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
  }

  void _initializeSteps() {
    if (widget.isBuyer) {
      _steps = [
        OnboardingStep(
          title: "What should we call you?",
          subtitle: "Let's start with your first name",
          fieldName: "firstName",
          displayName: "first name",
          inputType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your first name';
            }
            if (RegExp(r'[0-9]').hasMatch(value)) {
              return 'Name should not contain numbers';
            }
            return null;
          },
        ),
        OnboardingStep(
          title: "And your last name?",
          subtitle: "What's your family name?",
          fieldName: "lastName",
          displayName: "last name",
          inputType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your last name';
            }
            if (RegExp(r'[0-9]').hasMatch(value)) {
              return 'Name should not contain numbers';
            }
            return null;
          },
        ),
        OnboardingStep(
          title: "How old are you?",
          subtitle: "This helps us find age-appropriate properties",
          fieldName: "age",
          displayName: "age",
          inputType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your age';
            }
            final age = int.tryParse(value);
            if (age == null || age < 18 || age > 100) {
              return 'Please enter a valid age (18-100)';
            }
            return null;
          },
        ),
        OnboardingStep(
          title: "What's your email?",
          subtitle: "We'll use this to send you property updates",
          fieldName: "email",
          displayName: "email",
          inputType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        OnboardingStep(
          title: "What's your gender?",
          subtitle: "This helps us personalize your experience",
          fieldName: "gender",
          displayName: "gender",
          inputType: null,
          isDropdown: true,
          dropdownOptions: ['Male', 'Female', 'Other', 'Prefer not to say'],
        ),
        OnboardingStep(
          title: "What's your marital status?",
          subtitle: "This helps us understand your housing needs",
          fieldName: "maritalStatus",
          displayName: "marital status",
          inputType: null,
          isDropdown: true,
          dropdownOptions: ['Single', 'Married', 'Divorced', 'Widowed'],
        ),
        OnboardingStep(
          title: "What's your annual income?",
          subtitle: "This helps us find properties in your budget",
          fieldName: "income",
          displayName: "annual income",
          inputType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your income';
            }
            final income = int.tryParse(value);
            if (income == null || income < 0) {
              return 'Please enter a valid income';
            }
            return null;
          },
        ),
        OnboardingStep(
          title: "What do you do for work?",
          subtitle: "Tell us about your occupation",
          fieldName: "occupation",
          displayName: "occupation",
          inputType: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your occupation';
            }
            return null;
          },
        ),
      ];
    } else {
      _steps = [
        OnboardingStep(
          title: "What should we call you?",
          subtitle: "Let's start with your first name",
          fieldName: "firstName",
          displayName: "first name",
          inputType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your first name';
            }
            if (RegExp(r'[0-9]').hasMatch(value)) {
              return 'Name should not contain numbers';
            }
            return null;
          },
        ),
        OnboardingStep(
          title: "And your last name?",
          subtitle: "What's your family name?",
          fieldName: "lastName",
          displayName: "last name",
          inputType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your last name';
            }
            if (RegExp(r'[0-9]').hasMatch(value)) {
              return 'Name should not contain numbers';
            }
            return null;
          },
        ),
        OnboardingStep(
          title: "What's your email?",
          subtitle: "We'll use this to connect you with buyers",
          fieldName: "email",
          displayName: "email",
          inputType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        OnboardingStep(
          title: "What's your phone number?",
          subtitle: "Buyers will contact you directly",
          fieldName: "phone",
          displayName: "phone number",
          inputType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (!RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(value)) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
        OnboardingStep(
          title: "What type of property do you have?",
          subtitle: "Select the category that best describes your property",
          fieldName: "propertyType",
          displayName: "property type",
          inputType: null,
          isDropdown: true,
          dropdownOptions: ['House', 'Apartment', 'Condo', 'Townhouse', 'Land', 'Commercial'],
        ),
        OnboardingStep(
          title: "What's your property's address?",
          subtitle: "Where is your property located?",
          fieldName: "propertyAddress",
          displayName: "property address",
          inputType: TextInputType.streetAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your property address';
            }
            return null;
          },
        ),
        OnboardingStep(
          title: "What's your asking price?",
          subtitle: "How much are you looking to sell for?",
          fieldName: "askingPrice",
          displayName: "asking price",
          inputType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your asking price';
            }
            final price = int.tryParse(value);
            if (price == null || price < 0 || price > 1000000000) {
              return 'Please enter a valid price';
            }
            return null;
          },
        ),
        OnboardingStep(
          title: "Tell us about your property",
          subtitle: "Describe what makes your property special",
          fieldName: "propertyDescription",
          displayName: "property description",
          inputType: TextInputType.multiline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please describe your property';
            }
            return null;
          },
        ),
      ];
    }
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStepData = _steps[_currentStep];
    
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
              children: [
                // Progress indicator
                _buildProgressIndicator(),
                
                const SizedBox(height: 60),
                
                // Main content
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              currentStepData.title,
                              style: GoogleFonts.dancingScript(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.0,
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Subtitle
                            Text(
                              currentStepData.subtitle,
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                color: Colors.white70,
                                letterSpacing: 0.5,
                              ),
                            ),
                            
                            const SizedBox(height: 40),
                            
                            // Input field
                            _buildInputField(currentStepData),
                            
                            const Spacer(),
                            
                            // Continue button
                            _buildContinueButton(),
                            
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
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

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: _goBack,
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
          
          const SizedBox(width: 20),
          
          // Progress bar
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (_currentStep + 1) / _steps.length,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.isBuyer 
                        ? const Color(0xFF00BFFF) 
                        : const Color(0xFF00FF7F),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 20),
          
          // Step counter
          Text(
            '${_currentStep + 1}/${_steps.length}',
            style: GoogleFonts.quicksand(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(OnboardingStep step) {
    if (step.isDropdown) {
      return _buildDropdownField(step);
    } else {
      return _buildTextField(step);
    }
  }

  Widget _buildTextField(OnboardingStep step) {
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (widget.isBuyer 
                ? const Color(0xFF00BFFF) 
                : const Color(0xFF00FF7F)).withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (widget.isBuyer 
                  ? const Color(0xFF00BFFF) 
                  : const Color(0xFF00FF7F)).withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: (widget.isBuyer 
                  ? const Color(0xFF00BFFF) 
                  : const Color(0xFF00FF7F)).withOpacity(0.1),
              blurRadius: 25,
              spreadRadius: 4,
            ),
          ],
        ),
        child: TextFormField(
          controller: _textController,
          keyboardType: step.inputType,
          maxLines: step.inputType == TextInputType.multiline ? 4 : 1,
          validator: step.validator,
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            hintText: step.inputType == TextInputType.multiline 
                ? 'Describe your property...' 
                : 'Enter your ${step.displayName}',
            hintStyle: GoogleFonts.quicksand(
              color: Colors.white38,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(OnboardingStep step) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (widget.isBuyer 
              ? const Color(0xFF00BFFF) 
              : const Color(0xFF00FF7F)).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (widget.isBuyer 
                ? const Color(0xFF00BFFF) 
                : const Color(0xFF00FF7F)).withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: (widget.isBuyer 
                ? const Color(0xFF00BFFF) 
                : const Color(0xFF00FF7F)).withOpacity(0.1),
            blurRadius: 25,
            spreadRadius: 4,
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _formData[step.fieldName],
        onChanged: (value) {
          setState(() {
            _formData[step.fieldName] = value;
          });
        },
        style: GoogleFonts.quicksand(
          color: Colors.white,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          hintText: 'Select ${step.displayName}',
          hintStyle: GoogleFonts.quicksand(
            color: Colors.white38,
            fontSize: 16,
          ),
        ),
        dropdownColor: const Color(0xFF1A1A1A),
        items: step.dropdownOptions!.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(
              option,
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

  Widget _buildContinueButton() {
    final isLastStep = _currentStep == _steps.length - 1;
    final currentStepData = _steps[_currentStep];
    
    // Check if we can continue based on the current step type
    bool canContinue = false;
    if (currentStepData.isDropdown) {
      canContinue = _formData[currentStepData.fieldName] != null &&
                   _formData[currentStepData.fieldName].toString().isNotEmpty;
    } else {
      // For text fields, check if the text controller has content
      canContinue = _textController.text.trim().isNotEmpty;
    }
    
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: canContinue ? [
            widget.isBuyer 
                ? const Color(0xFF00BFFF) 
                : const Color(0xFF00FF7F),
            widget.isBuyer 
                ? const Color(0xFF0080FF) 
                : const Color(0xFF00CC66),
          ] : [
            Colors.grey.withOpacity(0.3),
            Colors.grey.withOpacity(0.2),
          ],
        ),
        boxShadow: canContinue ? [
          BoxShadow(
            color: (widget.isBuyer 
                ? const Color(0xFF00BFFF) 
                : const Color(0xFF00FF7F)).withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ] : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: canContinue ? _handleContinue : null,
          child: Center(
            child: Text(
              isLastStep ? 'Complete Setup' : 'Continue',
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: canContinue ? Colors.white : Colors.grey,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleContinue() {
    final currentStepData = _steps[_currentStep];
    
    if (currentStepData.isDropdown) {
      if (_formData[currentStepData.fieldName] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select an option'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      // Save the text field data
      _formData[currentStepData.fieldName] = _textController.text;
    }
    
    // Proceed to next step or complete onboarding
    if (_currentStep < _steps.length - 1) {
      _nextStep();
    } else {
      _completeOnboarding();
    }
  }

  void _nextStep() {
    setState(() {
      _currentStep++;
      _textController.clear();
    });
    
    // Reset animations
    _fadeController.reset();
    _slideController.reset();
    _scaleController.reset();
    
    // Start new animations
    _startAnimations();
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _textController.clear();
      });
      
      // Reset animations
      _fadeController.reset();
      _slideController.reset();
      _scaleController.reset();
      
      // Start new animations
      _startAnimations();
    } else {
      Navigator.pop(context);
    }
  }

  void _completeOnboarding() {
    // Save user data to AppProvider
    final appProvider = context.read<AppProvider>();
    
    // Create user profile from collected data
    final userData = {
      'firstName': _formData['firstName'] ?? '',
      'lastName': _formData['lastName'] ?? '',
      'email': _formData['email'] ?? '',
      'isBuyer': widget.isBuyer,
    };
    
    // Add buyer-specific data
    if (widget.isBuyer) {
      userData.addAll({
        'age': _formData['age'] ?? '',
        'gender': _formData['gender'] ?? '',
        'maritalStatus': _formData['maritalStatus'] ?? '',
        'income': _formData['income'] ?? '',
        'occupation': _formData['occupation'] ?? '',
      });
    } else {
      // Add seller-specific data
      userData.addAll({
        'phone': _formData['phone'] ?? '',
        'propertyType': _formData['propertyType'] ?? '',
        'propertyAddress': _formData['propertyAddress'] ?? '',
        'askingPrice': _formData['askingPrice'] ?? '',
        'propertyDescription': _formData['propertyDescription'] ?? '',
      });
    }
    
    // Update user profile in AppProvider
    appProvider.updateUserProfile(userData);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Welcome to Aibödes!',
          style: GoogleFonts.quicksand(),
        ),
        backgroundColor: widget.isBuyer 
            ? const Color(0xFF00BFFF) 
            : const Color(0xFF00FF7F),
      ),
    );
    
    Navigator.pushReplacementNamed(context, '/main');
  }
}

/**
 * Data class for onboarding steps
 */
class OnboardingStep {
  final String title;
  final String subtitle;
  final String fieldName;
  final String displayName;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final bool isDropdown;
  final List<String>? dropdownOptions;

  OnboardingStep({
    required this.title,
    required this.subtitle,
    required this.fieldName,
    required this.displayName,
    this.inputType,
    this.validator,
    this.isDropdown = false,
    this.dropdownOptions,
  });
}
