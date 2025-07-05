class Juz {
  final int juzNumber;
  final String startSurah;
  final int startAyah;
  final String endSurah;
  final int endAyah;

  Juz({
    required this.juzNumber,
    required this.startSurah,
    required this.startAyah,
    required this.endSurah,
    required this.endAyah,
  });

  factory Juz.fromJson(Map<String, dynamic> json) {
    try {
      // Validasi dan extract data dengan safe parsing
      final juzNumber = json['juz'] as int? ?? 0;
      
      // Safe parsing untuk surahs
      final surahs = json['surahs'] as Map<String, dynamic>? ?? {};
      final startSurah = surahs['start'] as Map<String, dynamic>? ?? {};
      final endSurah = surahs['end'] as Map<String, dynamic>? ?? {};
      
      // Safe parsing untuk ayahs
      final ayahs = json['ayahs'] as Map<String, dynamic>? ?? {};
      
      return Juz(
        juzNumber: juzNumber,
        startSurah: startSurah['name']?.toString() ?? '',
        startAyah: _parseIntSafely(ayahs['start']),
        endSurah: endSurah['name']?.toString() ?? '',
        endAyah: _parseIntSafely(ayahs['end']),
      );
    } catch (e) {
      // Return default values if parsing fails
      return Juz(
        juzNumber: json['juz'] as int? ?? 0,
        startSurah: '',
        startAyah: 0,
        endSurah: '',
        endAyah: 0,
      );
    }
  }
  
  static int _parseIntSafely(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
