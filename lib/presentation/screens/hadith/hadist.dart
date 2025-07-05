import 'package:flutter/material.dart';
import '../../../data/models/hadith/hadith_book_model.dart';
import '../../../data/services/hadith/hadith_service.dart';
import '../../../data/services/hadith/bookmark_service.dart';
import '../../../routes/routes.dart';
import 'hadith_detail.dart';

class HadistScreen extends StatefulWidget {
  const HadistScreen({Key? key}) : super(key: key);

  @override
  State<HadistScreen> createState() => _HadistScreenState();
}

class _HadistScreenState extends State<HadistScreen>
    with SingleTickerProviderStateMixin {
  final HadithService _hadithService = HadithService();
  final HadithBookmarkService _bookmarkService = HadithBookmarkService();
  late TabController _tabController;

  bool _isLoading = true;
  bool _loadingBookmarks = true;
  String _searchQuery = '';

  List<HadithBook> _allBooks = [];
  List<HadithBook> _filteredBooks = [];
  List<Map<String, dynamic>> _bookmarks = [];

  // Categories based on book types
  final List<String> _categories = [
    'Semua',
    'Bukhari',
    'Muslim',
    'Abu Daud',
    'Tirmidzi',
    'Lainnya',
  ];
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadHadithBooks();
    _loadBookmarks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadHadithBooks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final booksResponse = await _hadithService.getHadithBooks();
      setState(() {
        _allBooks = booksResponse.data;
        _filteredBooks = _allBooks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load hadith books: ${e.toString()}'),
          ),
        );
      }
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load bookmarks: ${e.toString()}')),
        );
      }
    }
  }

  void _filterBooks(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredBooks = _filterByCategory(_allBooks);
      } else {
        _filteredBooks = _filterByCategory(_allBooks)
            .where(
              (book) =>
                  book.name.toLowerCase().contains(query.toLowerCase()) ||
                  book.id.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  List<HadithBook> _filterByCategory(List<HadithBook> books) {
    if (_selectedCategoryIndex == 0) {
      // "Semua" category - return all books
      return books;
    } else {
      // Get category name and convert to lowercase for comparison
      String category = _categories[_selectedCategoryIndex].toLowerCase();

      // Special case for "Lainnya" category
      if (_selectedCategoryIndex == 5) {
        // Return books that don't match the main categories
        final mainCategories = ['bukhari', 'muslim', 'abu-daud', 'tirmidzi'];
        return books
            .where((book) => !mainCategories.contains(book.id.toLowerCase()))
            .toList();
      }

      // Filter books based on category
      return books
          .where(
            (book) =>
                book.id.toLowerCase().contains(category) ||
                book.name.toLowerCase().contains(category),
          )
          .toList();
    }
  }

  void _selectCategory(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      _filteredBooks = _filterByCategory(_allBooks);
      if (_searchQuery.isNotEmpty) {
        _filterBooks(_searchQuery);
      }
    });
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
                        onChanged: _filterBooks,
                        decoration: const InputDecoration(
                          hintText: 'Cari Hadist...',
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

            // Tabs for Books and Bookmarks
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF219EBC),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF219EBC),
                tabs: const [
                  Tab(text: 'Kitab Hadist'),
                  Tab(text: 'Ditandai'),
                ],
              ),
            ),

            // Category chips
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(_categories[index]),
                      selected: _selectedCategoryIndex == index,
                      selectedColor: const Color(0xFF219EBC).withOpacity(0.2),
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                        color: _selectedCategoryIndex == index
                            ? const Color(0xFF219EBC)
                            : Colors.black87,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          _selectCategory(index);
                        }
                      },
                    ),
                  );
                },
              ),
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Hadith Books Tab
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF219EBC),
                          ),
                        )
                      : _filteredBooks.isEmpty
                      ? const Center(
                          child: Text('Tidak ada kitab hadist yang ditemukan'),
                        )
                      : ListView.builder(
                          itemCount: _filteredBooks.length,
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            final book = _filteredBooks[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HadithDetailScreen(book: book),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF219EBC),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                book.name.substring(0, 1),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  book.name,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${book.available} hadist',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Color(0xFF219EBC),
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                  // Bookmarks Tab
                  _loadingBookmarks
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF219EBC),
                          ),
                        )
                      : _bookmarks.isEmpty
                      ? const Center(
                          child: Text('Tidak ada hadist yang ditandai'),
                        )
                      : ListView.builder(
                          itemCount: _bookmarks.length,
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            final bookmark = _bookmarks[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  try {
                                    // Call service but we don't need the response here
                                    await _hadithService.getSpecificHadith(
                                      bookmark['bookId'],
                                      bookmark['hadithNumber'],
                                    );

                                    if (!mounted) return;

                                    // Navigate to hadith detail screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HadithDetailScreen(
                                          book: HadithBook(
                                            name: bookmark['bookName'],
                                            id: bookmark['bookId'],
                                            available:
                                                0, // This will be updated when loaded
                                          ),
                                          initialHadithNumber:
                                              bookmark['hadithNumber'],
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Failed to load hadith: ${e.toString()}',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF219EBC),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.bookmark,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${bookmark['bookName']} No. ${bookmark['hadithNumber']}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  bookmark['hadithText'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.red,
                                            ),
                                            onPressed: () async {
                                              final confirmed = await showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: const Text(
                                                    'Hapus Bookmark',
                                                  ),
                                                  content: const Text(
                                                    'Apakah Anda yakin ingin menghapus bookmark ini?',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            context,
                                                            false,
                                                          ),
                                                      child: const Text(
                                                        'Batal',
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            context,
                                                            true,
                                                          ),
                                                      child: const Text(
                                                        'Hapus',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );

                                              if (confirmed == true) {
                                                await _bookmarkService
                                                    .removeBookmark(
                                                      bookId:
                                                          bookmark['bookId'],
                                                      hadithNumber:
                                                          bookmark['hadithNumber'],
                                                    );
                                                _loadBookmarks(); // Refresh bookmarks
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// HadithBookmarkItem widget
class HadithBookmarkItem extends StatelessWidget {
  final String bookName;
  final String bookId;
  final int hadithNumber;
  final String hadithText;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const HadithBookmarkItem({
    Key? key,
    required this.bookName,
    required this.bookId,
    required this.hadithNumber,
    required this.hadithText,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFE1F0FF).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: Color(0xFF3699FF), width: 4),
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
                      bookName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF219EBC),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
                'Hadist No. $hadithNumber',
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  hadithText,
                  style: const TextStyle(fontSize: 12),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
