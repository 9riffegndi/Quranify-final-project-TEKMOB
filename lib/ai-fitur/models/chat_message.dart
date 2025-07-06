/**
 * Model data untuk pesan dalam chat AI
 * 
 * Menyimpan informasi lengkap tentang setiap pesan yang dikirim
 * dan diterima dalam percakapan dengan AI assistant
 */
class ChatMessage {
  /// ID unik untuk setiap pesan (menggunakan UUID)
  final String id;
  
  /// Isi teks dari pesan
  final String text;
  
  /// Menentukan apakah pesan ini dari user (true) atau AI (false)
  final bool isUser;
  
  /// Waktu pesan dibuat
  final DateTime timestamp;
  
  /// Tipe pesan untuk menentukan format tampilan
  final MessageType type;

  /**
   * Constructor untuk membuat instance ChatMessage baru
   * 
   * @param id - ID unik pesan
   * @param text - Isi pesan
   * @param isUser - true jika dari user, false jika dari AI
   * @param timestamp - Waktu pesan dibuat
   * @param type - Tipe pesan (default: MessageType.text)
   */
  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.type = MessageType.text,
  });

  /**
   * Membuat salinan ChatMessage dengan beberapa field yang diubah
   * 
   * Berguna untuk mengupdate pesan tanpa membuat instance baru
   * Field yang tidak diisi akan menggunakan nilai dari instance saat ini
   * 
   * @return ChatMessage instance baru dengan nilai yang diperbarui
   */
  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    MessageType? type,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
    );
  }

  /**
   * Mengkonversi ChatMessage ke format JSON
   * 
   * Digunakan untuk menyimpan pesan ke local storage
   * timestamp dikonversi ke milliseconds untuk konsistensi
   * 
   * @return Map dengan format JSON
   */
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'type': type.index,
    };
  }

  /**
   * Membuat ChatMessage dari data JSON
   * 
   * Factory constructor untuk membaca data dari local storage
   * timestamp dikonversi kembali dari milliseconds ke DateTime
   * 
   * @param json - Data JSON yang berisi informasi pesan
   * @return ChatMessage instance baru
   */
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      text: json['text'],
      isUser: json['isUser'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      type: MessageType.values[json['type']],
    );
  }
}

/**
 * Enum untuk menentukan tipe pesan dalam chat
 * 
 * Setiap tipe memiliki format tampilan yang berbeda
 * untuk memberikan pengalaman user yang lebih baik
 */
enum MessageType {
  /// Pesan teks biasa
  text,
  
  /// Pesan yang berisi rekomendasi ayat Al-Quran
  quranRecommendation,
  
  /// Pesan yang berisi rekomendasi hadist
  hadithRecommendation,
  
  /// Pesan jawaban pertanyaan tentang Islam
  islamicQuestion,
  
  /// Pesan loading saat AI sedang memproses
  loading,
}
