// Simple test script to verify YouTube API integration
import 'dart:io';
import 'lib/services/youtube_service.dart';

void main() async {
  print('Testing YouTube API integration...');
  
  try {
    final youtubeService = YoutubeService();
    
    // Test fetching videos
    print('Fetching videos...');
    final videos = await youtubeService.fetchVideos();
    
    print('Success! Fetched ${videos.length} videos:');
    for (var video in videos) {
      print('- ${video.title}');
      print('  URL: ${video.url}');
      print('  Description: ${video.description}');
      print('');
    }
    
  } catch (e) {
    print('Error: $e');
    print('');
    print('Make sure you have:');
    print('1. Added your YouTube API key to lib/config/youtube_config.dart');
    print('2. Enabled YouTube Data API v3 in your Google Cloud Console');
    print('3. Added the API key to your project restrictions');
  }
}
