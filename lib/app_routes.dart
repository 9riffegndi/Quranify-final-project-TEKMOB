import 'package:flutter/material.dart';
import 'features/akuncreate/login.dart';
import 'features/home/home.dart';
import 'features/quran/alquran_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String quran = '/quran';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case quran:
        return MaterialPageRoute(builder: (_) => const AlquranScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Halaman tidak ditemukan')),
          ),
        );
    }
  }
}
