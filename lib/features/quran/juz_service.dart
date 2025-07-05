import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'juz_model.dart';

class JuzService {
  static Future<List<Juz>> fetchJuzList() async {
    try {
      final resp = await http.get(Uri.parse('https://api.alquran.cloud/v1/meta'));
      if (resp.statusCode == 200) {
        final jsonData = json.decode(resp.body);
        
        // Validasi struktur data
        if (jsonData['data'] == null || jsonData['data']['juzs'] == null) {
          throw Exception('Data structure invalid');
        }
        
        final juzMap = jsonData['data']['juzs'] as Map<String, dynamic>;
        
        final List<Juz> juzList = [];
        juzMap.forEach((key, value) {
          try {
            // Validasi key bisa diparse sebagai int
            final juzNumber = int.tryParse(key);
            if (juzNumber != null && value is Map<String, dynamic>) {
              // Buat copy dari value untuk menghindari modifikasi langsung
              final juzData = Map<String, dynamic>.from(value);
              juzData['juz'] = juzNumber;
              juzList.add(Juz.fromJson(juzData));
            }
          } catch (e) {
            // Skip juz yang tidak valid daripada crash
            debugPrint('Skipping invalid juz $key: $e');
          }
        });

        return juzList;
      } else {
        throw Exception('Gagal memuat data Juz');
      }
    } catch (e) {
      // Log error untuk debugging
      debugPrint('Error in fetchJuzList: $e');
      throw Exception('Gagal memuat data Juz');
    }
  }
}
