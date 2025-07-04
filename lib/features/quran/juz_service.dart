import 'dart:convert';
import 'package:http/http.dart' as http;
import 'juz_model.dart';

class JuzService {
  static Future<List<Juz>> fetchJuzList() async {
    final resp = await http.get(Uri.parse('https://api.alquran.cloud/v1/meta'));
    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body);
      final juzMap = jsonData['data']['juzs'] as Map<String, dynamic>;
      
      final List<Juz> juzList = [];
      juzMap.forEach((key, value) {
        juzList.add(Juz.fromJson(value..['juz'] = int.parse(key)));
      });

      return juzList;
    } else {
      throw Exception('Gagal memuat data Juz');
    }
  }
}
