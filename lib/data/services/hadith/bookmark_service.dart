import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HadithBookmarkService {
  static const String _bookmarksKey = 'hadith_bookmarks';

  // Add a hadith bookmark
  Future<bool> addBookmark({
    required String bookId,
    required String bookName,
    required int hadithNumber,
    required String hadithText,
    String? hadithArabText,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get existing bookmarks
      final List<Map<String, dynamic>> bookmarks = await getBookmarks();

      // Check if bookmark already exists
      final bool exists = bookmarks.any(
        (bookmark) =>
            bookmark['bookId'] == bookId &&
            bookmark['hadithNumber'] == hadithNumber,
      );

      if (exists) {
        return false; // Bookmark already exists
      }

      // Add new bookmark
      bookmarks.add({
        'bookId': bookId,
        'bookName': bookName,
        'hadithNumber': hadithNumber,
        'hadithText': hadithText,
        'hadithArabText': hadithArabText,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      // Save updated bookmarks
      await prefs.setString(_bookmarksKey, json.encode(bookmarks));
      return true;
    } catch (e) {
      print('Error adding hadith bookmark: $e');
      return false;
    }
  }

  // Remove a hadith bookmark
  Future<bool> removeBookmark({
    required String bookId,
    required int hadithNumber,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get existing bookmarks
      final List<Map<String, dynamic>> bookmarks = await getBookmarks();

      // Filter out the bookmark to remove
      final filteredBookmarks = bookmarks
          .where(
            (bookmark) =>
                !(bookmark['bookId'] == bookId &&
                    bookmark['hadithNumber'] == hadithNumber),
          )
          .toList();

      // Save updated bookmarks
      await prefs.setString(_bookmarksKey, json.encode(filteredBookmarks));
      return true;
    } catch (e) {
      print('Error removing hadith bookmark: $e');
      return false;
    }
  }

  // Check if a hadith is bookmarked
  Future<bool> isBookmarked({
    required String bookId,
    required int hadithNumber,
  }) async {
    try {
      // Get existing bookmarks
      final List<Map<String, dynamic>> bookmarks = await getBookmarks();

      // Check if bookmark exists
      return bookmarks.any(
        (bookmark) =>
            bookmark['bookId'] == bookId &&
            bookmark['hadithNumber'] == hadithNumber,
      );
    } catch (e) {
      print('Error checking hadith bookmark: $e');
      return false;
    }
  }

  // Get all hadith bookmarks
  Future<List<Map<String, dynamic>>> getBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? bookmarksJson = prefs.getString(_bookmarksKey);

      if (bookmarksJson == null || bookmarksJson.isEmpty) {
        return [];
      }

      final List<dynamic> decodedList = json.decode(bookmarksJson);
      return List<Map<String, dynamic>>.from(decodedList);
    } catch (e) {
      print('Error getting hadith bookmarks: $e');
      return [];
    }
  }
}
