import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/chat_message.dart';
import '../config/ai_config.dart';
import 'package:uuid/uuid.dart';

/**
 * Service utama untuk berinteraksi dengan Google Gemini AI
 * 
 * Menyediakan berbagai fungsi untuk mengolah pertanyaan pengguna
 * dan memberikan jawaban yang berkaitan dengan Al-Quran dan Islam
 */
class AIService {
  /// Instance model Google Gemini AI
  late GenerativeModel _model;
  
  /// Generator UUID untuk membuat ID unik setiap pesan
  final _uuid = const Uuid();

  /**
   * Constructor untuk menginisialisasi AI service
   * 
   * Membuat instance GenerativeModel dengan konfigurasi dari AIConfig
   * Model dan API key diambil dari file konfigurasi
   */
  AIService() {
    _model = GenerativeModel(
      model: AIConfig.modelName,
      apiKey: AIConfig.googleAIApiKey,
    );
  }

  /**
   * Menjawab pertanyaan umum tentang Al-Quran dan Islam
   * 
   * Menggunakan prompt yang dirancang khusus untuk memberikan jawaban
   * yang akurat berdasarkan Al-Quran dan Hadist sahih
   * 
   * @param question - Pertanyaan dari pengguna
   * @return ChatMessage dengan jawaban dari AI
   */
  Future<ChatMessage> askQuranQuestion(String question) async {
    try {
      // Prompt yang dirancang khusus untuk pertanyaan Islam
      final prompt = '''
      Anda adalah asisten AI yang khusus membantu dengan pertanyaan tentang Al-Quran dan Islam.
      Berikan jawaban yang akurat, berdasarkan Al-Quran dan Hadist sahih.
      Gunakan bahasa Indonesia yang baik dan benar.
      Jika tidak yakin, katakan bahwa Anda tidak yakin dan sarankan untuk bertanya kepada ulama.
      
      Pertanyaan: $question
      
      Jawaban:
      ''';

      // Kirim prompt ke AI dan dapatkan respons
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      // Buat ChatMessage dengan respons AI
      return ChatMessage(
        id: _uuid.v4(),
        text: response.text ?? 'Maaf, saya tidak dapat memberikan jawaban saat ini.',
        isUser: false,
        timestamp: DateTime.now(),
        type: MessageType.islamicQuestion,
      );
    } catch (e) {
      // Handle error dan berikan pesan error yang user-friendly
      return ChatMessage(
        id: _uuid.v4(),
        text: 'Terjadi kesalahan: ${e.toString()}',
        isUser: false,
        timestamp: DateTime.now(),
        type: MessageType.text,
      );
    }
  }

  /**
   * Memberikan rekomendasi ayat Al-Quran berdasarkan mood/perasaan
   * 
   * Menganalisis perasaan pengguna dan memberikan ayat yang sesuai
   * dengan format yang terstruktur (Arab, terjemahan, penjelasan)
   * 
   * @param mood - Deskripsi perasaan atau mood pengguna
   * @return ChatMessage dengan rekomendasi ayat
   */
  Future<ChatMessage> getQuranRecommendation(String mood) async {
    try {
      // Prompt khusus untuk rekomendasi ayat berdasarkan mood
      final prompt = '''
      Berdasarkan perasaan/mood: "$mood"
      
      Rekomendasikan 1-2 ayat Al-Quran yang sesuai dengan perasaan tersebut.
      Format jawaban:
      
      **Surah [Nama Surah] ayat [nomor]:**
      "[Ayat dalam bahasa Arab]"
      
      **Terjemahan:**
      "[Terjemahan dalam bahasa Indonesia]"
      
      **Penjelasan:**
      "[Penjelasan singkat mengapa ayat ini sesuai dengan perasaan tersebut]"
      
      Berikan jawaban dalam bahasa Indonesia yang mudah dipahami.
      ''';

      // Kirim prompt ke AI
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      // Buat ChatMessage dengan tipe quranRecommendation
      return ChatMessage(
        id: _uuid.v4(),
        text: response.text ?? 'Maaf, tidak dapat memberikan rekomendasi saat ini.',
        isUser: false,
        timestamp: DateTime.now(),
        type: MessageType.quranRecommendation,
      );
    } catch (e) {
      // Handle error dengan pesan yang user-friendly
      return ChatMessage(
        id: _uuid.v4(),
        text: 'Terjadi kesalahan: ${e.toString()}',
        isUser: false,
        timestamp: DateTime.now(),
        type: MessageType.text,
      );
    }
  }

  /**
   * Memberikan rekomendasi hadist berdasarkan topik tertentu
   * 
   * Mencari hadist sahih yang relevan dengan topik yang diminta
   * dan memberikan penjelasan serta aplikasi praktisnya
   * 
   * @param topic - Topik atau tema hadist yang dicari
   * @return ChatMessage dengan rekomendasi hadist
   */
  Future<ChatMessage> getHadithRecommendation(String topic) async {
    try {
      // Prompt khusus untuk rekomendasi hadist berdasarkan topik
      final prompt = '''
      Berdasarkan topik: "$topic"
      
      Berikan 1-2 hadist sahih yang berkaitan dengan topik tersebut.
      Format jawaban:
      
      **Hadist Riwayat [Nama Perawi]:**
      "[Teks hadist dalam bahasa Arab]"
      
      **Terjemahan:**
      "[Terjemahan dalam bahasa Indonesia]"
      
      **Penjelasan:**
      "[Penjelasan singkat tentang makna dan aplikasi hadist tersebut]"
      
      Pastikan hadist yang diberikan adalah hadist sahih dan berikan jawaban dalam bahasa Indonesia.
      ''';

      // Kirim prompt ke AI
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      // Buat ChatMessage dengan tipe hadithRecommendation
      return ChatMessage(
        id: _uuid.v4(),
        text: response.text ?? 'Maaf, tidak dapat memberikan rekomendasi hadist saat ini.',
        isUser: false,
        timestamp: DateTime.now(),
        type: MessageType.hadithRecommendation,
      );
    } catch (e) {
      // Handle error dengan pesan yang user-friendly
      return ChatMessage(
        id: _uuid.v4(),
        text: 'Terjadi kesalahan: ${e.toString()}',
        isUser: false,
        timestamp: DateTime.now(),
        type: MessageType.text,
      );
    }
  }

  /**
   * Memberikan panduan Islam untuk situasi kehidupan tertentu
   * 
   * Menyediakan solusi praktis berdasarkan ajaran Islam
   * dengan dalil dari Al-Quran atau Hadist yang relevan
   * 
   * @param situation - Deskripsi situasi yang dihadapi pengguna
   * @return ChatMessage dengan panduan Islam
   */
  Future<ChatMessage> getIslamicGuidance(String situation) async {
    try {
      // Prompt khusus untuk panduan Islam
      final prompt = '''
      Berdasarkan situasi: "$situation"
      
      Berikan panduan Islam yang sesuai dengan situasi tersebut.
      Sertakan dalil dari Al-Quran atau Hadist jika memungkinkan.
      Berikan jawaban yang praktis dan mudah dipahami dalam bahasa Indonesia.
      
      Format jawaban:
      
      **Panduan Islam:**
      [Penjelasan panduan]
      
      **Dalil:**
      [Dalil dari Al-Quran atau Hadist jika ada]
      
      **Aplikasi Praktis:**
      [Bagaimana menerapkan panduan tersebut dalam kehidupan sehari-hari]
      ''';

      // Kirim prompt ke AI
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      // Buat ChatMessage dengan tipe islamicQuestion
      return ChatMessage(
        id: _uuid.v4(),
        text: response.text ?? 'Maaf, tidak dapat memberikan panduan saat ini.',
        isUser: false,
        timestamp: DateTime.now(),
        type: MessageType.islamicQuestion,
      );
    } catch (e) {
      // Handle error dengan pesan yang user-friendly
      return ChatMessage(
        id: _uuid.v4(),
        text: 'Terjadi kesalahan: ${e.toString()}',
        isUser: false,
        timestamp: DateTime.now(),
        type: MessageType.text,
      );
    }
  }

  /**
   * Mengkategorikan pesan pengguna untuk menentukan jenis respons
   * 
   * Menganalisis kata kunci dalam pesan untuk menentukan
   * fungsi AI mana yang harus dipanggil
   * 
   * @param message - Pesan dari pengguna
   * @return String kategori ('quran_recommendation', 'hadith_recommendation', 'islamic_guidance', 'islamic_question')
   */
  String categorizeMessage(String message) {
    // Konversi ke lowercase untuk analisis yang lebih akurat
    final lowerMessage = message.toLowerCase();
    
    // Deteksi kata kunci yang berkaitan dengan emosi/perasaan
    if (lowerMessage.contains('sedih') || 
        lowerMessage.contains('senang') || 
        lowerMessage.contains('marah') || 
        lowerMessage.contains('takut') || 
        lowerMessage.contains('cemas') || 
        lowerMessage.contains('stress') || 
        lowerMessage.contains('bahagia') || 
        lowerMessage.contains('mood') || 
        lowerMessage.contains('perasaan')) {
      return 'quran_recommendation';
    } 
    // Deteksi kata kunci yang berkaitan dengan hadist
    else if (lowerMessage.contains('hadist') || 
               lowerMessage.contains('hadits') || 
               lowerMessage.contains('sunnah') || 
               lowerMessage.contains('riwayat')) {
      return 'hadith_recommendation';
    } 
    // Deteksi kata kunci yang berkaitan dengan panduan/solusi
    else if (lowerMessage.contains('panduan') || 
               lowerMessage.contains('bagaimana') || 
               lowerMessage.contains('cara') || 
               lowerMessage.contains('solusi')) {
      return 'islamic_guidance';
    } 
    // Default: pertanyaan umum tentang Islam
    else {
      return 'islamic_question';
    }
  }
}
