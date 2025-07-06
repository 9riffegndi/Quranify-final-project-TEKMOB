import 'package:flutter/material.dart';
import '../../data/services/youtube_service.dart';
import '../../routes/routes.dart';

class YouTubeVideosScreen extends StatefulWidget {
  const YouTubeVideosScreen({Key? key}) : super(key: key);

  @override
  State<YouTubeVideosScreen> createState() => _YouTubeVideosScreenState();
}

class _YouTubeVideosScreenState extends State<YouTubeVideosScreen> {
  final YouTubeService _youtubeService = YouTubeService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _videos = [];
  String? _errorMessage;

  Future<void> _loadVideos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final videos = await _youtubeService.getIslamicStudyVideos();
      setState(() {
        _videos = videos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat video: $e';
        _isLoading = false;
      });
    }
  }

  // Launch YouTube video either in app or browser
  Future<void> _playVideo(
    String videoId, {
    String title = 'Video Player',
  }) async {
    try {
      // Use the dedicated route for consistent navigation
      Navigator.of(context).pushNamed(
        AppRoutes.youtubePlayer,
        arguments: {'videoId': videoId, 'title': title},
      );
    } catch (e) {
      print('Navigation error: $e');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memulai video. Silakan coba lagi.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF219EBC),
        title: const Text(
          'Kajian Islam',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadVideos),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF219EBC)),
            )
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadVideos,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                final video = _videos[index];
                return YouTubeListItem(
                  videoId: video['id'],
                  title: video['title'],
                  channelName: video['channelName'],
                  thumbnailUrl: video['thumbnailUrl'],
                  duration: video['duration'],
                  views: video['views'],
                  uploadedAt: video['uploadedAt'],
                  onTap: () => _playVideo(video['id'], title: video['title']),
                );
              },
            ),
    );
  }
}

class YouTubeListItem extends StatelessWidget {
  final String videoId;
  final String title;
  final String channelName;
  final String thumbnailUrl;
  final String duration;
  final String views;
  final String uploadedAt;
  final Function() onTap;

  const YouTubeListItem({
    Key? key,
    required this.videoId,
    required this.title,
    required this.channelName,
    required this.thumbnailUrl,
    required this.duration,
    required this.views,
    required this.uploadedAt,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            // Thumbnail with duration
            Stack(
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    thumbnailUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    // Placeholder and error handling
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF219EBC),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Play button overlay
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),

                // Duration badge
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      duration,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Video info
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Channel icon
                  CircleAvatar(
                    backgroundColor: const Color(0xFF219EBC),
                    radius: 20,
                    child: Text(
                      channelName.substring(0, 1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Title, channel name, views and upload date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          channelName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$views ditonton • $uploadedAt',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
