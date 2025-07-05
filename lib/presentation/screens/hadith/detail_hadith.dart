import 'package:flutter/material.dart';
import '../../../data/services/hadith/hadith_service.dart';
import '../../../data/services/hadith/bookmark_service.dart';

class DetailHadithScreen extends StatefulWidget {
  final String bookId;
  final int hadithNumber;

  const DetailHadithScreen({
    Key? key,
    required this.bookId,
    required this.hadithNumber,
  }) : super(key: key);

  @override
  State<DetailHadithScreen> createState() => _DetailHadithScreenState();
}

class _DetailHadithScreenState extends State<DetailHadithScreen> {
  final HadithService _hadithService = HadithService();
  final HadithBookmarkService _bookmarkService = HadithBookmarkService();
  bool _isLoading = true;
  bool _isBookmarked = false;
  Map<String, dynamic>? _hadithData;

  @override
  void initState() {
    super.initState();
    _loadHadith();
    _checkBookmark();
  }

  Future<void> _loadHadith() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _hadithService.getSpecificHadith(
        widget.bookId,
        widget.hadithNumber,
      );

      setState(() {
        _hadithData = {
          'bookId': response.data.id,
          'bookName': response.data.name,
          'hadithNumber': response.data.contents!.number,
          'hadithText': response.data.contents!.id,
          'hadithArabText': response.data.contents!.arab,
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load hadith: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _checkBookmark() async {
    try {
      final isBookmarked = await _bookmarkService.isBookmarked(
        bookId: widget.bookId,
        hadithNumber: widget.hadithNumber,
      );

      setState(() {
        _isBookmarked = isBookmarked;
      });
    } catch (e) {
      // Silently fail
      print('Error checking bookmark status: $e');
    }
  }

  Future<void> _toggleBookmark() async {
    try {
      if (_hadithData == null) return;

      bool success;
      if (_isBookmarked) {
        // Remove bookmark
        success = await _bookmarkService.removeBookmark(
          bookId: widget.bookId,
          hadithNumber: widget.hadithNumber,
        );

        if (success) {
          setState(() {
            _isBookmarked = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Bookmark removed')));
          }
        }
      } else {
        // Add bookmark
        success = await _bookmarkService.addBookmark(
          bookId: _hadithData!['bookId'],
          bookName: _hadithData!['bookName'],
          hadithNumber: _hadithData!['hadithNumber'],
          hadithText: _hadithData!['hadithText'],
          hadithArabText: _hadithData!['hadithArabText'],
        );

        if (success) {
          setState(() {
            _isBookmarked = true;
          });
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Bookmark added')));
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update bookmark: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Hadith'),
        backgroundColor: const Color(0xFF219EBC),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: Icon(
                _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              ),
              onPressed: _toggleBookmark,
              color: Colors.white,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hadithData == null
          ? const Center(child: Text('Failed to load hadith'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF219EBC).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.menu_book, color: Color(0xFF219EBC)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _hadithData!['bookName'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF219EBC),
                                ),
                              ),
                              Text(
                                'Hadith No. ${_hadithData!['hadithNumber']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Arabic text
                  if (_hadithData!['hadithArabText'] != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SelectableText(
                        _hadithData!['hadithArabText'],
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 22,
                          height: 1.8,
                          fontFamily: 'Scheherazade',
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),

                  const Divider(thickness: 1),
                  const SizedBox(height: 16),

                  // Indonesian translation
                  Text(
                    _hadithData!['hadithText'],
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
    );
  }
}
