import 'dart:async';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

class UserRepository {
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _isGuestKey = 'is_guest';

  // Register a new user
  Future<UserModel> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    // Check if username or email already exists
    final existingUser = await getUserByUsernameOrEmail(username, email);
    if (existingUser != null) {
      throw Exception('Username or email already exists');
    }

    // Create new user
    final user = UserModel(
      id: const Uuid().v4(),
      fullName: fullName,
      username: username,
      email: email,
      password: password,
      dateJoined: DateTime.now(),
    );

    // Save user data
    await StorageService.saveObject(_userKey, user.toJson());
    await StorageService.saveBool(_isLoggedInKey, true);
    await StorageService.saveBool(_isGuestKey, false);

    return user;
  }

  // Login with username/email and password
  Future<UserModel> login(String usernameOrEmail, String password) async {
    final userData = await StorageService.getObject(_userKey);

    if (userData == null) {
      throw Exception('User not found');
    }

    final user = UserModel.fromJson(userData);

    // Check if username/email and password match
    if ((user.username == usernameOrEmail || user.email == usernameOrEmail) &&
        user.password == password) {
      // Update last login time
      final updatedUser = user.copyWith(lastLogin: DateTime.now());
      await StorageService.saveObject(_userKey, updatedUser.toJson());
      await StorageService.saveBool(_isLoggedInKey, true);
      await StorageService.saveBool(_isGuestKey, false);

      return updatedUser;
    } else {
      throw Exception('Invalid username/email or password');
    }
  }

  // Login as guest
  Future<void> loginAsGuest() async {
    await StorageService.saveBool(_isGuestKey, true);
    await StorageService.saveBool(_isLoggedInKey, false);
  }

  // Get current logged in user
  Future<UserModel?> getCurrentUser() async {
    final isLoggedIn = await StorageService.getBool(_isLoggedInKey);
    if (!isLoggedIn) return null;

    final userData = await StorageService.getObject(_userKey);
    if (userData == null) return null;

    return UserModel.fromJson(userData);
  }

  // Check if user is logged in (either as user or guest)
  Future<bool> isLoggedIn() async {
    final isLoggedIn = await StorageService.getBool(_isLoggedInKey);
    final isGuest = await StorageService.getBool(_isGuestKey);
    return isLoggedIn || isGuest;
  }

  // Check if current session is a guest session
  Future<bool> isGuest() async {
    return await StorageService.getBool(_isGuestKey);
  }

  // Logout
  Future<void> logout() async {
    await StorageService.saveBool(_isLoggedInKey, false);
    await StorageService.saveBool(_isGuestKey, false);
  }

  // Update user profile
  Future<UserModel> updateUser({
    String? fullName,
    String? username,
    String? email,
    String? password,
  }) async {
    final userData = await StorageService.getObject(_userKey);

    if (userData == null) {
      throw Exception('User not found');
    }

    final currentUser = UserModel.fromJson(userData);

    // If changing username or email, check if it already exists
    if ((username != null && username != currentUser.username) ||
        (email != null && email != currentUser.email)) {
      final existingUser = await getUserByUsernameOrEmail(
        username ?? currentUser.username,
        email ?? currentUser.email,
      );

      if (existingUser != null && existingUser.id != currentUser.id) {
        throw Exception('Username or email already exists');
      }
    }

    // Update user data
    final updatedUser = currentUser.copyWith(
      fullName: fullName,
      username: username,
      email: email,
      password: password,
    );

    await StorageService.saveObject(_userKey, updatedUser.toJson());

    return updatedUser;
  }

  // Delete user account
  Future<void> deleteAccount() async {
    await StorageService.remove(_userKey);
    await logout();
  }

  // Helper method to check if username or email exists
  Future<UserModel?> getUserByUsernameOrEmail(
    String username,
    String email,
  ) async {
    final userData = await StorageService.getObject(_userKey);
    if (userData == null) return null;

    final user = UserModel.fromJson(userData);
    if (user.username == username || user.email == email) {
      return user;
    }

    return null;
  }

  // Social login method
  Future<UserModel> loginWithSocial({
    required String provider,
    required Map<String, dynamic> userData,
  }) async {
    // Create a unique ID for social login if not provided
    final id = userData['id'] ?? '${provider}_${const Uuid().v4()}';

    // Create user model
    final user = UserModel(
      id: id,
      fullName: userData['fullName'] ?? 'Social User',
      username: userData['username'] ?? '${provider}_user',
      email: userData['email'] ?? '${provider}user@example.com',
      password: '', // No password for social login
      dateJoined: DateTime.now(),
      lastLogin: DateTime.now(),
      socialProvider: provider,
    );

    // Save to storage
    await StorageService.saveObject(_userKey, user.toJson());
    await StorageService.saveBool(_isLoggedInKey, true);
    await StorageService.saveBool(_isGuestKey, false);

    return user;
  }
}
