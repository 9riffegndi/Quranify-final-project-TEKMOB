import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage level completion and progress tracking for the General Tajwid game
class GeneralTajwidProgressService {
  static const String _generalTajwidLevelPrefix = 'general_tajwid_level_';
  static const String _generalTajwidStarsPrefix = 'general_tajwid_stars_';
  static const String _generalTajwidScorePrefix = 'general_tajwid_score_';
  static const String _generalTajwidAccuracyPrefix = 'general_tajwid_accuracy_';

  /// Check if a specific level is unlocked
  static Future<bool> isLevelUnlocked(int level) async {
    if (level == 0) return true; // First level is always unlocked

    final prefs = await SharedPreferences.getInstance();

    // A level is unlocked if the previous level is completed
    return prefs.getBool('${_generalTajwidLevelPrefix}${level - 1}') ?? false;
  }

  /// Get all unlocked levels
  static Future<List<int>> getUnlockedLevels(int maxLevels) async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedLevels = <int>[];

    // First level is always unlocked
    unlockedLevels.add(0);

    for (int i = 1; i < maxLevels; i++) {
      final isUnlocked =
          prefs.getBool('${_generalTajwidLevelPrefix}${i - 1}') ?? false;
      if (isUnlocked) {
        unlockedLevels.add(i);
      } else {
        break; // Stop once we reach a locked level
      }
    }

    return unlockedLevels;
  }

  /// Mark a level as completed and unlock the next one
  static Future<void> completeLevel(
    int level,
    int stars,
    int score,
    double accuracy,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    // Mark this level as completed
    await prefs.setBool('${_generalTajwidLevelPrefix}$level', true);

    // Update stars if it's a higher score
    final currentStars =
        prefs.getInt('${_generalTajwidStarsPrefix}$level') ?? 0;
    if (stars > currentStars) {
      await prefs.setInt('${_generalTajwidStarsPrefix}$level', stars);
    }

    // Update high score
    final currentScore =
        prefs.getInt('${_generalTajwidScorePrefix}$level') ?? 0;
    if (score > currentScore) {
      await prefs.setInt('${_generalTajwidScorePrefix}$level', score);
    }

    // Update best accuracy
    final currentAccuracy =
        prefs.getDouble('${_generalTajwidAccuracyPrefix}$level') ?? 0.0;
    if (accuracy > currentAccuracy) {
      await prefs.setDouble('${_generalTajwidAccuracyPrefix}$level', accuracy);
    }
  }

  /// Get the number of stars for a specific level
  static Future<int> getLevelStars(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('${_generalTajwidStarsPrefix}$level') ?? 0;
  }

  /// Get the high score for a specific level
  static Future<int> getLevelHighScore(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('${_generalTajwidScorePrefix}$level') ?? 0;
  }

  /// Get the best accuracy for a specific level
  static Future<double> getLevelBestAccuracy(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('${_generalTajwidAccuracyPrefix}$level') ?? 0.0;
  }

  /// Get total stars across all levels
  static Future<int> getTotalStars(int maxLevels) async {
    final prefs = await SharedPreferences.getInstance();
    int totalStars = 0;

    for (int i = 0; i < maxLevels; i++) {
      totalStars += prefs.getInt('${_generalTajwidStarsPrefix}$i') ?? 0;
    }

    return totalStars;
  }

  /// Get completion percentage
  static Future<double> getCompletionPercentage(int maxLevels) async {
    final prefs = await SharedPreferences.getInstance();
    int completedLevels = 0;

    for (int i = 0; i < maxLevels; i++) {
      if (prefs.getBool('${_generalTajwidLevelPrefix}$i') ?? false) {
        completedLevels++;
      }
    }

    return completedLevels / maxLevels * 100;
  }

  /// Get total score across all levels
  static Future<int> getTotalScore(int maxLevels) async {
    final prefs = await SharedPreferences.getInstance();
    int totalScore = 0;

    for (int i = 0; i < maxLevels; i++) {
      totalScore += prefs.getInt('${_generalTajwidScorePrefix}$i') ?? 0;
    }

    return totalScore;
  }

  /// Get average accuracy across all completed levels
  static Future<double> getAverageAccuracy(int maxLevels) async {
    final prefs = await SharedPreferences.getInstance();
    double totalAccuracy = 0;
    int completedLevels = 0;

    for (int i = 0; i < maxLevels; i++) {
      final accuracy =
          prefs.getDouble('${_generalTajwidAccuracyPrefix}$i') ?? 0.0;
      if (accuracy > 0) {
        totalAccuracy += accuracy;
        completedLevels++;
      }
    }

    return completedLevels > 0 ? totalAccuracy / completedLevels : 0.0;
  }

  /// Reset all progress (for testing purposes)
  static Future<void> resetAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (final key in keys) {
      if (key.startsWith('general_tajwid_')) {
        await prefs.remove(key);
      }
    }
  }

  /// Check if user has mastered a specific rule (consistently high accuracy)
  static Future<bool> hasUserMasteredRule(String ruleName) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'general_tajwid_rule_mastery_$ruleName';
    return prefs.getBool(key) ?? false;
  }

  /// Mark a rule as mastered
  static Future<void> markRuleAsMastered(String ruleName) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'general_tajwid_rule_mastery_$ruleName';
    await prefs.setBool(key, true);
  }

  /// Get mastered rules count
  static Future<int> getMasteredRulesCount() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    int count = 0;

    for (final key in keys) {
      if (key.startsWith('general_tajwid_rule_mastery_') &&
          (prefs.getBool(key) ?? false)) {
        count++;
      }
    }

    return count;
  }
}
