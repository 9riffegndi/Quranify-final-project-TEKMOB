/// Model class for Quran verse data used in the Sambung Ayat game
class AyatData {
  final String surah;
  final int surahNumber;
  final int verseNumber;
  final String arabicText;
  final String translation;
  final String continuation; // Next part of the verse for the game
  final List<String> options; // Options for multiple choice

  AyatData({
    required this.surah,
    required this.surahNumber,
    required this.verseNumber,
    required this.arabicText,
    required this.translation,
    required this.continuation,
    required this.options,
  });

  // Factory method to create from JSON data
  factory AyatData.fromJson(Map<String, dynamic> json) {
    return AyatData(
      surah: json['surah'] as String,
      surahNumber: json['surahNumber'] as int,
      verseNumber: json['verseNumber'] as int,
      arabicText: json['arabicText'] as String,
      translation: json['translation'] as String,
      continuation: json['continuation'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  // Convert object to JSON for storage
  Map<String, dynamic> toJson() => {
    'surah': surah,
    'surahNumber': surahNumber,
    'verseNumber': verseNumber,
    'arabicText': arabicText,
    'translation': translation,
    'continuation': continuation,
    'options': options,
  };
}
