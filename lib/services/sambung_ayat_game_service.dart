import 'dart:math';

import '../data/models/quran/ayat_continuation.dart';
import '../services/ayat_continuation_data_provider.dart';

class SambungAyatGameService {
  // Total number of questions to be answered in each level
  static const int questionsPerLevel = 5;

  // Cache for questions to prevent repetition within a session
  static List<AyatContinuation> _currentLevelQuestions = [];
  static int _currentQuestionIndex = 0;
  static int _currentLevel = 0;

  // Score tracking
  static int _correctAnswers = 0;
  static int _totalQuestions = 0;

  /// Initialize a game session for a specific level
  static void startLevel(int level) {
    _currentLevel = level;
    _correctAnswers = 0;
    _totalQuestions = 0;
    _currentQuestionIndex = 0;

    // Get all questions for this level
    final allLevelQuestions = AyatContinuationDataProvider.getQuestionsForLevel(
      level,
    );

    // Shuffle and select questions
    final random = Random();
    allLevelQuestions.shuffle(random);

    // Take all questions or up to questionsPerLevel
    final count = min(questionsPerLevel, allLevelQuestions.length);
    _currentLevelQuestions = allLevelQuestions.take(count).toList();
  }

  /// Get the current question
  static AyatContinuation? getCurrentQuestion() {
    if (_currentQuestionIndex >= _currentLevelQuestions.length) {
      return null;
    }
    return _currentLevelQuestions[_currentQuestionIndex];
  }

  /// Check if the answer is correct and advance to the next question
  static bool submitAnswer(int selectedOptionIndex) {
    final currentQuestion = getCurrentQuestion();
    if (currentQuestion == null) {
      return false;
    }

    _totalQuestions++;
    final isCorrect = selectedOptionIndex == currentQuestion.correctOptionIndex;

    if (isCorrect) {
      _correctAnswers++;
    }

    _currentQuestionIndex++;
    return isCorrect;
  }

  /// Check if there are more questions in this level
  static bool hasMoreQuestions() {
    return _currentQuestionIndex < _currentLevelQuestions.length;
  }

  /// Get the current progress (question number out of total)
  static String getProgress() {
    return '${_currentQuestionIndex + 1}/${_currentLevelQuestions.length}';
  }

  /// Calculate stars based on correct answers (0-3 stars)
  static int calculateStars() {
    if (_totalQuestions == 0) return 0;

    final percentCorrect = _correctAnswers / _totalQuestions;

    if (percentCorrect >= 0.9) {
      // 90% or higher
      return 3;
    } else if (percentCorrect >= 0.7) {
      // 70% or higher
      return 2;
    } else if (percentCorrect >= 0.5) {
      // 50% or higher
      return 1;
    } else {
      return 0;
    }
  }

  /// Get current level
  static int getCurrentLevel() {
    return _currentLevel;
  }

  /// Get correct answers count
  static int getCorrectAnswers() {
    return _correctAnswers;
  }

  /// Get total questions count
  static int getTotalQuestions() {
    return _totalQuestions;
  }
}
