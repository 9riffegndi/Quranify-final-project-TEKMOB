import 'dart:convert';
import 'package:http/http.dart' as http;
import 'hadith_model.dart';

class HadithService {
  static Future<List<Hadith>> fetchHadiths({String kitab = 'bukhari', int from = 1, int to = 100}) async {
    final url = Uri.parse('https://api.hadith.gading.dev/books/$kitab?range=$from-$to');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data']['hadiths'];
      return data.map((json) => Hadith.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil hadist');
    }
  }
}
