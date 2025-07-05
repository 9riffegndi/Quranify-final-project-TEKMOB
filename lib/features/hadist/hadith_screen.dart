import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'hadith_model.dart';
import 'hadith_service.dart';

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> with SingleTickerProviderStateMixin {
  List<Hadith> allHadiths = [];
  List<Hadith> filteredHadiths = [];
  Set<String> favoriteIds = {};
  bool isLoading = true;
  String searchQuery = "";

  final FlutterTts flutterTts = FlutterTts();
  String currentlySpeakingId = "";

  @override
  void initState() {
    super.initState();
    loadHadiths();
    loadFavorites();

    flutterTts.setCompletionHandler(() {
      setState(() {
        currentlySpeakingId = "";
      });
    });
  }

  Future<void> loadHadiths() async {
    final data = await HadithService.fetchHadiths();
    setState(() {
      allHadiths = data;
      filteredHadiths = data;
      isLoading = false;
    });
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('favorite_ids') ?? [];
    setState(() {
      favoriteIds = saved.toSet();
    });
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorite_ids', favoriteIds.toList());
  }

  void toggleFavorite(String id) async {
    setState(() {
      if (favoriteIds.contains(id)) {
        favoriteIds.remove(id);
      } else {
        favoriteIds.add(id);
      }
    });
    await saveFavorites();
  }

  void search(String query) {
    setState(() {
      searchQuery = query;
      filteredHadiths = allHadiths.where((h) =>
          h.indo.toLowerCase().contains(query.toLowerCase()) ||
          h.arab.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  Future<void> speak(String text, String id) async {
    setState(() {
      currentlySpeakingId = id;
    });

    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
    await flutterTts.setLanguage(isArabic ? 'ar-SA' : 'id-ID');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.stop(); // hentikan jika sedang bicara
    await flutterTts.speak(text);
  }

  Future<void> stopSpeech() async {
    await flutterTts.stop();
    setState(() {
      currentlySpeakingId = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hadist'),
          backgroundColor: const Color(0xFF219EBC),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Semua'),
              Tab(text: 'Ditandai'),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      onChanged: search,
                      decoration: InputDecoration(
                        hintText: 'Cari Hadist (contoh: aqidah, ibadah)',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  if (currentlySpeakingId.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: ElevatedButton.icon(
                        onPressed: stopSpeech,
                        icon: const Icon(Icons.stop),
                        label: const Text('Hentikan Suara'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        buildHadithList(filteredHadiths),
                        buildHadithList(
                          allHadiths.where((h) => favoriteIds.contains(h.id)).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildHadithList(List<Hadith> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final hadith = list[index];
        final isFavorited = favoriteIds.contains(hadith.id);
        final isSpeaking = currentlySpeakingId == hadith.id;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hadith.arab,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF219EBC),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hadith.indo,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('HR Bukhari No. ${hadith.id}', style: const TextStyle(color: Colors.teal)),
                    Row(
                      children: [
                        IconButton(
                          tooltip: 'Bacakan Arab',
                          icon: Icon(
                            Icons.volume_up,
                            color: isSpeaking ? Colors.amber : Color(0xFF219EBC),
                          ),
                          onPressed: () => speak(hadith.arab, hadith.id),
                        ),
                        IconButton(
                          tooltip: 'Bacakan Indo',
                          icon: Icon(
                            Icons.volume_up_outlined,
                            color: isSpeaking ? Colors.amber : Color(0xFF8ECAE6),
                          ),
                          onPressed: () => speak(hadith.indo, hadith.id),
                        ),
                        IconButton(
                          tooltip: 'Favoritkan',
                          icon: Icon(
                            isFavorited ? Icons.favorite : Icons.favorite_border,
                            color: isFavorited ? Colors.red : Colors.grey,
                          ),
                          onPressed: () => toggleFavorite(hadith.id),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
