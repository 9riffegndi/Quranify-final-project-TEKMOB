/// Model class for Hijaiyah letters
class HijaiyahLetter {
  final String arabic;
  final String latin;
  final String audio;
  final String? fallbackAudio; // Fallback audio jika file utama tidak tersedia

  HijaiyahLetter({
    required this.arabic,
    required this.latin,
    required this.audio,
    this.fallbackAudio,
  });

  // Add methods for serialization/deserialization
  Map<String, dynamic> toJson() => {
    'arabic': arabic,
    'latin': latin,
    'audio': audio,
    'fallbackAudio': fallbackAudio,
  };

  factory HijaiyahLetter.fromJson(Map<String, dynamic> json) => HijaiyahLetter(
    arabic: json['arabic'] as String,
    latin: json['latin'] as String,
    audio: json['audio'] as String,
    fallbackAudio: json['fallbackAudio'] as String?,
  );

  // Create a copy of the letter
  HijaiyahLetter copyWith({
    String? arabic,
    String? latin,
    String? audio,
    String? fallbackAudio,
  }) {
    return HijaiyahLetter(
      arabic: arabic ?? this.arabic,
      latin: latin ?? this.latin,
      audio: audio ?? this.audio,
      fallbackAudio: fallbackAudio ?? this.fallbackAudio,
    );
  }
}
