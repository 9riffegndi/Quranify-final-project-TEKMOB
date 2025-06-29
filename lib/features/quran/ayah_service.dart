import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ayah_model.dart';

class AyahService {
  static Future<List<Ayah>> fetchAyahs(int surahNumber) async {
    final url = Uri.parse('https://equran.id/api/surat/$surahNumber');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List ayahList = data['ayat'];
      return ayahList.map((json) => Ayah.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat ayat');
    }
  }
}
