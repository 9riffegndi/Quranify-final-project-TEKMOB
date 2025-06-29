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
    return Juz(
      juzNumber: json['juz'],
      startSurah: json['start']['surah'],
      startAyah: json['start']['ayah'],
      endSurah: json['end']['surah'],
      endAyah: json['end']['ayah'],
    );
  }
}
