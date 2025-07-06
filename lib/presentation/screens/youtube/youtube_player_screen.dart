import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerScreen extends StatefulWidget {
  final String videoId;
  final String title;

  const YouTubePlayerScreen({
    Key? key,
    required this.videoId,
    required this.title,
  }) : super(key: key);

  @override
  State<YouTubePlayerScreen> createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen>
    with AutomaticKeepAliveClientMixin {
  late YoutubePlayerController _controller;
  late bool _isPlayerReady;
  bool _controllerInitialized = false;

  @override
  void initState() {
    super.initState();
    _isPlayerReady = false;
    // Delayed initialization to prevent too many WebGL contexts
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        _controller = YoutubePlayerController(
          initialVideoId: widget.videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            enableCaption: true,
            forceHD:
                false, // Prevent forcing HD which creates more WebGL contexts
            disableDragSeek: false, // Allow seeking
          ),
        )..addListener(_listener);

        if (mounted) {
          setState(() {
            _controllerInitialized = true;
          });
        }
      }
    });
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      // Limit setState calls to prevent excessive rendering
      // Only update on important changes
      if (_controller.value.isPlaying ||
          _controller.value.playerState == PlayerState.ended ||
          _controller.value.playerState == PlayerState.paused) {
        setState(() {});
      }
    }
  }

  // Keep player alive when navigating away temporarily
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: const Color(0xFF219EBC),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: const Color(0xFF219EBC),
            progressColors: const ProgressBarColors(
              playedColor: Color(0xFF219EBC),
              handleColor: Color(0xFF219EBC),
            ),
            onReady: () {
              _isPlayerReady = true;
            },
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
