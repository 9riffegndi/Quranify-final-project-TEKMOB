class Ayah {
  final int number;
  final String arab;
  final String latin;
  final String translation;

  Ayah({
    required this.number,
    required this.arab,
    required this.latin,
    required this.translation,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: json['nomor'] ?? 0,
      arab: json['ar'] ?? '',
      latin: json['tr'] ?? '',
      translation: json['idn'] ?? '',
    );
  }
}
