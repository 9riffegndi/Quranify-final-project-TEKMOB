import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final bool rememberMe = prefs.getBool('remember_me') ?? false;

    if (rememberMe) {
      final String? username = prefs.getString('saved_username');
      final String? password = prefs.getString('saved_password');

      setState(() {
        _rememberMe = rememberMe;
        if (username != null) _usernameController.text = username;
        if (password != null) _passwordController.text = password;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _authService.login(
          _usernameController.text,
          _passwordController.text,
        );

        // Save credentials if remember me is checked
        if (_rememberMe) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('remember_me', true);
          await prefs.setString('saved_username', _usernameController.text);
          await prefs.setString('saved_password', _passwordController.text);
        } else {
          // Clear saved credentials if remember me is unchecked
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('remember_me', false);
          await prefs.remove('saved_username');
          await prefs.remove('saved_password');
        }

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _loginAsGuest() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.loginAsGuest();

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Guest login failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate Google login with dummy data
      await Future.delayed(const Duration(seconds: 1));

      final userData = {
        'id': 'google_123456789',
        'fullName': 'M Syukron',
        'username': 'Myukron',
        'email': 'msyukron@gmail.com',
        'dateJoined': DateTime.now().toIso8601String(),
      };

      // Save the user data using the same methods as regular login
      await _authService.loginWithSocial(
        provider: 'google',
        userData: userData,
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google login failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loginWithFacebook() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate Facebook login with dummy data
      await Future.delayed(const Duration(seconds: 1));

      final userData = {
        'id': 'fb_123456789',
        'fullName': 'M Syukron',
        'username': 'facebook_user',
        'email': 'msyukron@gmail.com',
        'dateJoined': DateTime.now().toIso8601String(),
      };

      // Save the user data using the same methods as regular login
      await _authService.loginWithSocial(
        provider: 'facebook',
        userData: userData,
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Facebook login failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset('assets/images/logo.png', height: 120),
                  const SizedBox(height: 32),

                  // Username/Email
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFB5DFE9),
                      hintText: 'Username atau Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username atau email tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFB5DFE9),
                      hintText: 'Kata Sandi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kata sandi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Remember Me Toggle
                  Row(
                    children: [
                      SizedBox(
                        height: 20, // Smaller height
                        width: 40, // Smaller width
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Switch(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value;
                              });
                            },
                            activeColor: Colors.white,
                            activeTrackColor: const Color(0xFF114F5E80),
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.grey[300],
                            thumbColor:
                                MaterialStateProperty.resolveWith<Color>((
                                  Set<MaterialState> states,
                                ) {
                                  return const Color(0xFF114F5E);
                                }),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Simpan Akun',
                        style: TextStyle(
                          color: _rememberMe
                              ? const Color(0xFF114F5E)
                              : Colors.grey[600],
                          fontWeight: _rememberMe
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF219EBC),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Masuk',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),

                  // "Atau masuk dengan" divider
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'atau masuk dengan',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Social Login Buttons
                  Row(
                    children: [
                      // Google Login
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _loginWithGoogle,
                          icon: const Icon(Icons.g_mobiledata, size: 24),
                          label: const Text('Google'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            elevation: 1,
                            side: BorderSide(color: Colors.grey[300]!),
                            minimumSize: const Size(0, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Facebook Login
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _loginWithFacebook,
                          icon: const Icon(
                            Icons.facebook,
                            color: Color(0xFF1877F2),
                          ),
                          label: const Text('Facebook'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            elevation: 1,
                            side: BorderSide(color: Colors.grey[300]!),
                            minimumSize: const Size(0, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Guest Button
                  OutlinedButton(
                    onPressed: _isLoading ? null : _loginAsGuest,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF219EBC),
                      side: const BorderSide(color: Color(0xFF219EBC)),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Masuk sebagai Tamu',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Belum punya akun?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.register,
                          );
                        },
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                            color: Color(0xFF219EBC),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
