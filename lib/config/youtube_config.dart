/// Konfigurasi untuk YouTube API
/// File ini berisi API key dan konstanta untuk mengakses YouTube Data API v3
class YouTubeConfig {
  // API Key YouTube - Ganti dengan API key Anda yang baru
  //static const String apiKey = '';
  static const String apiKey = 'AIzaSyDSpFYeDzBfOgHOR6o3pu_yY_nFFeYPMVU';

  // Base URL untuk YouTube Data API v3
  //static const String baseUrl = '';
  static const String baseUrl = 'https://www.googleapis.com/youtube/v3';

  // Channel ID untuk konten Islami terkenal (opsional)
  static const Map<String, String> islamicChannels = {
    'yufid': 'UCkCJ03-d5kicGpO7td6Ja_g',
    'rodja': 'UCYfqjjGbZwLWQCqMV9kF9_Q',
    'nuon': 'UCMuUlMZSyoNVOlBkTsLfxfg',
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
  ];
}
