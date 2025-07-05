import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:audioplayers/audioplayers.dart';
import 'routes/routes.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Set preferred orientations to portrait only
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Initialize AudioPlayer globally for web
    if (kIsWeb) {
      // For web platform, we need special handling
      try {
        await AudioPlayer.global.setGlobalAudioContext(
          AudioContext(
            iOS: AudioContextIOS(
              category: AVAudioSessionCategory.playback,
              options: [AVAudioSessionOptions.mixWithOthers],
            ),
            android: AudioContextAndroid(
              isSpeakerphoneOn: true,
              stayAwake: true,
              contentType: AndroidContentType.music,
              usageType: AndroidUsageType.media,
            ),
          ),
        );
      } catch (e) {
        // Silently handle initialization errors on web
        print('Audio initialization error (expected on some browsers): $e');
      }
    }

    // Now we always start with the splash screen
    runApp(const MyApp());
  } catch (e) {
    print('Fatal error during app initialization: $e');
    // Fall back to a simple app if initialization fails
    runApp(
      MaterialApp(
        home: Scaffold(body: Center(child: Text('Error initializing app: $e'))),
      ),
    );
  }

  // Initialize AudioPlayer globally for web
  if (kIsWeb) {
    // For web platform, we need special handling
    try {
      await AudioPlayer.global.setGlobalAudioContext(
        AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: [AVAudioSessionOptions.mixWithOthers],
          ),
          android: AudioContextAndroid(
            isSpeakerphoneOn: true,
            stayAwake: true,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
          ),
        ),
      );
      // No need to pre-initialize with an asset
      // Instead, we'll handle audio initialization lazily when needed
    } catch (e) {
      // Silently handle initialization errors on web
      print('Audio initialization error (expected on some browsers): $e');
    }
  }

  // Now we always start with the splash screen
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: AppRoutes.getInitialRoute(),
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Quranify',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xFF219EBC),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF219EBC),
              primary: const Color(0xFF219EBC),
            ),
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Poppins',
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color(0xFF219EBC),
                ),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                  const Color(0xFF219EBC),
                ),
                side: MaterialStateProperty.all(
                  const BorderSide(color: Color(0xFF219EBC)),
                ),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                  const Color(0xFF219EBC),
                ),
              ),
            ),
          ),
          initialRoute: snapshot.data ?? AppRoutes.splash,
          onGenerateRoute: AppRoutes.generateRoute,
        );
      },
    );
  }
}
