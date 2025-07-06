import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  // Using the provided API key
  static const String _apiKey = 'AIzaSyD1NQw6MHD9HAPIzYE52UN_VqmMpmzh62A';
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';

  // Fetch Islamic study videos
  Future<List<Map<String, dynamic>>> getIslamicStudyVideos() async {
    try {
      // Set up search parameters for Islamic study content in Indonesian
      final url = Uri.parse(
        '$_baseUrl/search?part=snippet&maxResults=10&q=kajian islam&type=video&relevanceLanguage=id&key=$_apiKey',
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

          return videos;
        }
      }

      return _getDummyVideos(); // Return dummy data in case of error
    } catch (e) {
      print('YouTube API Error: $e');
      return _getDummyVideos(); // Return dummy data in case of error
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
    return [
      {
        'id': 'example1',
        'title': 'Kajian Tafsir Al-Quran Surat Al-Baqarah',
        'channelName': 'Ustadz Abdul Somad',
        'duration': '45:22',
        'thumbnailUrl': 'https://i.ytimg.com/vi/example1/maxresdefault.jpg',
        'views': '245K',
        'uploadedAt': '2 minggu yang lalu',
      },
      {
        'id': 'example2',
        'title': 'Memahami Hadist Shahih Bukhari',
        'channelName': 'Ustadz Adi Hidayat',
        'duration': '38:15',
        'thumbnailUrl': 'https://i.ytimg.com/vi/example2/maxresdefault.jpg',
        'views': '128K',
        'uploadedAt': '3 minggu yang lalu',
      },
      // Add more dummy videos here
    ];
  }
}
