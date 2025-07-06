import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../data/models/quran/surah_model.dart';
import '../../../data/repositories/quran/quran_repository.dart';
import '../../../data/services/quran/audio_player_service.dart';
import '../../../data/services/quran/bookmark_service.dart';
import '../../../data/services/quran/juz_helper.dart';
import '../../../utils/arabic_numbers.dart';
import '../../../utils/tajwid_rules.dart';

class DetailSurahsScreen extends StatefulWidget {
  final int surahNumber;
  final int? initialAyatNumber;

  const DetailSurahsScreen({
    Key? key,
    required this.surahNumber,
    this.initialAyatNumber,
  }) : super(key: key);

  @override
  State<DetailSurahsScreen> createState() => _DetailSurahsScreenState();
}

class _DetailSurahsScreenState extends State<DetailSurahsScreen> {
  final QuranRepository _quranRepository = QuranRepository();
  final BookmarkService _bookmarkService = BookmarkService();
  final AudioPlayerService _audioPlayerService = AudioPlayerService();

  bool _isLoading = true;
  SurahDetail? _surahDetail;
  final Map<int, bool> _bookmarkedAyats = {};
  int? _playingAyatNumber;
  int? _loadingAyatNumber;

  @override
  void initState() {
    super.initState();
    _loadSurahDetail();
  }

  @override
  void dispose() {
    _audioPlayerService.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll controller for ayat list
  final ScrollController _scrollController = ScrollController();

  Future<void> _loadSurahDetail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('Loading surah detail for surah number: ${widget.surahNumber}');
      final surahDetail = await _quranRepository.getSurahDetail(
        widget.surahNumber,
      );

      print('Surah detail loaded: ${surahDetail.namaLatin}');
      setState(() {
        _surahDetail = surahDetail;
        _isLoading = false;
      });

      // Load bookmark status for all ayat
      await _loadBookmarkStatuses();

      // Scroll to the initial ayat if specified
      if (widget.initialAyatNumber != null && mounted) {
        // We use Future.delayed to make sure the ListView has been built
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;

          try {
            // Find the index of the initial ayat
            final ayatIndex =
                _surahDetail?.ayat.indexWhere(
                  (ayat) => ayat.nomorAyat == widget.initialAyatNumber,
                ) ??
                -1;

            if (ayatIndex >= 0) {
              _scrollController.animateTo(
                ayatIndex * 200.0, // Estimated height of each item
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          } catch (e) {
            print('Error scrolling to ayat: $e');
          }
        });
      }
    } catch (e) {
      print('Error loading surah detail: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load surah detail: ${e.toString()}'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _loadBookmarkStatuses() async {
    if (_surahDetail == null) return;

    for (final ayat in _surahDetail!.ayat) {
      final isBookmarked = await _bookmarkService.isBookmarked(
        surahNumber: widget.surahNumber,
        ayatNumber: ayat.nomorAyat,
      );

      setState(() {
        _bookmarkedAyats[ayat.nomorAyat] = isBookmarked;
      });
    }
  }

  Future<void> _toggleBookmark(Ayat ayat) async {
    final isCurrentlyBookmarked = _bookmarkedAyats[ayat.nomorAyat] ?? false;

    bool success;
    if (isCurrentlyBookmarked) {
      success = await _bookmarkService.removeBookmark(
        surahNumber: widget.surahNumber,
        ayatNumber: ayat.nomorAyat,
      );
    } else {
      success = await _bookmarkService.addBookmark(
        surahNumber: widget.surahNumber,
        surahName: _surahDetail!.namaLatin,
        ayatNumber: ayat.nomorAyat,
        ayatText: ayat.teksArab,
      );
    }

    if (success) {
      setState(() {
        _bookmarkedAyats[ayat.nomorAyat] = !isCurrentlyBookmarked;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isCurrentlyBookmarked ? 'Bookmark removed' : 'Bookmark added',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _playAudio(Ayat ayat) async {
    // Get audio URL based on platform
    Map<String, String> audioSources = ayat.audio;
    String audioUrl = '';

    // Try to use different audio sources if available
    if (kIsWeb) {
      // For web, try different sources in order of preference
      audioUrl =
          audioSources['05'] ?? // MP3 format - preferred for web
          audioSources['03'] ??
          '';
    } else {
      // For mobile
      audioUrl =
          audioSources['05'] ?? // MP3 format
          '';
    }

    if (audioUrl.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Audio tidak tersedia')));
      return;
    }

    try {
      // Toggle audio playback
      if (_playingAyatNumber == ayat.nomorAyat &&
          _audioPlayerService.isPlaying) {
        await _audioPlayerService.pause();
        setState(() {
          _playingAyatNumber = null;
        });
      } else {
        // Set loading state
        setState(() {
          _loadingAyatNumber = ayat.nomorAyat;
        });

        // Show loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Memuat audio...'),
            duration: Duration(seconds: 1),
          ),
        );

        if (kIsWeb) {
          // Special handling for web to avoid the JS error
          try {
            // First attempt with the normal play method
            await _audioPlayerService.play(audioUrl);
          } catch (webError) {
            print('Web audio error: $webError');

            // Try with a different approach
            try {
              // Try with a different URL format or source
              String alternateUrl = audioUrl;
              if (audioUrl.startsWith('https://')) {
                // Try with http instead of https
                alternateUrl = audioUrl.replaceFirst('https://', 'http://');
              }

              if (alternateUrl != audioUrl) {
                await _audioPlayerService.play(alternateUrl);
              } else {
                throw Exception('Tidak dapat memutar audio pada browser ini');
              }
            } catch (altError) {
              print('Alternative method error: $altError');
              throw Exception('Browser tidak mendukung pemutaran audio ini');
            }
          }
        } else {
          // Normal mobile playback
          await _audioPlayerService.play(audioUrl);
        }

        setState(() {
          _playingAyatNumber = ayat.nomorAyat;
          _loadingAyatNumber = null;
        });
      }
    } catch (e) {
      setState(() {
        _loadingAyatNumber = null;
      });

      // Check if we're on web and provide more helpful messaging
      if (kIsWeb) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Maaf, pemutaran audio tidak didukung di browser ini. Silakan gunakan aplikasi mobile untuk pengalaman terbaik.',
            ),
            duration: Duration(seconds: 5),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memutar audio: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }

      print('Error playing audio: $e');
    }
  }

  void _showTajwidLegend() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => TajwidRules.buildTajwidLegendModal(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF219EBC)),
              )
            : _surahDetail == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Failed to load surah',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF219EBC),
                      ),
                      onPressed: _loadSurahDetail,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  // Header with back button and surah name
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF219EBC),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            _surahDetail!.namaLatin,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF219EBC),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Surah info with blue background
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF219EBC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _surahDetail!.nama,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _surahDetail!.arti,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 1,
                          color: Colors.white.withOpacity(0.5),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _infoChip('${_surahDetail!.jumlahAyat} Ayat'),
                            _infoChip(_surahDetail!.tempatTurun),
                            _infoChip(
                              JuzHelper.getJuzDisplayText(widget.surahNumber),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tajwid info button
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () => _showTajwidLegend(),
                      icon: const Icon(Icons.info_outline, color: Colors.white),
                      label: const Text(
                        'Tajwid',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF219EBC,
                        ).withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Ayat list
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _surahDetail!.ayat.length,
                      itemBuilder: (context, index) {
                        final ayat = _surahDetail!.ayat[index];
                        final isBookmarked =
                            _bookmarkedAyats[ayat.nomorAyat] ?? false;
                        final isPlaying = _playingAyatNumber == ayat.nomorAyat;
                        final isLoading = _loadingAyatNumber == ayat.nomorAyat;

                        return AyatItem(
                          ayat: ayat,
                          isBookmarked: isBookmarked,
                          isPlaying: isPlaying,
                          isLoading: isLoading,
                          onToggleBookmark: () => _toggleBookmark(ayat),
                          onPlayAudio: () => _playAudio(ayat),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }
}

class AyatItem extends StatelessWidget {
  final Ayat ayat;
  final bool isBookmarked;
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onToggleBookmark;
  final VoidCallback onPlayAudio;

  const AyatItem({
    Key? key,
    required this.ayat,
    required this.isBookmarked,
    required this.isPlaying,
    this.isLoading = false,
    required this.onToggleBookmark,
    required this.onPlayAudio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ayat number and actions
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFF219EBC),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      ArabicNumbers.convertToArabic(ayat.nomorAyat),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Audio button
                isLoading
                    ? const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          color: Color(0xFF219EBC),
                          strokeWidth: 2.5,
                        ),
                      )
                    : IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: const Color(0xFF219EBC),
                          size: 28,
                        ),
                        onPressed: onPlayAudio,
                      ),
                // Bookmark button
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked
                        ? const Color(0xFF3699FF)
                        : Colors
                              .grey, // Updated bookmark color to match the border
                    size: 28,
                  ),
                  onPressed: onToggleBookmark,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Arabic text with tajwid highlighting
            Directionality(
              textDirection: TextDirection.rtl,
              child: RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  children: TajwidRules.highlightTajwid(ayat.teksArab),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Latin text
            Text(
              ayat.teksLatin,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            // Translation
            Text(
              ayat.teksIndonesia,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
