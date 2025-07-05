import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeNgajiCard extends StatefulWidget {
  const YoutubeNgajiCard({super.key});

  @override
  State<YoutubeNgajiCard> createState() => _YoutubeNgajiCardState();
}

class _YoutubeNgajiCardState extends State<YoutubeNgajiCard> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId('https://youtu.be/4rbO39alQRU?si=PZ4OEGwuqXI1B1kn')!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 17,
      top: 644,
      child: SizedBox(
          width: MediaQuery.of(context).size.width,      // 100% lebar layar
    height: MediaQuery.of(context).size.height * 0.4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
          ),
        ),
      ),
    );
  }
}
