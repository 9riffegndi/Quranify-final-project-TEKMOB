class Surah {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final Map<String, String> audioFull;

  Surah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audioFull,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      nomor: json['nomor'] as int,
      nama: json['nama'] as String,
      namaLatin: json['namaLatin'] as String,
      jumlahAyat: json['jumlahAyat'] as int,
      tempatTurun: json['tempatTurun'] as String,
      arti: json['arti'] as String,
      deskripsi: json['deskripsi'] as String,
      audioFull: Map<String, String>.from(json['audioFull'] as Map),
    );
  }
}

class SurahDetail {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final Map<String, String> audioFull;
  final List<Ayat> ayat;
  final SurahSelanjutnya? surahSelanjutnya;
  final SurahSebelumnya? surahSebelumnya;

  SurahDetail({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audioFull,
    required this.ayat,
    this.surahSelanjutnya,
    this.surahSebelumnya,
  });

  factory SurahDetail.fromJson(Map<String, dynamic> json) {
    // Print for debugging
    print('Converting JSON to SurahDetail: ${json['namaLatin']}');

    try {
      return SurahDetail(
        nomor: json['nomor'] as int,
        nama: json['nama'] as String,
        namaLatin: json['namaLatin'] as String,
        jumlahAyat: json['jumlahAyat'] as int,
        tempatTurun: json['tempatTurun'] as String,
        arti: json['arti'] as String,
        deskripsi: json['deskripsi'] as String,
        audioFull: Map<String, String>.from(json['audioFull'] as Map),
        ayat: (json['ayat'] as List)
            .map((ayatJson) => Ayat.fromJson(ayatJson))
            .toList(),
        surahSelanjutnya:
            json['suratSelanjutnya'] != null &&
                json['suratSelanjutnya'] != false
            ? SurahSelanjutnya.fromJson(json['suratSelanjutnya'])
            : null,
        surahSebelumnya:
            json['suratSebelumnya'] != null && json['suratSebelumnya'] != false
            ? SurahSebelumnya.fromJson(json['suratSebelumnya'])
            : null,
      );
    } catch (e) {
      print('Error in SurahDetail.fromJson: $e');
      rethrow;
    }
  }
}

class Ayat {
  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;
  final Map<String, String> audio;

  Ayat({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
    required this.audio,
  });

  factory Ayat.fromJson(Map<String, dynamic> json) {
    return Ayat(
      nomorAyat: json['nomorAyat'] as int,
      teksArab: json['teksArab'] as String,
      teksLatin: json['teksLatin'] as String,
      teksIndonesia: json['teksIndonesia'] as String,
      audio: Map<String, String>.from(json['audio'] as Map),
    );
  }
}

class SurahSelanjutnya {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;

  SurahSelanjutnya({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
  });

  factory SurahSelanjutnya.fromJson(Map<String, dynamic> json) {
    return SurahSelanjutnya(
      nomor: json['nomor'] as int,
      nama: json['nama'] as String,
      namaLatin: json['namaLatin'] as String,
      jumlahAyat: json['jumlahAyat'] as int,
    );
  }
}

class SurahSebelumnya {
  final int? nomor;
  final String? nama;
  final String? namaLatin;
  final int? jumlahAyat;

  SurahSebelumnya({this.nomor, this.nama, this.namaLatin, this.jumlahAyat});

  factory SurahSebelumnya.fromJson(dynamic json) {
    if (json == false) {
      return SurahSebelumnya();
    }

    return SurahSebelumnya(
      nomor: json['nomor'] as int?,
      nama: json['nama'] as String?,
      namaLatin: json['namaLatin'] as String?,
      jumlahAyat: json['jumlahAyat'] as int?,
    );
  }
}
