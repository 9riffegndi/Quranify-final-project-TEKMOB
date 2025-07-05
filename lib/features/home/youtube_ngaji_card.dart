import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Widget untuk menampilkan video YouTube dalam bentuk card
/// Mendukung web (iframe) dan mobile (external app)
class YoutubeNgajiCard extends StatefulWidget {
  final String videoUrl;    // URL video YouTube
  final String title;       // Judul video
  final String description; // Deskripsi video
  
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
  YoutubePlayerController? _controller; // Controller untuk YouTube player (nullable)
  bool _isPlayerReady = false;          // Status apakah player sudah siap
  bool _hasError = false;               // Status jika ada error
  String? _videoId;                     // Video ID yang diextract dari URL

  @override
  void initState() {
    super.initState();
    _initializePlayer(); // Inisialisasi player saat widget dibuat
  }

  /// Inisialisasi YouTube player controller
  /// Untuk web, akan ada fallback ke browser eksternal jika error
  void _initializePlayer() {
    try {
      // Extract video ID dari URL YouTube
      _videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
      
      if (_videoId != null) {
        // Untuk web, gunakan approach yang lebih hati-hati
        if (kIsWeb) {
          _initializeWebPlayer();
        } else {
          _initializeMobilePlayer();
        }
      } else {
        // Jika video ID tidak valid
        setState(() {
          _hasError = true;
        });
      }
    } catch (e) {
      // Handle error saat inisialisasi
      setState(() {
        _hasError = true;
      });
      debugPrint('Error initializing YouTube player: $e');
    }
  }

  /// Inisialisasi player untuk web dengan error handling
  void _initializeWebPlayer() {
    try {
      // Setup controller dengan konfigurasi minimal untuk web
      _controller = YoutubePlayerController(
        initialVideoId: _videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: false, // Disable caption untuk web compatibility
          forceHD: false,
          hideControls: false,
          controlsVisibleAtStart: true,
          showLiveFullscreenButton: false,
          disableDragSeek: true, // Disable drag untuk web stability
        ),
      );
      
      // Listen untuk perubahan status dengan timeout
      _setupControllerListener();
      
      // Set timeout untuk web player
      Future.delayed(const Duration(seconds: 10), () {
        if (mounted && !_isPlayerReady && !_hasError) {
          setState(() {
            _hasError = true;
          });
          debugPrint('YouTube player timeout on web');
        }
      });
      
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      debugPrint('Error initializing web player: $e');
    }
  }

  /// Inisialisasi player untuk mobile
  void _initializeMobilePlayer() {
    try {
      // Setup controller dengan konfigurasi lengkap untuk mobile
      _controller = YoutubePlayerController(
        initialVideoId: _videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: true,
          captionLanguage: 'id',
          forceHD: false,
          hideControls: false,
          controlsVisibleAtStart: true,
          showLiveFullscreenButton: true,
        ),
      );
      
      _setupControllerListener();
      
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      debugPrint('Error initializing mobile player: $e');
    }
  }

  /// Setup listener untuk controller
  void _setupControllerListener() {
    _controller?.addListener(() {
      if (mounted) {
        // Update status ketika player ready
        if (_controller!.value.isReady && !_isPlayerReady) {
          setState(() {
            _isPlayerReady = true;
          });
        }
        // Update status jika ada error
        if (_controller!.value.hasError) {
          setState(() {
            _hasError = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    // Cleanup controller untuk mencegah memory leak
    try {
      _controller?.dispose();
    } catch (e) {
      debugPrint('Error disposing controller: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Player Section
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 16 / 9, // Ratio standar untuk video
              child: _hasError
                  ? _buildErrorWidget() // Tampilkan error jika ada masalah
                  : _buildVideoPlayer(), // Tampilkan video player
            ),
          ),
          
          // Video Information Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul Video
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF023047),
                  ),
                  maxLines: 2, // Batasi maksimal 2 baris
                  overflow: TextOverflow.ellipsis, // Tambahkan ... jika terlalu panjang
                ),
                const SizedBox(height: 8),
                
                // Deskripsi Video
                Text(
                  widget.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                  maxLines: 3, // Batasi maksimal 3 baris
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                
                // Status Player
                _buildPlayerStatus(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget untuk menampilkan pesan error
  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            const Text(
              'Video tidak dapat dimuat',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            // Tombol untuk membuka di browser sebagai fallback
            ElevatedButton.icon(
              onPressed: _launchYouTubeUrl,
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('Buka di YouTube'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF219EBC),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk YouTube Player
  Widget _buildVideoPlayer() {
    // Jika controller null, tampilkan loading
    if (_controller == null) {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Color(0xFF219EBC),
              ),
              SizedBox(height: 8),
              Text(
                'Memuat video...',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Untuk web, jika ada error dengan player, tampilkan tombol untuk buka di browser
    if (kIsWeb && _hasError) {
      return _buildWebFallback();
    }

    // Tampilkan YouTube player normal
    return YoutubePlayer(
      controller: _controller!,
      showVideoProgressIndicator: true,
      progressIndicatorColor: const Color(0xFF219EBC), // Warna progress bar
      progressColors: const ProgressBarColors(
        playedColor: Color(0xFF219EBC),     // Warna bagian yang sudah diputar
        handleColor: Color(0xFF219EBC),     // Warna handle slider
      ),
      onReady: () {
        // Callback ketika player siap
        if (mounted) {
          setState(() {
            _isPlayerReady = true;
          });
        }
      },
      onEnded: (data) {
        // Callback ketika video selesai
        // Reset ke awal untuk memungkinkan replay
        if (mounted && !_hasError && _controller != null) {
          _controller!.seekTo(Duration.zero);
        }
      },
    );
  }

  /// Widget fallback untuk web ketika player gagal
  Widget _buildWebFallback() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.play_circle_outline,
              size: 48,
              color: Color(0xFF219EBC),
            ),
            const SizedBox(height: 8),
            const Text(
              'Klik untuk menonton di YouTube',
              style: TextStyle(
                color: Color(0xFF023047),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _launchYouTubeUrl,
              icon: const Icon(Icons.open_in_new),
              label: const Text('Buka di YouTube'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF219EBC),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Membuka URL YouTube di browser eksternal
  Future<void> _launchYouTubeUrl() async {
    try {
      final Uri url = Uri.parse(widget.videoUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Error launching YouTube URL: $e');
      // Tampilkan snackbar error jika gagal membuka URL
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka video YouTube'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Widget untuk menampilkan status player
  Widget _buildPlayerStatus() {
    return Row(
      children: [
        Icon(
          _hasError
              ? Icons.error_outline
              : _isPlayerReady
                  ? Icons.play_circle_fill
                  : Icons.play_circle_outline,
          color: _hasError ? Colors.red : const Color(0xFF219EBC),
          size: 16,
        ),
        const SizedBox(width: 6),
        Text(
          _hasError
              ? 'Error memuat video'
              : _isPlayerReady
                  ? 'Siap diputar'
                  : 'Memuat...',
          style: TextStyle(
            color: _hasError ? Colors.red : const Color(0xFF219EBC),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

