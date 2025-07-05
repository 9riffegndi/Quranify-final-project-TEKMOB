class Hadith {
  final String id;
  final String arab;
  final String indo;

  Hadith({required this.id, required this.arab, required this.indo});

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      id: json['number'].toString(),
      arab: json['arab'],
      indo: json['id'],
    );
  }
}
