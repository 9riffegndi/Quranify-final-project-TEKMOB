class Surah {
  final int number;
  final String name;
  final int ayahCount;
  final String englishName;

  Surah({
    required this.number,
    required this.name,
    required this.ayahCount,
    required this.englishName,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'],
      name: json['name'],
      ayahCount: json['numberOfAyahs'],
      englishName: json['englishName'],
    );
  }
}
