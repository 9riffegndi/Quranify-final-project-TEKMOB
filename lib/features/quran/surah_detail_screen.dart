import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'ayah_model.dart';
import 'ayah_service.dart';

class SurahDetailScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;

  const SurahDetailScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
  });

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  List<Ayah> _ayahs = [];
  bool _loading = true;

  final AudioPlayer _player = AudioPlayer();
  final FlutterTts _tts = FlutterTts();

  int? _playingAyah;
  bool _isPlayingTTS = false;
  bool _isArabic = true;

  @override
  void initState() {
    super.initState();
    _loadAyahs();
  }

  Future<void> _loadAyahs() async {
    try {
      _ayahs = await AyahService.fetchAyahs(widget.surahNumber);
    } catch (e) {
      debugPrint('Error loading ayahs: $e');
    }
    setState(() => _loading = false);
  }

  Future<void> _play(int ayahNumber, String text, bool isArabic) async {
    setState(() {
      _playingAyah = ayahNumber;
      _isArabic = isArabic;
      _isPlayingTTS = kIsWeb;
    });

    if (kIsWeb) {
      await _tts.setLanguage(isArabic ? 'ar-SA' : 'id-ID');
      await _tts.setSpeechRate(0.5);
      await _tts.speak(text);
    } else {
      final url = 'https://verses.quran.com/Mishary_Rashid_Alafasy/${widget.surahNumber.toString().padLeft(3, '0')}${ayahNumber.toString().padLeft(3, '0')}.mp3';
      await _player.play(UrlSource(url));
    }
  }

  Future<void> _stop() async {
    if (kIsWeb) {
      await _tts.stop();
    } else {
      await _player.stop();
    }

    setState(() {
      _playingAyah = null;
      _isPlayingTTS = false;
    });
  }

  @override
  void dispose() {
    _player.dispose();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName),
        backgroundColor: const Color(0xFF219EBC),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _ayahs.length,
              itemBuilder: (context, index) {
                final ayah = _ayahs[index];
                final isPlaying = _playingAyah == ayah.number;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ayat Arab
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${ayah.number}. ',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                )),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  ayah.arab,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF023047),
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Latin
                        Text(
                          ayah.latin,
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF7B2CBF),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Terjemahan
                        Text(
                          ayah.translation,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF333333),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Tombol Audio
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Play Arab
                            ElevatedButton.icon(
                              onPressed: () => _play(ayah.number, ayah.arab, true),
                              icon: Icon(
                                Icons.volume_up,
                                color: isPlaying && _isArabic ? Colors.green : Colors.white,
                              ),
                              label: const Text("Arab"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF219EBC),
                              ),
                            ),

                            // Play Indo
                            ElevatedButton.icon(
                              onPressed: () => _play(ayah.number, ayah.translation, false),
                              icon: Icon(
                                Icons.volume_up,
                                color: isPlaying && !_isArabic ? Colors.green : Colors.white,
                              ),
                              label: const Text("Indo"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF219EBC),
                              ),
                            ),

                            // Stop
                            IconButton(
                              icon: const Icon(Icons.stop_circle, color: Colors.red),
                              onPressed: _stop,
                              tooltip: 'Hentikan suara',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
