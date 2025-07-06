import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/hadith/hadith_book_model.dart';
import '../../models/hadith/hadith_model.dart';

class HadithService {
  static const String _baseUrl = 'https://api.hadith.gading.dev';

  // Get list of hadith books
  Future<HadithBookListResponse> getHadithBooks() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/books'));

      if (response.statusCode == 200) {
        return HadithBookListResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load hadith books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load hadith books: $e');
    }
  }

  // Get hadith by range
  Future<HadithResponse> getHadithByRange(
    String bookId,
    int start,
    int end,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/books/$bookId?range=$start-$end'),
      );

      if (response.statusCode == 200) {
        return HadithResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load hadiths: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load hadiths: $e');
    }
  }

  // Get specific hadith
  Future<HadithResponse> getSpecificHadith(String bookId, int number) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/books/$bookId/$number'),
      );

      if (response.statusCode == 200) {
        return HadithResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load hadith: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load hadith: $e');
    }
  }
}
