/// Model class for advanced Hijaiyah letters with additional properties for general game mode
class AdvancedHijaiyahLetter {
  final String arabic;
  final String latin;
  final String audio;
  final List<String> forms; // Initial, middle, final, isolated forms
  final String pronounciation; // Description of how to pronounce
  final List<String> examples; // Example words using this letter
  final String makhraj; // Place of articulation
  final String sifat; // Characteristics of the letter

  AdvancedHijaiyahLetter({
    required this.arabic,
    required this.latin,
    required this.audio,
    required this.forms,
    required this.pronounciation,
    required this.examples,
    required this.makhraj,
    required this.sifat,
  });

  // Add methods for serialization/deserialization
  Map<String, dynamic> toJson() => {
    'arabic': arabic,
    'latin': latin,
    'audio': audio,
    'forms': forms,
    'pronounciation': pronounciation,
    'examples': examples,
    'makhraj': makhraj,
    'sifat': sifat,
  };

  factory AdvancedHijaiyahLetter.fromJson(Map<String, dynamic> json) =>
      AdvancedHijaiyahLetter(
        arabic: json['arabic'] as String,
        latin: json['latin'] as String,
        audio: json['audio'] as String,
        forms: List<String>.from(json['forms'] as List),
        pronounciation: json['pronounciation'] as String,
        examples: List<String>.from(json['examples'] as List),
        makhraj: json['makhraj'] as String,
        sifat: json['sifat'] as String,
      );

  // Create a copy of the letter
  AdvancedHijaiyahLetter copyWith({
    String? arabic,
    String? latin,
    String? audio,
    List<String>? forms,
    String? pronounciation,
    List<String>? examples,
    String? makhraj,
    String? sifat,
  }) {
    return AdvancedHijaiyahLetter(
      arabic: arabic ?? this.arabic,
      latin: latin ?? this.latin,
      audio: audio ?? this.audio,
      forms: forms ?? this.forms,
      pronounciation: pronounciation ?? this.pronounciation,
      examples: examples ?? this.examples,
      makhraj: makhraj ?? this.makhraj,
      sifat: sifat ?? this.sifat,
    );
  }
}
