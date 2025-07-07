import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// Service untuk memutar audio huruf hijaiyah di seluruh aplikasi
class HijaiyahAudioService {
  // Singleton pattern untuk memastikan hanya ada satu instance
  static final HijaiyahAudioService _instance =
      HijaiyahAudioService._internal();

  // Factory constructor yang mengembalikan instance yang sama
  factory HijaiyahAudioService() => _instance;

  // Audio player instance
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Flag untuk menandai apakah audio sedang diputar
  bool _isAudioPlaying = false;

  // Private constructor
  HijaiyahAudioService._internal();

  /// Memutar audio huruf hijaiyah dari file yang ditentukan
  ///
  /// [audioFile] adalah nama file audio, contoh: 'alif.mp3'
  /// [fallbackAudioFile] adalah file audio alternatif jika file utama tidak tersedia
  /// [context] digunakan untuk menampilkan snackbar jika terjadi error
  /// [showFeedback] menentukan apakah feedback visual ditampilkan
  Future<void> playHijaiyahAudio(
    String audioFile, {
    String? fallbackAudioFile,
    BuildContext? context,
    bool showFeedback = true,
    String? letterName,
  }) async {
    // Hentikan audio yang sedang berjalan (jika ada)
    if (_isAudioPlaying) {
      await _audioPlayer.stop();
    }

    try {
      _isAudioPlaying = true;

      // Menggunakan AssetSource untuk path yang benar pada release mode
      // Format path: 'audio/hijaiyah/alif.mp3'
      await _audioPlayer.play(AssetSource('audio/hijaiyah/$audioFile'));

      // Tambahkan listener untuk menandai bahwa audio selesai diputar
      _audioPlayer.onPlayerComplete.listen((_) {
        _isAudioPlaying = false;
      });

      // Tampilkan feedback jika diminta dan context tersedia
      if (showFeedback && context != null && letterName != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Melafalkan: $letterName'),
            backgroundColor: const Color(0xFF219EBC),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print('Error memainkan audio hijaiyah: $e');

      // Coba putar fallback audio jika tersedia
      if (fallbackAudioFile != null) {
        try {
          print('Mencoba fallback audio: $fallbackAudioFile');
          await _audioPlayer.play(
            AssetSource('audio/hijaiyah/$fallbackAudioFile'),
          );
        } catch (fallbackError) {
          print('Error memainkan fallback audio: $fallbackError');
          _handleAudioError(context);
        }
      } else {
        _handleAudioError(context);
      }

      _isAudioPlaying = false;
    }
  }

  /// Menangani error pemutaran audio
  void _handleAudioError(BuildContext? context) {
    // Tampilkan error message jika context tersedia
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memainkan audio'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Memeriksa apakah audio sedang diputar
  bool get isPlaying => _isAudioPlaying;

  /// Menghentikan pemutaran audio yang sedang berjalan
  Future<void> stopAudio() async {
    if (_isAudioPlaying) {
      await _audioPlayer.stop();
      _isAudioPlaying = false;
    }
  }

  /// Mengatur volume audio (0.0 - 1.0)
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  /// Membersihkan resource audio player
  void dispose() {
    _audioPlayer.dispose();
    _isAudioPlaying = false;
  }

  /// Preload audio untuk mengurangi latensi saat pertama kali diputar
  Future<void> preloadCommonAudio() async {
    try {
      // Preload beberapa huruf yang sering digunakan
      final commonLetters = [
        'alif.mp3',
        'ba.mp3',
        'ta.mp3',
        'jim.mp3',
        'dal.mp3',
      ];

      for (final letter in commonLetters) {
        try {
          await _audioPlayer.setSourceAsset('audio/hijaiyah/$letter');
          // Berikan sedikit jeda agar tidak membebani sistem
          await Future.delayed(const Duration(milliseconds: 100));
        } catch (e) {
          print('Error preloading audio $letter: $e');
          // Lanjutkan ke file berikutnya
          continue;
        }
      }
    } catch (e) {
      print('Error pada preloading audio: $e');
    }
  }
}
