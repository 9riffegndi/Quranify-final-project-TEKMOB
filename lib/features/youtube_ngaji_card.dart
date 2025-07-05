import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeNgajiCard extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String description;
  
  const YoutubeNgajiCard({
    super.key,
    this.videoUrl = 'https://youtu.be/4rbO39alQRU?si=PZ4OEGwuqXI1B1kn',
    this.title = 'Ngaji Online',
    this.description = 'Kajian Islam Terbaru',
  });

  @override
  State<YoutubeNgajiCard> createState() => _YoutubeNgajiCardState();
}

class _YoutubeNgajiCardState extends State<YoutubeNgajiCard> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    
    // Extract video ID from URL
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: true,
          captionLanguage: 'id',
          forceHD: false,
        ),
      );
      
      _controller.addListener(() {
        if (_controller.value.isReady && !_isPlayerReady) {
          setState(() {
            _isPlayerReady = true;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Player
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: const Color(0xFF219EBC),
                progressColors: const ProgressBarColors(
                  playedColor: Color(0xFF219EBC),
                  handleColor: Color(0xFF219EBC),
                ),
                topActions: [
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
                onReady: () {
                  setState(() {
                    _isPlayerReady = true;
                  });
                },
                onEnded: (data) {
                  // Handle video ended
                  _controller.seekTo(Duration.zero);
                },
              ),
            ),
          ),
          // Video Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      _isPlayerReady ? Icons.play_circle_fill : Icons.play_circle_outline,
                      color: const Color(0xFF219EBC),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isPlayerReady ? 'Siap diputar' : 'Memuat...',
                      style: TextStyle(
                        color: const Color(0xFF219EBC),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
