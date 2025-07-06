import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static const String _bookmarksKey = 'quran_bookmarks';

  // Add a bookmark
  Future<bool> addBookmark({
    required int surahNumber,
    required String surahName,
    required int ayatNumber,
    required String ayatText,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get existing bookmarks
      final List<Map<String, dynamic>> bookmarks = await getBookmarks();

      // Check if bookmark already exists
      final bool exists = bookmarks.any(
        (bookmark) =>
            bookmark['surahNumber'] == surahNumber &&
            bookmark['ayatNumber'] == ayatNumber,
      );

      if (exists) {
        return false; // Bookmark already exists
      }

      // Add new bookmark
      bookmarks.add({
        'surahNumber': surahNumber,
        'surahName': surahName,
        'ayatNumber': ayatNumber,
        'ayatText': ayatText,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      // Save updated bookmarks
      await prefs.setString(_bookmarksKey, json.encode(bookmarks));
      return true;
    } catch (e) {
      print('Error adding bookmark: $e');
      return false;
    }
  }

  // Remove a bookmark
  Future<bool> removeBookmark({
    required int surahNumber,
    required int ayatNumber,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get existing bookmarks
      final List<Map<String, dynamic>> bookmarks = await getBookmarks();

      // Filter out the bookmark to remove
      final filteredBookmarks = bookmarks
          .where(
            (bookmark) =>
                !(bookmark['surahNumber'] == surahNumber &&
                    bookmark['ayatNumber'] == ayatNumber),
          )
          .toList();

      // Save updated bookmarks
      await prefs.setString(_bookmarksKey, json.encode(filteredBookmarks));
      return true;
    } catch (e) {
      print('Error removing bookmark: $e');
      return false;
    }
  }

  // Check if an ayat is bookmarked
  Future<bool> isBookmarked({
    required int surahNumber,
    required int ayatNumber,
  }) async {
    try {
      // Get existing bookmarks
      final List<Map<String, dynamic>> bookmarks = await getBookmarks();

      // Check if bookmark exists
      return bookmarks.any(
        (bookmark) =>
            bookmark['surahNumber'] == surahNumber &&
            bookmark['ayatNumber'] == ayatNumber,
      );
    } catch (e) {
      print('Error checking bookmark: $e');
      return false;
    }
  }

  // Get all bookmarks
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
      print('Error getting bookmarks: $e');
      return [];
    }
  }
}
