import 'package:flutter/material.dart';
import '../../../data/models/quran/surah_model.dart';
import '../../../data/repositories/quran/quran_repository.dart';
import '../../../data/services/quran/bookmark_service.dart';
import '../../../routes/routes.dart';
import 'detail_surahs.dart';

class SurahsScreen extends StatefulWidget {
  const SurahsScreen({Key? key}) : super(key: key);

  @override
  State<SurahsScreen> createState() => _SurahsScreenState();
}

class _SurahsScreenState extends State<SurahsScreen>
    with SingleTickerProviderStateMixin {
  final QuranRepository _quranRepository = QuranRepository();
  final BookmarkService _bookmarkService = BookmarkService();
  bool _isLoading = true;
  List<Surah> _allSurahs = [];
  List<Surah> _filteredSurahs = [];
  String _searchQuery = '';
  List<Map<String, dynamic>> _bookmarks = [];
  bool _loadingBookmarks = true;

  // Tab controller
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSurahs();
    _loadBookmarks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSurahs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final surahs = await _quranRepository.getAllSurahs();
      setState(() {
        _allSurahs = surahs;
        _filteredSurahs = surahs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load surahs: ${e.toString()}')),
      );
    }
  }

  Future<void> _loadBookmarks() async {
    setState(() {
      _loadingBookmarks = true;
    });
    try {
      final bookmarks = await _bookmarkService.getBookmarks();
      setState(() {
        _bookmarks = bookmarks;
        _loadingBookmarks = false;
      });
    } catch (e) {
      setState(() {
        _loadingBookmarks = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load bookmarks: ${e.toString()}')),
      );
    }
  }

  void _filterSurahs(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredSurahs = _allSurahs;
      } else {
        _filteredSurahs = _allSurahs
            .where(
              (surah) =>
                  surah.namaLatin.toLowerCase().contains(query.toLowerCase()) ||
                  surah.arti.toLowerCase().contains(query.toLowerCase()) ||
                  surah.nomor.toString().contains(query),
            )
            .toList();
      }
    });
  }

  // Widget for Juz view tab
  Widget _buildJuzView() {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(color: Color(0xFF219EBC)),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 30, // 30 juz in Quran
            itemBuilder: (context, index) {
              final juzNumber = index + 1;
              // Filter surahs that belong to this juz
              // This is a simplified approach; in a real app you'd have proper juz data
              final juzSurahs = _allSurahs.where((surah) {
                // Simple approach - every juz has approximately equal surah count
                final surahs_per_juz = (_allSurahs.length / 30).ceil();
                final start = index * surahs_per_juz;
                final end = start + surahs_per_juz;
                return surah.nomor > start && surah.nomor <= end;
              }).toList();

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF219EBC),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$juzNumber',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Juz $juzNumber',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      if (juzSurahs.isNotEmpty)
                        for (var surah in juzSurahs)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(surah.namaLatin),
                            subtitle: Text(
                              '${surah.tempatTurun} • ${surah.jumlahAyat} Ayat',
                            ),
                            trailing: Text(
                              surah.nama,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF219EBC),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailSurahsScreen(
                                    surahNumber: surah.nomor,
                                  ),
                                ),
                              );
                            },
                          ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  // Widget for vertical bookmarks view tab
  Widget _buildBookmarksVerticalView() {
    return _loadingBookmarks
        ? const Center(
            child: CircularProgressIndicator(color: Color(0xFF219EBC)),
          )
        : _bookmarks.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No bookmarks yet',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Add bookmarks by tapping the bookmark icon when viewing ayat',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = _bookmarks[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF219EBC),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${bookmark['surahNumber']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    bookmark['surahName'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Ayat ${bookmark['ayatNumber']}'),
                      const SizedBox(height: 8),
                      Text(
                        bookmark['ayatText'],
                        style: const TextStyle(fontSize: 18, height: 1.5),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailSurahsScreen(
                          surahNumber: bookmark['surahNumber'],
                          initialAyatNumber: bookmark['ayatNumber'],
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Hapus Bookmark'),
                          content: const Text(
                            'Apakah Anda yakin ingin menghapus bookmark ini?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await _bookmarkService.removeBookmark(
                          surahNumber: bookmark['surahNumber'],
                          ayatNumber: bookmark['ayatNumber'],
                        );
                        _loadBookmarks(); // Refresh bookmarks
                      }
                    },
                  ),
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and search
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF219EBC),
                    ),
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, AppRoutes.home),
                  ),
                  const SizedBox(width: 16),
                  // Search bar (Expanded to take available space)
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        onChanged: _filterSurahs,
                        decoration: const InputDecoration(
                          hintText: 'Cari Surat...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF219EBC),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bookmarks Horizontal List
            if (_bookmarks.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ditandai',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF219EBC),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 80,
                      child: _loadingBookmarks
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF219EBC),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _bookmarks.length,
                              itemBuilder: (context, index) {
                                final bookmark = _bookmarks[index];
                                return BookmarkItem(
                                  surahName: bookmark['surahName'],
                                  surahNumber: bookmark['surahNumber'],
                                  ayatNumber: bookmark['ayatNumber'],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailSurahsScreen(
                                              surahNumber:
                                                  bookmark['surahNumber'],
                                              // The ayat number to scroll to
                                              initialAyatNumber:
                                                  bookmark['ayatNumber'],
                                            ),
                                      ),
                                    );
                                  },
                                  onDelete: () async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Hapus Bookmark'),
                                        content: const Text(
                                          'Apakah Anda yakin ingin menghapus bookmark ini?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text('Hapus'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirmed == true) {
                                      await _bookmarkService.removeBookmark(
                                        surahNumber: bookmark['surahNumber'],
                                        ayatNumber: bookmark['ayatNumber'],
                                      );
                                      _loadBookmarks(); // Refresh bookmarks
                                    }
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),

            // Tab Bar
            TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF219EBC),
              labelColor: const Color(0xFF219EBC),
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Surat'),
                Tab(text: 'Juz'),
                Tab(text: 'Ditandai'),
              ],
            ),

            const SizedBox(height: 8),

            // Main content with TabBarView
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Surah List
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF219EBC),
                          ),
                        )
                      : _filteredSurahs.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tidak ada surah yang ditemukan untuk"$_searchQuery"',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF219EBC),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _searchQuery = '';
                                    _filteredSurahs = _allSurahs;
                                  });
                                },
                                child: const Text('Show All Surahs'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredSurahs.length,
                          itemBuilder: (context, index) {
                            final surah = _filteredSurahs[index];
                            return SurahListItem(
                              surah: surah,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailSurahsScreen(
                                      surahNumber: surah.nomor,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),

                  // Tab 2: Juz List
                  _buildJuzView(),

                  // Tab 3: Bookmarks List (Vertical)
                  _buildBookmarksVerticalView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SurahListItem extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;

  const SurahListItem({Key? key, required this.surah, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Surah Number in Circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF219EBC),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${surah.nomor}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Surah Details (Latin name and meaning)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.namaLatin,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${surah.tempatTurun} • ${surah.jumlahAyat} Ayat',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      surah.arti,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Arabic name (right-aligned)
              Text(
                surah.nama,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF219EBC),
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Horizontal bookmark item widget
class BookmarkItem extends StatelessWidget {
  final String surahName;
  final int surahNumber;
  final int ayatNumber;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const BookmarkItem({
    Key? key,
    required this.surahName,
    required this.surahNumber,
    required this.ayatNumber,
    required this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        // Color #E1F0FF with 60% opacity (99 in hex is approx 60%)
        color: const Color(0xFFE1F0FF).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(
            color: Color(0xFF3699FF),
            width: 4,
          ), // Border color #3699FF
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      surahName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF219EBC),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onDelete != null)
                    InkWell(
                      onTap: onDelete,
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Surah $surahNumber • Ayat $ayatNumber',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
