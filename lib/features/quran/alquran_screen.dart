import 'package:flutter/material.dart';
import 'surah_model.dart';
import 'surah_service.dart';
import 'surah_detail_screen.dart';
import 'juz_model.dart';
import 'juz_service.dart';

class AlquranScreen extends StatefulWidget {
  const AlquranScreen({super.key});

  @override
  State<AlquranScreen> createState() => _AlquranScreenState();
}

class _AlquranScreenState extends State<AlquranScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Surah> _surahList = [];
  List<Juz> _juzList = [];
  bool _loading = true;
  bool _loadingJuz = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchSurah();
    _fetchJuz();
  }

  Future<void> _fetchSurah() async {
    try {
      _surahList = await SurahService.fetchSurahList();
    } catch (e) {
      debugPrint('Gagal memuat data Surah: $e');
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _fetchJuz() async {
    try {
      _juzList = await JuzService.fetchJuzList();
    } catch (e) {
      debugPrint('Gagal memuat data Juz: $e');
    }
    setState(() {
      _loadingJuz = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredSurah = _surahList.where((s) =>
        s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        s.englishName.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Al‑Qur\'an'),
        backgroundColor: const Color(0xFF219EBC),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Surat'),
            Tab(text: 'Juz'),
            Tab(text: 'Ditandai'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_tabController.index == 0)
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Cari Surat',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: filteredSurah.length,
                        itemBuilder: (context, index) {
                          final s = filteredSurah[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF8ECAE6),
                                child: Text('${s.number}', style: const TextStyle(color: Colors.white)),
                              ),
                              title: Text('${s.englishName} (${s.name})'),
                              subtitle: Text('Jumlah Ayat: ${s.ayahCount}'),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SurahDetailScreen(
                                      surahNumber: s.number,
                                      surahName: s.englishName,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),

                // Tab Juz
                _loadingJuz
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _juzList.length,
                        itemBuilder: (context, index) {
                          final juz = _juzList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                            color: const Color(0xFFDFF5F3),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF219EBC),
                                child: Text('${juz.juzNumber}', style: const TextStyle(color: Colors.white)),
                              ),
                              title: Text('Juz ${juz.juzNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                'Dari: ${juz.startSurah} ayat ${juz.startAyah} \n'
                                'Sampai: ${juz.endSurah} ayat ${juz.endAyah}',
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF219EBC), size: 18),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Kamu memilih Juz ${juz.juzNumber}')),
                                );
                              },
                            ),
                          );
                        },
                      ),

                // Tab Ditandai (masih kosong)
                const Center(child: Text('Tab Ditandai belum tersedia')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
