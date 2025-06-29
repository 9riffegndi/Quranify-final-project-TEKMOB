import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'features/akuncreate/login.dart';
import 'features/home/home.dart'; // ✅ pastikan path sesuai dengan file HomeScreen kamu
import 'features/quran/alquran_screen.dart'; // ✅ pastikan path sesuai dengan file AlquranScreen kamu

void main() {
  runApp(const Quranify());
}

class Quranify extends StatelessWidget {
  const Quranify({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quranify',
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Awal aplikasi di SplashScreen
      routes: {
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.quran: (_) => const AlquranScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (_) => const SplashScreen());
        }
        return AppRoutes.generateRoute(settings);
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _scale = 0.8;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });

    Future.delayed(const Duration(seconds: 3), () {
      // Navigasi ke halaman login lewat routing
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 500),
          child: Transform.scale(
            scale: _scale,
            child: Image.asset('assets/images/icon.png', width: screenWidth * 0.5),
          ),
        ),
      ),
    );
  }
}
