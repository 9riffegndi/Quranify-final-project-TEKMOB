import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _currentUrl;

  // Current playback state
  bool get isPlaying => _isPlaying;
  String? get currentUrl => _currentUrl;

  // Initialize audio player
  AudioPlayerService() {
    // Ensure we have properly handled event listeners
    try {
      _audioPlayer.onPlayerComplete.listen((_) {
        _isPlaying = false;
        _currentUrl = null;
      });
    } catch (e) {
      print('Error setting onPlayerComplete: $e');
    }

    try {
      _audioPlayer.onPlayerStateChanged.listen((state) {
        if (state == PlayerState.completed) {
          _isPlaying = false;
          _currentUrl = null;
        }
      });
    } catch (e) {
      print('Error setting onPlayerStateChanged: $e');
    }

    // Additional error handler for web platform
    if (kIsWeb) {
      try {
        // Set a reasonable volume to start
        _audioPlayer.setVolume(0.7);

        // Set playback rate to normal
        _audioPlayer.setPlaybackRate(1.0);
      } catch (e) {
        print('Error setting additional web properties: $e');
      }
    }

    // Configure player for web platform
    _configurePlayer();
  }

  // Configure player based on platform
  void _configurePlayer() {
    try {
      if (kIsWeb) {
        // Web-specific configuration with safer options
        // Use 'stop' mode on web to prevent JavaScript interop issues
        _audioPlayer.setReleaseMode(ReleaseMode.stop);

        try {
          // Safer context setup for web
          _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
        } catch (e) {
          print('Error setting player mode: $e');
        }

        try {
          // Web-specific audio context with minimal settings
          _audioPlayer.setAudioContext(AudioContext());
        } catch (contextError) {
          print('Error setting audio context: $contextError');
        }
      } else {
        // Mobile-specific configuration
        _audioPlayer.setReleaseMode(ReleaseMode.stop);
        _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);

        // On mobile we can safely set the full audio context
        _audioPlayer.setAudioContext(
          AudioContext(
            android: AudioContextAndroid(
              isSpeakerphoneOn: true,
              stayAwake: true,
              contentType: AndroidContentType.music,
              usageType: AndroidUsageType.media,
            ),
            iOS: AudioContextIOS(
              category: AVAudioSessionCategory.playback,
              options: [AVAudioSessionOptions.mixWithOthers],
            ),
          ),
        );
      }
    } catch (e) {
      print('Error configuring audio player: $e');
    }
  }

  // Play audio from URL
  Future<void> play(String url) async {
    try {
      if (_isPlaying) {
        if (_currentUrl == url) {
          // If same URL is already playing, pause it
          await pause();
          return;
        } else {
          // If different URL, stop current and play new one
          await stop();
        }
      }

      // Handle CORS issues for web by modifying URL if needed
      String playUrl = url;

      // Web-specific handling to avoid JavaScript interop errors
      if (kIsWeb) {
        try {
          // For web, we need to be more careful with how we play audio
          // First stop any existing playback to avoid conflicts
          await _audioPlayer.stop();

          // Use setSourceUrl which is more reliable on web
          await _audioPlayer.setSourceUrl(playUrl);

          // Small delay to let the source be properly set
          await Future.delayed(const Duration(milliseconds: 300));

          // Resume instead of direct play to avoid JS interop issues
          await _audioPlayer.resume();
        } catch (webError) {
          print('Web-specific audio error: $webError');

          // Try alternative approach if the first one fails
          try {
            final source = UrlSource(playUrl);
            // Set volume to avoid loud playback
            await _audioPlayer.setVolume(0.7);
            await _audioPlayer.play(source);
          } catch (fallbackError) {
            print('Web fallback audio error: $fallbackError');
            rethrow;
          }
        }
      } else {
        // For mobile, the normal approach works fine
        await _audioPlayer.setSource(UrlSource(playUrl));
        await _audioPlayer.resume();
      }

      _isPlaying = true;
      _currentUrl = url;
    } catch (e) {
      print('Error playing audio: $e');
      _isPlaying = false;
      rethrow; // Rethrow to handle in UI
    }
  }

  // Pause current playback
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      _isPlaying = false;
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  // Resume paused playback
  Future<void> resume() async {
    try {
      if (_currentUrl != null) {
        await _audioPlayer.resume();
        _isPlaying = true;
      }
    } catch (e) {
      print('Error resuming audio: $e');
    }
  }

  // Stop playback
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
      _currentUrl = null;
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  // Dispose resources
  void dispose() {
    _audioPlayer.dispose();
  }
}
