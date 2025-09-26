/**
 * Authentication Service for User Management
 * 
 * This service handles all user authentication operations including:
 * - Email/password authentication
 * - Google Sign-In integration
 * - User registration and verification
 * - Password reset functionality
 * - Session management
 * 
 * @author Aibodes Team
 * @version 2.0.0
 */

import 'dart:io';
import '../models/user.dart';
import '../models/property.dart';

/**
 * Authentication Service Class
 * 
 * Manages user authentication, registration, and profile management
 * using local storage and mock authentication for development.
 */
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  User? _currentUser;
  final List<User> _users = [];

  /**
   * Get current user
   * 
   * @return Current user or null if not authenticated
   */
  User? get currentUser => _currentUser;

  /**
   * Check if user is currently authenticated
   * 
   * @return True if user is authenticated
   */
  bool get isAuthenticated => _currentUser != null;

  /**
   * Register new user with email and password
   * 
   * @param email User's email address
   * @param password User's password
   * @param firstName User's first name
   * @param lastName User's last name
   * @return Custom User object or null if registration failed
   */
  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      // Check if user already exists
      if (_users.any((user) => user.email == email)) {
        throw Exception('An account already exists for this email');
      }

      // Create new user
      final customUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: '',
        address: '',
        profileImage: '',
        type: UserType.buyer,
        isVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        preferences: const [],
      );

      _users.add(customUser);
      _currentUser = customUser;
      return customUser;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /**
   * Sign in with email and password
   * 
   * @param email User's email address
   * @param password User's password
   * @return Custom User object or null if sign in failed
   */
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Find user by email
      final user = _users.firstWhere(
        (user) => user.email == email,
        orElse: () => throw Exception('No user found for this email'),
      );

      _currentUser = user;
      return user;
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  /**
   * Sign in with Google (mock implementation)
   * 
   * @return Custom User object or null if sign in failed
   */
  Future<User?> signInWithGoogle() async {
    try {
      // Mock Google sign-in for development
      final customUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: 'user@gmail.com',
        firstName: 'Google',
        lastName: 'User',
        phoneNumber: '',
        address: '',
        profileImage: '',
        type: UserType.buyer,
        isVerified: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        preferences: const [],
      );

      _users.add(customUser);
      _currentUser = customUser;
      return customUser;
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  /**
   * Sign out current user
   * 
   * @return Future that completes when sign out is done
   */
  Future<void> signOut() async {
    try {
      _currentUser = null;
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  /**
   * Send password reset email (mock implementation)
   * 
   * @param email User's email address
   * @return Future that completes when email is sent
   */
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // Mock password reset for development
      await Future.delayed(const Duration(seconds: 1));
      print('Password reset email sent to: $email');
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  /**
   * Update user password (mock implementation)
   * 
   * @param currentPassword Current password
   * @param newPassword New password
   * @return Future that completes when password is updated
   */
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No authenticated user');
      
      // Mock password update for development
      await Future.delayed(const Duration(seconds: 1));
      print('Password updated for user: ${user.email}');
    } catch (e) {
      throw Exception('Password update failed: $e');
    }
  }

  /**
   * Update user profile information
   * 
   * @param user Custom user object with updated information
   * @return Future that completes when profile is updated
   */
  Future<void> updateUserProfile(User user) async {
    try {
      // Update user in local storage
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _users[index] = user;
        if (_currentUser?.id == user.id) {
          _currentUser = user;
        }
      }
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }

  /**
   * Upload and update user profile image (mock implementation)
   * 
   * @param imagePath Local path to image file
   * @return Download URL of uploaded image
   */
  Future<String> uploadProfileImage(String imagePath) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No authenticated user');

      // Mock image upload for development
      await Future.delayed(const Duration(seconds: 2));
      final mockUrl = 'https://example.com/profile_images/${user.id}.jpg';
      
      // Update user profile with new image URL
      final updatedUser = user.copyWith(profileImage: mockUrl);
      await updateUserProfile(updatedUser);
      
      return mockUrl;
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  /**
   * Delete user account
   * 
   * @return Future that completes when account is deleted
   */
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No authenticated user');

      // Remove user from local storage
      _users.removeWhere((u) => u.id == user.id);
      _currentUser = null;
    } catch (e) {
      throw Exception('Account deletion failed: $e');
    }
  }
}

