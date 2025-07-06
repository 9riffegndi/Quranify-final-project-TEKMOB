import 'package:flutter/material.dart';
import '../presentation/screens/auth/login.dart';
import '../presentation/screens/auth/register.dart';
import '../presentation/screens//home.dart';
import '../presentation/screens/splashscreen.dart';
import '../presentation/screens/alquran/surahs.dart';
import '../presentation/screens/alquran/detail_surahs.dart';
import '../presentation/screens/hadith/hadist.dart';
import '../presentation/screens/hadith/detail_hadith.dart';
import '../presentation/screens/youtube/youtube_videos_screen.dart';
import '../presentation/screens/youtube/youtube_player_screen.dart'
    as player; // Import with alias
import '../presentation/screens/profile/myprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static const String detailHadith = '/detail-hadith';
  static const String profile = '/profile';
  static const String youtubeVideos = '/youtube-videos';
  static const String youtubePlayer = '/youtube-player'; // YouTube player route

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Save the current route whenever navigation happens (except for splash screen)
    if (settings.name != null && settings.name != splash) {
      saveCurrentRoute(settings.name!);
    }

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
        return MaterialPageRoute(builder: (_) => const HadistScreen());
      case detailHadith:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => DetailHadithScreen(
            bookId: args['bookId'],
            hadithNumber: args['hadithNumber'],
          ),
        );
      case youtubeVideos:
        return MaterialPageRoute(builder: (_) => const YouTubeVideosScreen());
      case youtubePlayer:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => player.YouTubePlayerScreen(
            videoId: args['videoId'],
            title: args['title'],
          ),
        );
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  // Store the current route to maintain it on refresh
  static Future<void> saveCurrentRoute(String route) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_route', route);
  }

  // Get the stored route or default to splash screen
  static Future<String> getInitialRoute() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedRoute = prefs.getString('current_route');

      // If no stored route or it's the splash route, return splash
      // Otherwise return the stored route
      return storedRoute != null && storedRoute != splash
          ? storedRoute
          : splash;
    } catch (e) {
      // If any error occurs, default to splash screen
      return splash;
    }
  }
}
