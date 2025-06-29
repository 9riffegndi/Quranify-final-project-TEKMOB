import 'dart:convert';
import 'package:http/http.dart' as http;
import 'juz_model.dart';

class JuzService {
  static Future<List<Juz>> fetchJuzList() async {
    final url = Uri.parse('https://equran.id/api/v2/juz');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List data = jsonData['data'];

      return data.map((e) => Juz.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data Juz');
    }
  }
}
