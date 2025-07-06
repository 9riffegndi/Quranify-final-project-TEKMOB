import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../data/models/quran/surah_model.dart';

class QuranRepository {
  final String baseUrl = 'https://equran.id/api/v2';

  // Fetch all surahs
  Future<List<Surah>> getAllSurahs() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/surat'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['code'] == 200) {
          final List<dynamic> surahsData = responseData['data'];
          return surahsData
              .map((surahData) => Surah.fromJson(surahData))
              .toList();
        } else {
          throw Exception('Failed to load surahs: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to load surahs: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load surahs: $e');
    }
  }

  // Fetch specific surah by number
  Future<SurahDetail> getSurahDetail(int surahNumber) async {
    try {
      print('Fetching surah detail for surah number: $surahNumber');
      final response = await http.get(Uri.parse('$baseUrl/surat/$surahNumber'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('API Response received. Code: ${responseData['code']}');
        
        if (responseData['code'] == 200) {
          final Map<String, dynamic> surahData = responseData['data'];
          try {
            final result = SurahDetail.fromJson(surahData);
            print('Successfully parsed surah detail: ${result.namaLatin}');
            return result;
          } catch (parseError) {
            print('Error parsing surah detail: $parseError');
            throw Exception('Failed to parse surah detail: $parseError');
          }
        } else {
          throw Exception(
            'Failed to load surah detail: ${responseData['message']}',
          );
        }
      } else {
        throw Exception(
          'Failed to load surah detail: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Exception in getSurahDetail: $e');
      throw Exception('Failed to load surah detail: $e');
    }
  }
}
