/**
 * Kelas konfigurasi untuk fitur AI Quranify
 * 
 * Berisi semua pengaturan yang dibutuhkan untuk menjalankan AI assistant
 * termasuk API key, model configuration, dan pesan default
 */
class AIConfig {
  /// API Key untuk Google Gemini AI
  /// Dapatkan dari: https://makersuite.google.com/app/apikey
  /// PENTING: Ganti dengan API key Anda sendiri sebelum production
  static const String googleAIApiKey = 'AIzaSyDZJiGb9tUTGw4K9xfeY1iy1FS5JgGMdJU';
  
  /// Model AI yang digunakan
  /// gemini-1.5-flash: Model cepat dan efisien untuk conversational AI
  /// Alternative: gemini-1.5-pro untuk respons yang lebih detail
  static const String modelName = 'gemini-1.5-flash';
  
  /// Batas maksimal token (kata) dalam respons AI
  /// 1000 tokens ≈ 750 kata dalam bahasa Indonesia
  /// Mencegah respons yang terlalu panjang dan menghemat quota API
  static const int maxTokens = 1000;
  
  /// Tingkat kreativitas AI (0.0 - 1.0)
  /// 0.0: Sangat konsisten, selalu jawaban yang sama
  /// 1.0: Sangat kreatif, jawaban bervariasi
  /// 0.7: Seimbang antara konsistensi dan variasi
  static const double temperature = 0.7;
  
  /// Jumlah maksimal pesan yang diingat AI dalam satu sesi
  /// Semakin tinggi = AI lebih ingat konteks percakapan
  /// Semakin rendah = Performa lebih cepat, memory lebih hemat
  static const int maxHistoryLength = 50;
  
  /// Pesan pembuka yang ditampilkan saat user pertama kali membuka chat
  /// Menggunakan format Markdown untuk styling yang lebih menarik
  /// Menjelaskan fitur-fitur yang tersedia dalam AI assistant
  static const String welcomeMessage = '''Assalamu'alaikum wa rahmatullahi wa barakatuh! 🌙

Saya adalah **Asisten AI Quranify**, siap membantu Anda dengan:

✨ **Pertanyaan tentang Al-Quran dan Islam**
📖 **Rekomendasi ayat sesuai perasaan**
📚 **Hadist dan sunnah Rasul**
🤲 **Panduan hidup Islami**

Silakan tanya apa saja yang ingin Anda ketahui! 😊''';
  
  /// Mengecek apakah API key sudah dikonfigurasi
  /// Returns true jika API key tidak kosong
  static bool get isConfigured => googleAIApiKey.isNotEmpty;
  
  /// Mengecek apakah API key masih menggunakan placeholder
  /// Returns true jika masih menggunakan contoh API key
  static bool get isPlaceholder => googleAIApiKey.startsWith('YOUR_') || 
                                  googleAIApiKey.contains('PLACEHOLDER');
}
