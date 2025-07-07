import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/chat_message.dart';

/**
 * Service untuk mengelola penyimpanan dan pemuatan riwayat chat
 * 
 * Menggunakan SharedPreferences untuk menyimpan data chat secara lokal
 * sehingga riwayat percakapan tetap tersimpan meskipun aplikasi ditutup
 */
class ChatService {
  /// Key untuk menyimpan riwayat chat di SharedPreferences
  static const String _chatHistoryKey = 'ai_chat_history';
  
  /**
   * Menyimpan riwayat chat ke penyimpanan lokal
   * 
   * Mengkonversi list ChatMessage ke format JSON
   * dan menyimpannya menggunakan SharedPreferences
   * 
   * @param messages - List pesan chat yang akan disimpan
   */
  Future<void> saveChatHistory(List<ChatMessage> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Konversi setiap ChatMessage ke JSON
      final jsonList = messages.map((message) => message.toJson()).toList();
      // Simpan sebagai string JSON
      await prefs.setString(_chatHistoryKey, jsonEncode(jsonList));
    } catch (e) {
      print('Error saving chat history: $e');
    }
  }

  /**
   * Memuat riwayat chat dari penyimpanan lokal
   * 
   * Membaca data JSON dari SharedPreferences
   * dan mengkonversinya kembali ke list ChatMessage
   * 
   * @return List<ChatMessage> - Riwayat chat yang tersimpan
   */
  Future<List<ChatMessage>> loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_chatHistoryKey);
      
      // Jika ada data tersimpan
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        // Konversi setiap JSON kembali ke ChatMessage
        return jsonList.map((json) => ChatMessage.fromJson(json)).toList();
      }
      
      // Jika tidak ada data, return list kosong
      return [];
    } catch (e) {
      print('Error loading chat history: $e');
      return [];
    }
  }

  /**
   * Menghapus semua riwayat chat dari penyimpanan lokal
   * 
   * Berguna ketika user ingin memulai percakapan baru
   * atau ingin membersihkan riwayat chat
   */
  Future<void> clearChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Hapus data dengan key yang sesuai
      await prefs.remove(_chatHistoryKey);
    } catch (e) {
      print('Error clearing chat history: $e');
    }
  }

  /**
   * Menambahkan satu pesan baru ke riwayat chat
   * 
   * Memuat riwayat yang ada, menambahkan pesan baru,
   * kemudian menyimpan kembali ke penyimpanan lokal
   * 
   * @param message - Pesan baru yang akan ditambahkan
   */
  Future<void> addMessage(ChatMessage message) async {
    try {
      // Muat riwayat chat yang ada
      final messages = await loadChatHistory();
      // Tambahkan pesan baru
      messages.add(message);
      // Simpan kembali ke penyimpanan
      await saveChatHistory(messages);
    } catch (e) {
      print('Error adding message: $e');
    }
  }
}
