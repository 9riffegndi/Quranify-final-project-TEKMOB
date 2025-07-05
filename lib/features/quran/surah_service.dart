import 'dart:convert';
import 'package:http/http.dart' as http;
import 'surah_model.dart';

class SurahService {
  static Future<List<Surah>> fetchSurahList() async {
    final response = await http.get(Uri.parse('https://api.alquran.cloud/v1/surah'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((json) => Surah.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data surah');
    }
  }
}
