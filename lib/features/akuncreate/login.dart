import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:quranify/features/akuncreate/daftar.dart' show DaftarScreen;
import 'package:quranify/features/home.dart';

=======
import '../home/home.dart';
import 'daftar.dart';
>>>>>>> 28c93fc7073dcbd3e374fcd60304384f28f4f43b

class LoginScreen extends StatefulWidget {
  final String? defaultUsername;
  final String? defaultPassword;

  const LoginScreen({super.key, this.defaultUsername, this.defaultPassword});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.defaultUsername ?? '');
    passwordController = TextEditingController(text: widget.defaultPassword ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/images/icon.png', width: 150, height: 100),
              const SizedBox(height: 32),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (val) {
                      setState(() {
                        _rememberMe = val ?? false;
                      });
                    },
                  ),
                  const Text('Simpan Akun'),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 49,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF219EBC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
<<<<<<< HEAD
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (val) {
                        setState(() {
                          _rememberMe = val ?? false;
                        });
                      },
                    ),
                    const Text(
                      'Simpan Akun',
                      style: TextStyle(
                        color: Color(0xFF114F5E),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tombol Login
          Positioned(
            left: 62,
            right: 62,
            top: screenHeight * 0.60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF219EBC),
                minimumSize: const Size(double.infinity, 49),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Tambahkan aksi login di sini
                 Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );
              },
              child: const Text(
                'Masuk',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          // Divider dan "Atau masuk dengan"
          Positioned(
            left: 19,
            right: 19,
            top: screenHeight * 0.72,
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Color(0xFFD9D9D9),
                        thickness: 1,
                      ),
                    ),
                    Container(
=======
                  onPressed: () {
                    final username = usernameController.text.trim();
                    final password = passwordController.text;

                    if (username.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Username dan password wajib diisi')),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    }
                  },
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
>>>>>>> 28c93fc7073dcbd3e374fcd60304384f28f4f43b
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Belum punya akun? ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Daftar',
                      style: const TextStyle(color: Color(0xFF219EBC)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const DaftarScreen()),
                          );
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
