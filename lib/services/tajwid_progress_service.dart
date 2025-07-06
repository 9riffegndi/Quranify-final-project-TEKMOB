import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage level completion and progress tracking for Tajwid game
class TajwidProgressService {
  static const String _tajwidLevelPrefix = 'tajwid_level_';
  static const String _tajwidStarsPrefix = 'tajwid_stars_';

  /// Check if a specific level is unlocked
  static Future<bool> isLevelUnlocked(int level) async {
    if (level == 0) return true; // First level is always unlocked

    final prefs = await SharedPreferences.getInstance();

    // A level is unlocked if the previous level is completed
    return prefs.getBool('${_tajwidLevelPrefix}${level - 1}') ?? false;
  }

  /// Get all unlocked levels
  static Future<List<int>> getUnlockedLevels(int maxLevels) async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedLevels = <int>[];

    // First level is always unlocked
    unlockedLevels.add(0);

    for (int i = 1; i < maxLevels; i++) {
      final isUnlocked =
          prefs.getBool('${_tajwidLevelPrefix}${i - 1}') ?? false;
      if (isUnlocked) {
        unlockedLevels.add(i);
      } else {
        break; // Stop once we reach a locked level
      }
    }

    return unlockedLevels;
  }

  /// Mark a level as completed and unlock the next one
  static Future<void> completeLevel(int level, int stars) async {
    final prefs = await SharedPreferences.getInstance();

    // Mark this level as completed
    await prefs.setBool('${_tajwidLevelPrefix}$level', true);

    // Update stars if it's a higher score
    final currentStars = prefs.getInt('${_tajwidStarsPrefix}$level') ?? 0;
    if (stars > currentStars) {
      await prefs.setInt('${_tajwidStarsPrefix}$level', stars);
    }
  }

  /// Get the number of stars for a specific level
  static Future<int> getLevelStars(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('${_tajwidStarsPrefix}$level') ?? 0;
  }

  /// Get total stars across all levels
  static Future<int> getTotalStars(int maxLevels) async {
    final prefs = await SharedPreferences.getInstance();
    int totalStars = 0;

    for (int i = 0; i < maxLevels; i++) {
      totalStars += prefs.getInt('${_tajwidStarsPrefix}$i') ?? 0;
    }

    return totalStars;
  }

  /// Reset all progress (for testing purposes)
  static Future<void> resetAllProgress() async {
    final prefs = await SharedPreferences.getInstance();

    // Get all keys and filter for our prefixes
    final keys = prefs.getKeys();
    final levelKeys = keys.where(
      (key) =>
          key.startsWith(_tajwidLevelPrefix) ||
          key.startsWith(_tajwidStarsPrefix),
    );

    // Remove all keys
    for (final key in levelKeys) {
      await prefs.remove(key);
    }
  }
}
