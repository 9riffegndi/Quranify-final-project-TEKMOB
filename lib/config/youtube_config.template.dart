/// Konfigurasi untuk YouTube API
/// File ini berisi API key dan konstanta untuk mengakses YouTube Data API v3
///
/// TEMPLATE FILE: Copy this file to youtube_config.dart and replace with your own API key
class YouTubeConfig {
  // API Key YouTube - Ganti dengan API key Anda yang baru
  // Get an API key from: https://console.cloud.google.com/apis/credentials
  static const String apiKey = 'YOUR_YOUTUBE_API_KEY_HERE';

  // Base URL untuk YouTube Data API v3
  static const String baseUrl = 'https://www.googleapis.com/youtube/v3';

  // Channel ID untuk konten Islami terkenal (opsional)
  static const Map<String, String> islamicChannels = {
    'yufid': 'UCkCJ03-d5kicGpO7td6Ja_g',
    'rodja': 'UCYfqjjGbZwLWQCqMV9kF9_Q',
    'nuon': 'UCMuUlMZSyoNVOlBkTsLfxfg',
    // Tambahkan channel lain di sini
  };

  // Keyword pencarian untuk konten Islami
  static const List<String> islamicKeywords = [
    'kajian islam',
    'ustadz ceramah',
    'ngaji online',
    'tafsir quran',
    'hadits nabi',
    'ceramah singkat',
    'dakwah islam',
    // Tambahkan keyword lain di sini
  ];
}
