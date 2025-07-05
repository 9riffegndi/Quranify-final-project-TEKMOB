import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../config/youtube_config.dart';

/// Service untuk mengakses YouTube Data API v3
/// Menyediakan fungsi untuk mencari video dan mendapatkan data video
class YouTubeService {
  
  /// Mencari video berdasarkan keyword
  /// [query] - kata kunci pencarian
  /// [maxResults] - maksimal hasil pencarian (default: 10)
  /// [order] - urutan hasil (relevance, date, rating, viewCount)
  static Future<List<Map<String, dynamic>>> searchVideos(
    String query, {
    int maxResults = 10,
    String order = 'relevance',
  }) async {
    try {
      // Encode query untuk URL
      final encodedQuery = Uri.encodeComponent(query);
      
      // Buat URL untuk API request
      final url = Uri.parse(
        '${YouTubeConfig.baseUrl}/search?'
        'part=snippet&'
        'type=video&'
        'q=$encodedQuery&'
        'maxResults=$maxResults&'
        'order=$order&'
        'key=${YouTubeConfig.apiKey}'
      );
      
      debugPrint('YouTube API Request: $url');
      
      // Kirim HTTP GET request
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Cek jika ada error dari API
        if (data['error'] != null) {
          throw Exception('YouTube API Error: ${data['error']['message']}');
        }
        
        final List<dynamic> items = data['items'] ?? [];
        
        // Convert data ke format yang mudah digunakan
        return items.map((item) {
          final snippet = item['snippet'] ?? {};
          final thumbnails = snippet['thumbnails'] ?? {};
          final medium = thumbnails['medium'] ?? thumbnails['default'] ?? {};
          
          return {
            'videoId': item['id']['videoId'] ?? '',
            'title': snippet['title'] ?? 'No Title',
            'description': snippet['description'] ?? 'No Description',
            'thumbnail': medium['url'] ?? '',
            'channelTitle': snippet['channelTitle'] ?? '',
            'publishedAt': snippet['publishedAt'] ?? '',
            'videoUrl': 'https://www.youtube.com/watch?v=${item['id']['videoId']}',
          };
        }).toList();
      } else {
        throw Exception('HTTP Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error searching videos: $e');
      return []; // Return empty list jika error
    }
  }

  /// Mendapatkan video dari channel tertentu
  /// [channelId] - ID channel YouTube
  /// [maxResults] - maksimal hasil (default: 10)
  static Future<List<Map<String, dynamic>>> getChannelVideos(
    String channelId, {
    int maxResults = 10,
  }) async {
    try {
      final url = Uri.parse(
        '${YouTubeConfig.baseUrl}/search?'
        'part=snippet&'
        'channelId=$channelId&'
        'type=video&'
        'maxResults=$maxResults&'
        'order=date&'
        'key=${YouTubeConfig.apiKey}'
      );
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];
        
        return items.map((item) {
          final snippet = item['snippet'] ?? {};
          final thumbnails = snippet['thumbnails'] ?? {};
          final medium = thumbnails['medium'] ?? thumbnails['default'] ?? {};
          
          return {
            'videoId': item['id']['videoId'] ?? '',
            'title': snippet['title'] ?? 'No Title',
            'description': snippet['description'] ?? 'No Description',
            'thumbnail': medium['url'] ?? '',
            'channelTitle': snippet['channelTitle'] ?? '',
            'publishedAt': snippet['publishedAt'] ?? '',
            'videoUrl': 'https://www.youtube.com/watch?v=${item['id']['videoId']}',
          };
        }).toList();
      } else {
        throw Exception('Failed to load channel videos');
      }
    } catch (e) {
      debugPrint('Error getting channel videos: $e');
      return [];
    }
  }

  /// Mendapatkan video dengan konten Islami secara random
  /// Menggunakan keyword yang sudah ditentukan di config
  /// [maxResults] - maksimal hasil (default: 10)
  static Future<List<Map<String, dynamic>>> getIslamicVideos({
    int maxResults = 10,
  }) async {
    try {
      // Pilih keyword secara random untuk variasi konten
      final random = DateTime.now().millisecondsSinceEpoch % YouTubeConfig.islamicKeywords.length;
      final selectedKeyword = YouTubeConfig.islamicKeywords[random];
      
      debugPrint('Searching for: $selectedKeyword');
      
      // Cari video dengan keyword yang dipilih
      return await searchVideos(selectedKeyword, maxResults: maxResults, order: 'relevance');
    } catch (e) {
      debugPrint('Error getting Islamic videos: $e');
      return [];
    }
  }

  /// Mendapatkan video terbaru dari channel Islami
  /// [maxResults] - maksimal hasil per channel (default: 3)
  static Future<List<Map<String, dynamic>>> getLatestIslamicChannelVideos({
    int maxResults = 3,
  }) async {
    try {
      List<Map<String, dynamic>> allVideos = [];
      
      // Ambil video dari setiap channel Islami
      for (String channelId in YouTubeConfig.islamicChannels.values) {
        final videos = await getChannelVideos(channelId, maxResults: maxResults);
        allVideos.addAll(videos);
      }
      
      // Acak urutan video untuk variasi
      allVideos.shuffle();
      
      return allVideos.take(maxResults * 2).toList(); // Ambil maksimal hasil yang diinginkan
    } catch (e) {
      debugPrint('Error getting latest Islamic videos: $e');
      return [];
    }
  }
}
