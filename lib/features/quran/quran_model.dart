class JuzModel {
  final int juz;
  final String nama;
  final int awalSurah;
  final int awalAyat;
  final int akhirSurah;
  final int akhirAyat;

  JuzModel({
    required this.juz,
    required this.nama,
    required this.awalSurah,
    required this.awalAyat,
    required this.akhirSurah,
    required this.akhirAyat,
  });

  factory JuzModel.fromJson(Map<String, dynamic> json) {
    return JuzModel(
      juz: json['juz'],
      nama: json['nama'],
      awalSurah: json['awal']['surat']['nomor'],
      awalAyat: json['awal']['ayat'],
      akhirSurah: json['akhir']['surat']['nomor'],
      akhirAyat: json['akhir']['ayat'],
    );
  }
}
