import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../data/models/hadith/hadith_book_model.dart';
import '../../../data/models/hadith/hadith_model.dart';
import '../../../data/services/hadith/hadith_service.dart';
import '../../../data/services/hadith/bookmark_service.dart';

class HadithDetailScreen extends StatefulWidget {
  final HadithBook book;
  final int? initialHadithNumber;

  const HadithDetailScreen({
    Key? key,
    required this.book,
    this.initialHadithNumber,
  }) : super(key: key);

  @override
  State<HadithDetailScreen> createState() => _HadithDetailScreenState();
}

class _HadithDetailScreenState extends State<HadithDetailScreen> {
  final HadithService _hadithService = HadithService();
  final HadithBookmarkService _bookmarkService = HadithBookmarkService();
  final FlutterTts _flutterTts = FlutterTts();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  bool _loadingMore = false;
  bool _hasMoreData = true;

  List<Hadith> _hadiths = [];
  List<Hadith> _filteredHadiths = [];
  Map<int, bool> _bookmarkedHadiths = {};

  int _currentPage = 1;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadHadiths();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage('id-ID');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _loadHadiths() async {
    if (!_hasMoreData || _loadingMore) return;

    setState(() {
      if (_currentPage == 1) {
        _isLoading = true;
      } else {
        _loadingMore = true;
      }
    });

    try {
      // Calculate range based on pagination
      final int start = (_currentPage - 1) * _pageSize + 1;
      final int end = start + _pageSize - 1;

      final hadithResponse = await _hadithService.getHadithByRange(
        widget.book.id,
        start,
        end,
      );

      // Check if there are more hadiths to load
      _hasMoreData =
          hadithResponse.data.hadiths!.length >= _pageSize &&
          start + _pageSize <= widget.book.available;

      setState(() {
        if (_currentPage == 1) {
          _hadiths = hadithResponse.data.hadiths ?? [];
        } else {
          _hadiths.addAll(hadithResponse.data.hadiths ?? []);
        }
        _filteredHadiths = _hadiths;
        _isLoading = false;
        _loadingMore = false;

        // Check if initial hadith number is provided and scroll to it
        if (widget.initialHadithNumber != null && _currentPage == 1) {
          _scrollToHadith(widget.initialHadithNumber!);
        }
      });

      // Check which hadiths are bookmarked
      await _checkBookmarks();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _loadingMore = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load hadiths: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _checkBookmarks() async {
    for (var hadith in _hadiths) {
      final isBookmarked = await _bookmarkService.isBookmarked(
        bookId: widget.book.id,
        hadithNumber: hadith.number,
      );

      if (mounted) {
        setState(() {
          _bookmarkedHadiths[hadith.number] = isBookmarked;
        });
      }
    }
  }

  void _scrollToHadith(int hadithNumber) {
    // Find index of the hadith in the list
    final index = _hadiths.indexWhere((h) => h.number == hadithNumber);
    if (index != -1) {
      // Delay to ensure the list is built
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            index * 200.0, // Approximate height of each item
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    } else {
      // Load more pages until we find the hadith
      _loadUntilHadith(hadithNumber);
    }
  }

  Future<void> _loadUntilHadith(int hadithNumber) async {
    // Calculate which page the hadith should be on
    final targetPage = (hadithNumber / _pageSize).ceil();

    if (_currentPage < targetPage) {
      setState(() {
        _currentPage = targetPage;
      });
      await _loadHadiths();
    }
  }

  void _filterHadiths(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredHadiths = _hadiths;
      } else {
        _filteredHadiths = _hadiths
            .where(
              (hadith) =>
                  hadith.id.toLowerCase().contains(query.toLowerCase()) ||
                  hadith.arab.toLowerCase().contains(query.toLowerCase()) ||
                  hadith.number.toString().contains(query),
            )
            .toList();
      }
    });
  }

  Future<void> _toggleBookmark(Hadith hadith) async {
    final isCurrentlyBookmarked = _bookmarkedHadiths[hadith.number] ?? false;

    if (isCurrentlyBookmarked) {
      // Remove bookmark
      await _bookmarkService.removeBookmark(
        bookId: widget.book.id,
        hadithNumber: hadith.number,
      );

      setState(() {
        _bookmarkedHadiths[hadith.number] = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hadith dihapus dari bookmark')),
        );
      }
    } else {
      // Add bookmark
      await _bookmarkService.addBookmark(
        bookId: widget.book.id,
        bookName: widget.book.name,
        hadithNumber: hadith.number,
        hadithText: hadith.id,
        hadithArabText: hadith.arab,
      );

      setState(() {
        _bookmarkedHadiths[hadith.number] = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hadith ditambahkan ke bookmark')),
        );
      }
    }
  }

  Future<void> _speakHadith(String text) async {
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.book.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF219EBC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: HadithSearchDelegate(
                  hadiths: _hadiths,
                  onHadithSelected: (hadith) {
                    _scrollToHadith(hadith.number);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF219EBC)),
            )
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: _filterHadiths,
                    decoration: InputDecoration(
                      hintText: 'Cari hadith...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF219EBC),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),

                // Hadith list
                Expanded(
                  child: _filteredHadiths.isEmpty
                      ? const Center(
                          child: Text('Tidak ada hadith yang ditemukan'),
                        )
                      : NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (!_loadingMore &&
                                _hasMoreData &&
                                scrollInfo.metrics.pixels >=
                                    scrollInfo.metrics.maxScrollExtent - 200) {
                              setState(() {
                                _currentPage++;
                              });
                              _loadHadiths();
                            }
                            return false;
                          },
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount:
                                _filteredHadiths.length +
                                (_hasMoreData ? 1 : 0),
                            padding: const EdgeInsets.all(16),
                            itemBuilder: (context, index) {
                              if (index >= _filteredHadiths.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF219EBC),
                                    ),
                                  ),
                                );
                              }

                              final hadith = _filteredHadiths[index];
                              final isBookmarked =
                                  _bookmarkedHadiths[hadith.number] ?? false;

                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Hadith number and actions
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF219EBC),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              'Hadith No. ${hadith.number}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              // Text-to-speech
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.volume_up,
                                                  color: Color(0xFF219EBC),
                                                ),
                                                onPressed: () =>
                                                    _speakHadith(hadith.id),
                                              ),
                                              // Bookmark
                                              IconButton(
                                                icon: Icon(
                                                  isBookmarked
                                                      ? Icons.bookmark
                                                      : Icons.bookmark_border,
                                                  color: const Color(
                                                    0xFF219EBC,
                                                  ),
                                                ),
                                                onPressed: () =>
                                                    _toggleBookmark(hadith),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      // Arabic text
                                      Text(
                                        hadith.arab,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Amiri',
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.right,
                                        textDirection: TextDirection.rtl,
                                      ),
                                      const SizedBox(height: 16),
                                      const Divider(),
                                      const SizedBox(height: 8),
                                      // Indonesian translation
                                      Text(
                                        hadith.id,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

// Search delegate for hadiths
class HadithSearchDelegate extends SearchDelegate<Hadith> {
  final List<Hadith> hadiths;
  final Function(Hadith) onHadithSelected;

  HadithSearchDelegate({required this.hadiths, required this.onHadithSelected});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, hadiths.first); // Return first hadith as fallback
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? []
        : hadiths
              .where(
                (hadith) =>
                    hadith.id.toLowerCase().contains(query.toLowerCase()) ||
                    hadith.arab.toLowerCase().contains(query.toLowerCase()) ||
                    hadith.number.toString().contains(query),
              )
              .toList();

    return suggestions.isEmpty
        ? const Center(child: Text('No hadiths found'))
        : ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final hadith = suggestions[index];
              return ListTile(
                title: Text(
                  'Hadith No. ${hadith.number}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  hadith.id,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  onHadithSelected(hadith);
                  close(context, hadith);
                },
              );
            },
          );
  }
}
