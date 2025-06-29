import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadAyahs();
  }

  Future<void> _loadAyahs() async {
    try {
      _ayahs = await AyahService.fetchAyahs(widget.surahNumber);
    } catch (e) {
      debugPrint('Error: $e');
    }
    setState(() => _loading = false);
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
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nomor ayat dan arab
                        Row(
                          children: [
                            Text(
                              '${ayah.number}. ',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
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
                            color: Color(0xFF7B2CBF),
                            fontStyle: FontStyle.italic,
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
                          textAlign: TextAlign.left,
                        ),

                        const SizedBox(height: 8),

                        // Aksi (Bookmark / Salin)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Icon(Icons.bookmark_border, color: Colors.orange),
                            SizedBox(width: 12),
                            Icon(Icons.copy, color: Colors.blue),
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
