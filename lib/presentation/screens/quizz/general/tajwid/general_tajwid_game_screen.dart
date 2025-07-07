import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../../../../data/models/tajwid/advanced_tajwid_rule.dart';
import '../../../../../services/general_tajwid_progress_service.dart';

class GeneralTajwidGameScreen extends StatefulWidget {
  final int level;
  final List<AdvancedTajwidRule> levelRules;
  final String levelTitle;

  const GeneralTajwidGameScreen({
    Key? key,
    required this.level,
    required this.levelRules,
    required this.levelTitle,
  }) : super(key: key);

  @override
  State<GeneralTajwidGameScreen> createState() =>
      _GeneralTajwidGameScreenState();
}

class _GeneralTajwidGameScreenState extends State<GeneralTajwidGameScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller for transitions
  late AnimationController _controller;

  // Game data
  late List<AdvancedTajwidRule> _gameRules;

  // Game state variables
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  int _score = 0;
  int _streak = 0;
  int _maxStreak = 0;
  int _timeBonus = 0;
  double _accuracy = 0.0;

  // Question tracking
  int _questionIndex = 0;
  int _totalQuestions = 12;
  bool _isAnswered = false;
  String? _selectedAnswer;

  // Timer for time-based scoring
  late Timer _timer;
  int _timeLeft = 25; // seconds (longer for Tajwid)
  int _maxTime = 25;

  // Current question data
  late AdvancedTajwidRule _currentRule;
  late List<String> _options;
  String _questionType = ''; // What aspect of the rule is being tested
  String _questionText = '';
  String _questionArabic = '';

  @override
  void initState() {
    super.initState();
    _gameRules = widget.levelRules;
    _totalQuestions = min(
      12,
      _gameRules.length * 3,
    ); // More questions for Tajwid

    // Animation controller for transitions
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _controller.forward();

    // Set up the first question
    _setupNextQuestion();

    // Start the timer
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timeLeft = _maxTime;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          // Time's up - count as wrong answer if not already answered
          if (!_isAnswered) {
            _checkAnswer(null); // No answer selected
          }
        }
      });
    });
  }

  void _setupNextQuestion() {
    // Reset state
    _isAnswered = false;
    _selectedAnswer = null;
    _timeLeft = _maxTime;

    // Randomly select a rule as the question
    final random = Random();
    final ruleIndex = random.nextInt(_gameRules.length);
    _currentRule = _gameRules[ruleIndex];

    // Decide what aspect of the rule to test
    // 0: Rule name from description, 1: Rule description from name, 2: Example identification, 3: Condition identification
    int questionTypeIndex = random.nextInt(4);

    // Set up question and options based on type
    switch (questionTypeIndex) {
      case 0: // Rule name from description
        _questionType = 'name_from_description';
        _setupNameFromDescriptionQuestion();
        break;
      case 1: // Rule description from name
        _questionType = 'description_from_name';
        _setupDescriptionFromNameQuestion();
        break;
      case 2: // Example identification
        _questionType = 'example_identification';
        _setupExampleIdentificationQuestion();
        break;
      case 3: // Condition identification
        _questionType = 'condition_identification';
        _setupConditionIdentificationQuestion();
        break;
      default:
        _questionType = 'name_from_description';
        _setupNameFromDescriptionQuestion();
    }
  }

  void _setupNameFromDescriptionQuestion() {
    // Show description, ask for rule name
    _questionText = 'Apa nama kaidah Tajwid ini?';
    _questionArabic = _currentRule.description;
    _options = [_currentRule.name]; // Correct option

    // Add random wrong options from all rules
    List<String> allRuleNames = widget.levelRules
        .map((rule) => rule.name)
        .where((name) => name != _currentRule.name)
        .toList();

    // Add some common wrong options if needed
    if (allRuleNames.length < 3) {
      allRuleNames.addAll([
        'Idgham',
        'Ikhfa',
        'Iqlab',
        'Idzhar',
        'Qalqalah',
        'Mad Thobi\'i',
      ]);
      allRuleNames = allRuleNames
          .where((name) => name != _currentRule.name)
          .toList();
    }

    // Shuffle and take 3 (or fewer if not enough)
    allRuleNames.shuffle();
    int wrongOptionsCount = min(3, allRuleNames.length);
    _options.addAll(allRuleNames.take(wrongOptionsCount));

    // Shuffle options
    _options.shuffle();
  }

  void _setupDescriptionFromNameQuestion() {
    // Show rule name, ask for description
    _questionText = 'Apa arti "${_currentRule.name}"?';
    _questionArabic = _currentRule.arabicName;
    _options = [_currentRule.description]; // Correct option

    // Add random wrong options from all rules
    List<String> allDescriptions = widget.levelRules
        .map((rule) => rule.description)
        .where((desc) => desc != _currentRule.description)
        .toList();

    // Shuffle and take 3 (or fewer if not enough)
    allDescriptions.shuffle();
    int wrongOptionsCount = min(3, allDescriptions.length);
    _options.addAll(allDescriptions.take(wrongOptionsCount));

    // Shuffle options
    _options.shuffle();
  }

  void _setupExampleIdentificationQuestion() {
    // Show example, ask which rule applies
    if (_currentRule.examples.isNotEmpty) {
      _questionText = 'Kaidah Tajwid apa yang berlaku pada contoh ini?';
      _questionArabic = _currentRule.examples.first;
      _options = [_currentRule.name]; // Correct option

      // Add random wrong options
      List<String> allRuleNames = widget.levelRules
          .map((rule) => rule.name)
          .where((name) => name != _currentRule.name)
          .toList();

      allRuleNames.shuffle();
      int wrongOptionsCount = min(3, allRuleNames.length);
      _options.addAll(allRuleNames.take(wrongOptionsCount));

      // Shuffle options
      _options.shuffle();
    } else {
      // Fallback to name from description
      _setupNameFromDescriptionQuestion();
    }
  }

  void _setupConditionIdentificationQuestion() {
    // Show rule name, ask for condition
    _questionText = 'Kapan "${_currentRule.name}" diterapkan?';
    _questionArabic = _currentRule.arabicName;
    _options = [_currentRule.condition]; // Correct option

    // Add random wrong options from all rules
    List<String> allConditions = widget.levelRules
        .map((rule) => rule.condition)
        .where((condition) => condition != _currentRule.condition)
        .toList();

    // Shuffle and take 3 (or fewer if not enough)
    allConditions.shuffle();
    int wrongOptionsCount = min(3, allConditions.length);
    _options.addAll(allConditions.take(wrongOptionsCount));

    // Shuffle options
    _options.shuffle();
  }

  void _checkAnswer(String? selectedAnswer) {
    if (_isAnswered) return;

    setState(() {
      _isAnswered = true;
      _selectedAnswer = selectedAnswer;
    });

    String correctAnswer = '';
    switch (_questionType) {
      case 'name_from_description':
        correctAnswer = _currentRule.name;
        break;
      case 'description_from_name':
        correctAnswer = _currentRule.description;
        break;
      case 'example_identification':
        correctAnswer = _currentRule.name;
        break;
      case 'condition_identification':
        correctAnswer = _currentRule.condition;
        break;
    }

    bool isCorrect = selectedAnswer == correctAnswer;

    if (isCorrect) {
      _correctAnswers++;
      _streak++;
      _maxStreak = max(_maxStreak, _streak);

      // Score calculation
      int baseScore = 100;
      _timeBonus = (_timeLeft * 5); // 5 points per second remaining
      int streakBonus = _streak * 10; // 10 points per streak
      int difficultyBonus =
          _currentRule.difficulty * 5; // 5 points per difficulty level

      int questionScore =
          baseScore + _timeBonus + streakBonus + difficultyBonus;
      _score += questionScore;

      // Check if user has mastered this rule
      if (_streak >= 3) {
        GeneralTajwidProgressService.markRuleAsMastered(_currentRule.name);
      }
    } else {
      _wrongAnswers++;
      _streak = 0;
    }

    // Calculate accuracy
    int totalAnswered = _correctAnswers + _wrongAnswers;
    _accuracy = (totalAnswered > 0)
        ? (_correctAnswers / totalAnswered) * 100
        : 0;

    // Move to next question after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (_questionIndex < _totalQuestions - 1) {
        setState(() {
          _questionIndex++;
        });
        _setupNextQuestion();
        _startTimer();
      } else {
        _finishGame();
      }
    });
  }

  void _finishGame() async {
    _timer.cancel();

    // Calculate final stars based on accuracy
    int earnedStars = 0;
    if (_accuracy >= 90) {
      earnedStars = 3; // 90%+ accuracy = 3 stars
    } else if (_accuracy >= 75) {
      earnedStars = 2; // 75%+ accuracy = 2 stars
    } else if (_accuracy >= 60) {
      earnedStars = 1; // 60%+ accuracy = 1 star
    }

    // Save progress
    await GeneralTajwidProgressService.completeLevel(
      widget.level,
      earnedStars,
      _score,
      _accuracy,
    );

    // Show completion dialog
    if (mounted) {
      _showCompletionDialog(earnedStars);
    }
  }

  void _showCompletionDialog(int stars) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          'Level Selesai!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF219EBC),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Stars display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Icon(
                  index < stars ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Score details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Skor Akhir: $_score',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Akurasi: ${_accuracy.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: _getAccuracyColor(_accuracy),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text('Jawaban Benar: $_correctAnswers'),
                  Text('Jawaban Salah: $_wrongAnswers'),
                  Text('Streak Tertinggi: $_maxStreak'),
                  Text(
                    'Kaidah Dikuasai: ${_correctAnswers > 5 ? 'Ya' : 'Terus berlatih!'}',
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(
                context,
              ).pop(true); // Return to level selection with refresh signal
            },
            child: const Text(
              'Kembali ke Level',
              style: TextStyle(color: Color(0xFF219EBC)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Restart the game with the same level
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => GeneralTajwidGameScreen(
                    level: widget.level,
                    levelRules: widget.levelRules,
                    levelTitle: widget.levelTitle,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF219EBC),
            ),
            child: const Text(
              'Main Lagi',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 80) {
      return Colors.green;
    } else if (accuracy >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF219EBC),
        title: Text(
          widget.levelTitle,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Timer display
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$_timeLeft',
              style: TextStyle(
                color: _timeLeft <= 5 ? Colors.red : const Color(0xFF219EBC),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress bar
              LinearProgressIndicator(
                value: (_questionIndex + 1) / _totalQuestions,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF219EBC),
                ),
              ),
              const SizedBox(height: 16),

              // Question counter and score
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pertanyaan ${_questionIndex + 1} dari $_totalQuestions',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Skor: $_score',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF219EBC),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Question text
              Text(
                _questionText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Arabic text (if applicable)
              if (_questionArabic.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _questionArabic,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF023047),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Options
              Expanded(
                child: ListView.builder(
                  itemCount: _options.length,
                  itemBuilder: (context, index) {
                    final option = _options[index];
                    bool isSelected = _selectedAnswer == option;
                    bool isCorrect = false;
                    bool showResult = _isAnswered;

                    if (showResult) {
                      if (_questionType == 'name_from_description' ||
                          _questionType == 'example_identification') {
                        isCorrect = option == _currentRule.name;
                      } else if (_questionType == 'description_from_name') {
                        isCorrect = option == _currentRule.description;
                      } else if (_questionType == 'condition_identification') {
                        isCorrect = option == _currentRule.condition;
                      }
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: _isAnswered ? null : () => _checkAnswer(option),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: showResult
                                ? (isCorrect
                                      ? Colors.green.shade100
                                      : (isSelected
                                            ? Colors.red.shade100
                                            : Colors.grey.shade100))
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: showResult
                                  ? (isCorrect
                                        ? Colors.green
                                        : (isSelected
                                              ? Colors.red
                                              : Colors.grey))
                                  : (isSelected
                                        ? const Color(0xFF219EBC)
                                        : Colors.grey),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: showResult
                                        ? (isCorrect
                                              ? Colors.green.shade800
                                              : (isSelected
                                                    ? Colors.red.shade800
                                                    : Colors.black))
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              if (showResult && isCorrect)
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              if (showResult && isSelected && !isCorrect)
                                const Icon(Icons.cancel, color: Colors.red),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Beruntun: $_streak',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Akurasi: ${_accuracy.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getAccuracyColor(_accuracy),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
