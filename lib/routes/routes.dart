import 'package:flutter/material.dart';
import '../presentation/screens/auth/login.dart';
import '../presentation/screens/auth/register.dart';
import '../presentation/screens//home.dart';
import '../presentation/screens/splashscreen.dart';
import '../presentation/screens/alquran/surahs.dart';
import '../presentation/screens/alquran/detail_surahs.dart';

class AppRoutes {
  // Route names
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/';
  // New routes that need to be implemented
  static const String quran = '/quran';
  static const String detailSurah = '/detail-surah';
  static const String hadist = '/hadist';
  static const String profile = '/profile';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      // Placeholder for routes that haven't been implemented yet
      case quran:
        return MaterialPageRoute(builder: (_) => const SurahsScreen());
      case detailSurah:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => DetailSurahsScreen(
            surahNumber: args['surahNumber'],
            initialAyatNumber: args['ayatNumber'],
          ),
        );
      case hadist:
      case profile:
        // Temporary placeholder until screens are created
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(
                '${settings.name?.substring(1).toUpperCase()} Screen',
              ),
              backgroundColor: const Color(0xFF219EBC),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${settings.name?.substring(1).toUpperCase()} screen will be implemented soon',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, home),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF219EBC),
                    ),
                    child: const Text('Return to Home'),
                  ),
                ],
              ),
            ),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  // We always start with the splash screen now
  static Future<String> getInitialRoute() async {
    return splash;
  }
}
