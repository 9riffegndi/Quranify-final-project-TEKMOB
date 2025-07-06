import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class AuthService {
  final UserRepository _userRepository = UserRepository();

  // Register a new user
  Future<UserModel> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    return await _userRepository.register(
      fullName: fullName,
      username: username,
      email: email,
      password: password,
    );
  }

  // Login with username/email and password
  Future<UserModel> login(String usernameOrEmail, String password) async {
    return await _userRepository.login(usernameOrEmail, password);
  }

  // Login as guest
  Future<void> loginAsGuest() async {
    await _userRepository.loginAsGuest();
  }

  // Get current logged in user
  Future<UserModel?> getCurrentUser() async {
    return await _userRepository.getCurrentUser();
  }

  // Check if user is logged in (either as user or guest)
  Future<bool> isLoggedIn() async {
    return await _userRepository.isLoggedIn();
  }

  // Check if current session is a guest session
  Future<bool> isGuest() async {
    return await _userRepository.isGuest();
  }

  // Logout
  Future<void> logout() async {
    await _userRepository.logout();
  }

  // Social login (Google, Facebook, etc.)
  Future<UserModel> loginWithSocial({
    required String provider,
    required Map<String, dynamic> userData,
  }) async {
    return await _userRepository.loginWithSocial(
      provider: provider,
      userData: userData,
    );
  }
}
