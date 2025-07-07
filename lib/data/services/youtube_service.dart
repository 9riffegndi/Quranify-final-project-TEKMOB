import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/youtube_config.dart';

class YouTubeService {
  // Cache keys and expiration time
  static const String _kIslamicVideosCache = 'islamic_videos_cache';
  static const String _kChannelVideosCache = 'channel_videos_cache_';
  static const String _kCacheTimestampKey = 'cache_timestamp_';
  static const int _cacheDurationHours = 12; // Cache expires after 12 hours
  // Using API key and base URL from config
  final String _apiKey = YouTubeConfig.apiKey;
  final String _baseUrl = YouTubeConfig.baseUrl;

  // Fetch Islamic study videos with caching
  Future<List<Map<String, dynamic>>> getIslamicStudyVideos() async {
    try {
      // Check if we have valid cached data
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_kIslamicVideosCache);
      final cachedTimestamp = prefs.getInt(
        '${_kCacheTimestampKey}$_kIslamicVideosCache',
      );

      // If we have cached data and it's not expired, use it
      if (cachedData != null && cachedTimestamp != null) {
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        final cacheAge = currentTime - cachedTimestamp;
        final cacheExpiration =
            _cacheDurationHours * 60 * 60 * 1000; // hours to milliseconds

        if (cacheAge < cacheExpiration) {
          print('Using cached Islamic study videos data');
          return List<Map<String, dynamic>>.from(
            jsonDecode(
              cachedData,
            ).map((item) => Map<String, dynamic>.from(item)),
          );
        }
      }

      // Cache expired or doesn't exist, fetch new data
      // Select a random keyword from the Islamic keywords list
      final keyword =
          YouTubeConfig.islamicKeywords[DateTime.now().microsecond %
              YouTubeConfig.islamicKeywords.length];

      // Set up search parameters for Islamic study content in Indonesian
      final url = Uri.parse(
        '$_baseUrl/search?part=snippet&maxResults=10&q=$keyword&type=video&relevanceLanguage=id&key=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List;

        // Get the video IDs to fetch duration info
        final videoIds = items
            .map((item) => item['id']['videoId'] as String)
            .join(',');

        // Get video details for duration
        final videoDetailsUrl = Uri.parse(
          '$_baseUrl/videos?part=contentDetails,statistics&id=$videoIds&key=$_apiKey',
        );

        final detailsResponse = await http.get(videoDetailsUrl);

        if (detailsResponse.statusCode == 200) {
          final detailsData = json.decode(detailsResponse.body);
          final detailsItems = detailsData['items'] as List;

          // Map details to the search results
          final videos = <Map<String, dynamic>>[];

          for (var i = 0; i < items.length; i++) {
            final searchItem = items[i];
            final videoId = searchItem['id']['videoId'];

            // Find matching detail item
            final detailItem = detailsItems.firstWhere(
              (element) => element['id'] == videoId,
              orElse: () => null,
            );

            if (detailItem != null) {
              final snippet = searchItem['snippet'];
              final details = detailItem['contentDetails'];
              final statistics = detailItem['statistics'];

              videos.add({
                'id': videoId,
                'title': snippet['title'],
                'channelName': snippet['channelTitle'],
                'thumbnailUrl': snippet['thumbnails']['high']['url'],
                'duration': _formatDuration(details['duration']),
                'views': _formatViews(statistics['viewCount'] ?? '0'),
                'uploadedAt': _formatUploadDate(snippet['publishedAt']),
              });
            }
          }

          // Save the result to cache
          if (videos.isNotEmpty) {
            await prefs.setString(_kIslamicVideosCache, jsonEncode(videos));
            await prefs.setInt(
              '${_kCacheTimestampKey}$_kIslamicVideosCache',
              DateTime.now().millisecondsSinceEpoch,
            );
            print('Saved Islamic study videos to cache');
          }

          return videos;
        }
      }

      // If API fails but we have outdated cache, still use it as fallback
      if (cachedData != null) {
        print('Using expired cached Islamic study videos as fallback');
        return List<Map<String, dynamic>>.from(
          jsonDecode(cachedData).map((item) => Map<String, dynamic>.from(item)),
        );
      }

      return _getDummyVideos(); // Return dummy data in case of error
    } catch (e) {
      print('YouTube API Error: $e');

      // Try to use expired cache as fallback in case of exception
      try {
        final prefs = await SharedPreferences.getInstance();
        final cachedData = prefs.getString(_kIslamicVideosCache);
        if (cachedData != null) {
          print(
            'Using expired cached Islamic study videos as fallback after error',
          );
          return List<Map<String, dynamic>>.from(
            jsonDecode(
              cachedData,
            ).map((item) => Map<String, dynamic>.from(item)),
          );
        }
      } catch (_) {
        // If error accessing cache, continue to dummy data
      }

      return _getDummyVideos(); // Return dummy data in case of error
    }
  }

  // Fetch videos from a specific Islamic channel with caching
  Future<List<Map<String, dynamic>>> getChannelVideos(String channelKey) async {
    try {
      // Get the channel ID from the config
      final channelId = YouTubeConfig.islamicChannels[channelKey];

      if (channelId == null) {
        print('Invalid channel key: $channelKey');
        return _getDummyVideos();
      }

      // Create a unique cache key for this channel
      final channelCacheKey = '${_kChannelVideosCache}$channelKey';

      // Check if we have valid cached data for this channel
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(channelCacheKey);
      final cachedTimestamp = prefs.getInt('${_kCacheTimestampKey}$channelKey');

      // If we have cached data and it's not expired, use it
      if (cachedData != null && cachedTimestamp != null) {
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        final cacheAge = currentTime - cachedTimestamp;
        final cacheExpiration =
            _cacheDurationHours * 60 * 60 * 1000; // hours to milliseconds

        if (cacheAge < cacheExpiration) {
          print('Using cached channel videos data for: $channelKey');
          return List<Map<String, dynamic>>.from(
            jsonDecode(
              cachedData,
            ).map((item) => Map<String, dynamic>.from(item)),
          );
        }
      }

      // Set up search parameters for videos from this channel
      final url = Uri.parse(
        '$_baseUrl/search?part=snippet&maxResults=10&channelId=$channelId&order=date&type=video&key=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List;

        // Process results similar to getIslamicStudyVideos
        // Get the video IDs to fetch duration info
        final videoIds = items
            .map((item) => item['id']['videoId'] as String)
            .join(',');

        // Get video details for duration
        final videoDetailsUrl = Uri.parse(
          '$_baseUrl/videos?part=contentDetails,statistics&id=$videoIds&key=$_apiKey',
        );

        final detailsResponse = await http.get(videoDetailsUrl);

        if (detailsResponse.statusCode == 200) {
          final detailsData = json.decode(detailsResponse.body);
          final detailsItems = detailsData['items'] as List;

          // Map details to the search results
          final videos = <Map<String, dynamic>>[];

          for (var i = 0; i < items.length; i++) {
            final searchItem = items[i];
            final videoId = searchItem['id']['videoId'];

            // Find matching detail item
            final detailItem = detailsItems.firstWhere(
              (element) => element['id'] == videoId,
              orElse: () => null,
            );

            if (detailItem != null) {
              final snippet = searchItem['snippet'];
              final details = detailItem['contentDetails'];
              final statistics = detailItem['statistics'];

              videos.add({
                'id': videoId,
                'title': snippet['title'],
                'channelName': snippet['channelTitle'],
                'thumbnailUrl': snippet['thumbnails']['high']['url'],
                'duration': _formatDuration(details['duration']),
                'views': _formatViews(statistics['viewCount'] ?? '0'),
                'uploadedAt': _formatUploadDate(snippet['publishedAt']),
              });
            }
          }

          // Save the result to cache
          if (videos.isNotEmpty) {
            await prefs.setString(channelCacheKey, jsonEncode(videos));
            await prefs.setInt(
              '${_kCacheTimestampKey}$channelKey',
              DateTime.now().millisecondsSinceEpoch,
            );
            print('Saved channel videos to cache for: $channelKey');
          }

          return videos;
        }
      }

      // If API fails but we have outdated cache, still use it as fallback
      if (cachedData != null) {
        print(
          'Using expired cached channel videos as fallback for: $channelKey',
        );
        return List<Map<String, dynamic>>.from(
          jsonDecode(cachedData).map((item) => Map<String, dynamic>.from(item)),
        );
      }

      return _getDummyVideos(); // Return dummy data in case of error
    } catch (e) {
      print('YouTube Channel API Error: $e');

      // Try to use expired cache as fallback in case of exception
      try {
        final channelCacheKey = '${_kChannelVideosCache}$channelKey';
        final prefs = await SharedPreferences.getInstance();
        final cachedData = prefs.getString(channelCacheKey);

        if (cachedData != null) {
          print(
            'Using expired cached channel videos as fallback after error for: $channelKey',
          );
          return List<Map<String, dynamic>>.from(
            jsonDecode(
              cachedData,
            ).map((item) => Map<String, dynamic>.from(item)),
          );
        }
      } catch (_) {
        // If error accessing cache, continue to dummy data
      }

      return _getDummyVideos();
    }
  }

  // Get list of available Islamic channels
  Map<String, String> getAvailableIslamicChannels() {
    return YouTubeConfig.islamicChannels;
  }

  // Get list of Islamic keywords
  List<String> getIslamicKeywords() {
    return YouTubeConfig.islamicKeywords;
  }

  // Clear all YouTube API caches
  Future<void> clearAllCaches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Get all keys that start with our cache prefixes
      final allKeys = prefs.getKeys();
      final cacheKeys = allKeys
          .where(
            (key) =>
                key == _kIslamicVideosCache ||
                key.startsWith(_kChannelVideosCache) ||
                key.startsWith(_kCacheTimestampKey),
          )
          .toList();

      // Remove all cache entries
      for (var key in cacheKeys) {
        await prefs.remove(key);
      }

      print('Cleared all YouTube API caches (${cacheKeys.length} entries)');
    } catch (e) {
      print('Error clearing YouTube API caches: $e');
    }
  }

  // Clear cache for a specific channel
  Future<void> clearChannelCache(String channelKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final channelCacheKey = '${_kChannelVideosCache}$channelKey';
      final timestampKey = '${_kCacheTimestampKey}$channelKey';

      await prefs.remove(channelCacheKey);
      await prefs.remove(timestampKey);

      print('Cleared cache for channel: $channelKey');
    } catch (e) {
      print('Error clearing channel cache: $e');
    }
  }

  // Clear Islamic videos cache
  Future<void> clearIslamicVideosCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kIslamicVideosCache);
      await prefs.remove('${_kCacheTimestampKey}$_kIslamicVideosCache');

      print('Cleared Islamic videos cache');
    } catch (e) {
      print('Error clearing Islamic videos cache: $e');
    }
  }

  // Format ISO 8601 duration to human-readable format
  String _formatDuration(String isoDuration) {
    // Simple implementation for common YouTube video durations
    // PT1H30M15S -> 1:30:15, PT5M30S -> 5:30
    isoDuration = isoDuration.replaceFirst('PT', '');

    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    if (isoDuration.contains('H')) {
      final parts = isoDuration.split('H');
      hours = int.parse(parts[0]);
      isoDuration = parts[1];
    }

    if (isoDuration.contains('M')) {
      final parts = isoDuration.split('M');
      minutes = int.parse(parts[0]);
      isoDuration = parts[1];
    }

    if (isoDuration.contains('S')) {
      final parts = isoDuration.split('S');
      seconds = int.parse(parts[0]);
    }

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
  }

  // Format view count to K/M format
  String _formatViews(String viewCount) {
    final count = int.parse(viewCount);

    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }

  // Format upload date to relative time
  String _formatUploadDate(String publishedAt) {
    final publishDate = DateTime.parse(publishedAt);
    final now = DateTime.now();
    final difference = now.difference(publishDate);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} tahun yang lalu';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} bulan yang lalu';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else {
      return '${difference.inMinutes} menit yang lalu';
    }
  }

  // Fallback method that returns dummy data when API fails
  List<Map<String, dynamic>> _getDummyVideos() {
    print('Menggunakan data dummy karena API tidak tersedia atau error');
    return [
      {
        'id': 'example1',
        'title': 'Kajian Tafsir Al-Quran Surat Al-Baqarah',
        'channelName': 'Ustadz Abdul Somad',
        'duration': '45:22',
        'thumbnailUrl':
            '../../../assets/images/thumbnail/ustadz 1.jpg', // Using app assets
        'views': '245K',
        'uploadedAt': '2 minggu yang lalu',
      },
      {
        'id': 'example2',
        'title': 'Memahami Hadist Shahih Bukhari',
        'channelName': 'Ustadz Adi Hidayat',
        'duration': '38:15',
        'thumbnailUrl':
            '../../../assets/images/thumbnail/ustadz 2.jpg', // Using app assets
        'views': '128K',
        'uploadedAt': '3 minggu yang lalu',
      },
      {
        'id': 'example3',
        'title': 'Tafsir Surah Yasin',
        'channelName': 'Ustadz Hanan Attaki',
        'duration': '52:10',
        'thumbnailUrl':
            '../../../assets/images/thumbnail/ustadz 3.jpg', // Using app assets
        'views': '320K',
        'uploadedAt': '1 bulan yang lalu',
      },
      {
        'id': 'example4',
        'title': 'Memahami Asmaul Husna',
        'channelName': 'Ustadz Felix Siauw',
        'duration': '41:25',
        'thumbnailUrl':
            '../../../assets/images/thumbnail/ustadz 4.jpg', // Using app assets
        'views': '180K',
        'uploadedAt': '3 minggu yang lalu',
      },
      {
        'id': 'example5',
        'title': 'Kisah Para Nabi dan Rasul',
        'channelName': 'Ustadz Khalid Basalamah',
        'duration': '58:30',
        'thumbnailUrl':
            '../../../assets/images/thumbnail/ustadz 5.jpg', // Using app assets
        'views': '275K',
        'uploadedAt': '1 bulan yang lalu',
      },
    ];
  }
}
