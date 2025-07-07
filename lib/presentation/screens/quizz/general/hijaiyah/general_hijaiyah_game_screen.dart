import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../../../../data/models/hijaiyah/advanced_hijaiyah_letter.dart';
import '../../../../../services/general_hijaiyah_progress_service.dart';

class GeneralHijaiyahGameScreen extends StatefulWidget {
  final int level;
  final List<AdvancedHijaiyahLetter> levelLetters;

  const GeneralHijaiyahGameScreen({
    Key? key,
    required this.level,
    required this.levelLetters,
  }) : super(key: key);

  @override
  State<GeneralHijaiyahGameScreen> createState() =>
      _GeneralHijaiyahGameScreenState();
}

class _GeneralHijaiyahGameScreenState extends State<GeneralHijaiyahGameScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller for transitions
  late AnimationController _controller;
  late Animation<double> _animation;

  // Game data
  late List<AdvancedHijaiyahLetter> _gameLetters;

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
  int _totalQuestions = 10;
  bool _isAnswered = false;
  String? _selectedAnswer;

  // Timer for time-based scoring
  late Timer _timer;
  int _timeLeft = 20; // seconds
  int _maxTime = 20;

  // Current question data
  late AdvancedHijaiyahLetter _currentQuestion;
  late List<String> _options;
  String _questionType = ''; // What aspect of the letter is being tested

  @override
  void initState() {
    super.initState();
    _gameLetters = widget.levelLetters;
    _totalQuestions = min(
      10,
      _gameLetters.length * 2,
    ); // Each letter can have 2 question types

    // Animation controller for transitions
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
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

    // Randomly select a letter as the question
    final random = Random();
    final letterIndex = random.nextInt(_gameLetters.length);
    _currentQuestion = _gameLetters[letterIndex];

    // Decide what aspect of the letter to test
    // 0: Arabic to Latin, 1: Latin to Arabic, 2: Makhraj (articulation), 3: Form identification
    int questionTypeIndex;
    if (widget.level < 3) {
      // Lower levels: just test basic recognition
      questionTypeIndex = random.nextInt(2);
    } else if (widget.level < 6) {
      // Mid levels: add makhraj questions
      questionTypeIndex = random.nextInt(3);
    } else {
      // Higher levels: all question types
      questionTypeIndex = random.nextInt(4);
    }

    // Set up question and options based on type
    switch (questionTypeIndex) {
      case 0: // Arabic to Latin
        _questionType = 'arabic_to_latin';
        _setupArabicToLatinQuestion();
        break;
      case 1: // Latin to Arabic
        _questionType = 'latin_to_arabic';
        _setupLatinToArabicQuestion();
        break;
      case 2: // Makhraj question
        _questionType = 'makhraj';
        _setupMakhrajQuestion();
        break;
      case 3: // Form identification
        _questionType = 'form';
        _setupFormQuestion();
        break;
      default:
        _questionType = 'arabic_to_latin';
        _setupArabicToLatinQuestion();
    }
  }

  void _setupArabicToLatinQuestion() {
    // Show Arabic letter, ask for Latin name
    _options = [_currentQuestion.latin]; // Correct option

    // Add random wrong options from all letters
    List<String> allLatinNames = widget.levelLetters
        .map((letter) => letter.latin)
        .where(
          (latin) => latin != _currentQuestion.latin,
        ) // Exclude the correct answer
        .toList();

    // Shuffle and take 3 (or fewer if not enough)
    allLatinNames.shuffle();
    int wrongOptionsCount = min(3, allLatinNames.length);
    _options.addAll(allLatinNames.take(wrongOptionsCount));

    // Shuffle options
    _options.shuffle();
  }

  void _setupLatinToArabicQuestion() {
    // Show Latin name, ask for Arabic letter
    _options = [_currentQuestion.arabic]; // Correct option

    // Add random wrong options from all letters
    List<String> allArabicLetters = widget.levelLetters
        .map((letter) => letter.arabic)
        .where(
          (arabic) => arabic != _currentQuestion.arabic,
        ) // Exclude the correct answer
        .toList();

    // Shuffle and take 3 (or fewer if not enough)
    allArabicLetters.shuffle();
    int wrongOptionsCount = min(3, allArabicLetters.length);
    _options.addAll(allArabicLetters.take(wrongOptionsCount));

    // Shuffle options
    _options.shuffle();
  }

  void _setupMakhrajQuestion() {
    // Show Arabic letter, ask for Makhraj
    _options = [_currentQuestion.makhraj]; // Correct option

    // Add random wrong options from all letters
    List<String> allMakhraj = widget.levelLetters
        .map((letter) => letter.makhraj)
        .where(
          (makhraj) => makhraj != _currentQuestion.makhraj,
        ) // Exclude the correct answer
        .toList();

    // Shuffle and take 3 (or fewer if not enough)
    allMakhraj.shuffle();
    int wrongOptionsCount = min(3, allMakhraj.length);
    _options.addAll(allMakhraj.take(wrongOptionsCount));

    // Shuffle options
    _options.shuffle();
  }

  void _setupFormQuestion() {
    // Show a form of the letter, ask for the correct letter
    _options = [_currentQuestion.arabic]; // Correct option

    // Add random wrong options from all letters
    List<String> allArabicLetters = widget.levelLetters
        .map((letter) => letter.arabic)
        .where(
          (arabic) => arabic != _currentQuestion.arabic,
        ) // Exclude the correct answer
        .toList();

    // Shuffle and take 3 (or fewer if not enough)
    allArabicLetters.shuffle();
    int wrongOptionsCount = min(3, allArabicLetters.length);
    _options.addAll(allArabicLetters.take(wrongOptionsCount));

    // Shuffle options
    _options.shuffle();
  }

  void _checkAnswer(String? option) {
    if (_isAnswered) return; // Prevent multiple selections

    // Stop the timer
    _timer.cancel();

    // Calculate time bonus: 0-10 points based on time left
    final timeRatio = _timeLeft / _maxTime;
    _timeBonus = (timeRatio * 10).round();

    setState(() {
      _isAnswered = true;
      _selectedAnswer = option;

      // Check if answer is correct
      bool isCorrect = false;
      switch (_questionType) {
        case 'arabic_to_latin':
          isCorrect = option == _currentQuestion.latin;
          break;
        case 'latin_to_arabic':
          isCorrect = option == _currentQuestion.arabic;
          break;
        case 'makhraj':
          isCorrect = option == _currentQuestion.makhraj;
          break;
        case 'form':
          isCorrect = option == _currentQuestion.arabic;
          break;
      }

      if (isCorrect) {
        _correctAnswers++;
        _streak++;
        if (_streak > _maxStreak) {
          _maxStreak = _streak;
        }

        // Base score + streak bonus + time bonus
        final streakBonus = _streak * 5;
        final pointsEarned = 10 + streakBonus + _timeBonus;
        _score += pointsEarned;
      } else {
        _wrongAnswers++;
        _streak = 0;
      }

      // Calculate accuracy
      final totalAnswered = _correctAnswers + _wrongAnswers;
      _accuracy = totalAnswered > 0 ? _correctAnswers / totalAnswered * 100 : 0;
    });

    // Add a delay before moving to the next question
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_questionIndex < _totalQuestions - 1) {
        _nextQuestion();
      } else {
        _finishGame();
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
      _controller.reset();
      _controller.forward();
      _setupNextQuestion();
      _startTimer();
    });
  }

  Future<void> _finishGame() async {
    // Calculate stars based on accuracy
    int earnedStars = 0;
    if (_accuracy >= 90) {
      earnedStars = 3; // 90%+ accuracy = 3 stars
    } else if (_accuracy >= 70) {
      earnedStars = 2; // 70%+ accuracy = 2 stars
    } else if (_accuracy >= 50) {
      earnedStars = 1; // 50%+ accuracy = 1 star
    }

    // Save progress
    await GeneralHijaiyahProgressService.completeLevel(
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
          'Level Selesai',
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
                  Text('Rentetan Terbaik: $_maxStreak'),
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
                  builder: (context) => GeneralHijaiyahGameScreen(
                    level: widget.level,
                    levelLetters: widget.levelLetters,
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

  String _getQuestionText() {
    switch (_questionType) {
      case 'arabic_to_latin':
        return 'Apa nama huruf ini?';
      case 'latin_to_arabic':
        return 'Huruf mana yang disebut "${_currentQuestion.latin}"?';
      case 'makhraj':
        return 'Dimana makhraj (titik artikulasi) dari huruf ini?';
      case 'form':
        // Pick a random form from the forms array
        final randomFormIndex = Random().nextInt(_currentQuestion.forms.length);
        return 'Huruf apa yang ditampilkan dalam bentuk ini: ${_currentQuestion.forms[randomFormIndex]}?';
      default:
        return 'Identifikasi huruf ini:';
    }
  }

  Widget _getQuestionContent() {
    switch (_questionType) {
      case 'arabic_to_latin':
        return Text(
          _currentQuestion.arabic,
          style: const TextStyle(fontSize: 80, fontFamily: 'Amiri'),
        );
      case 'latin_to_arabic':
        return Column(
          children: [
            Text(
              _currentQuestion.latin,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _currentQuestion.pronounciation,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        );
      case 'makhraj':
        return Column(
          children: [
            Text(
              _currentQuestion.arabic,
              style: const TextStyle(fontSize: 60, fontFamily: 'Amiri'),
            ),
            const SizedBox(height: 8),
            const Text(
              "Dari mana huruf ini dilafalkan?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        );
      case 'form':
        // Pick a random form from the forms array
        final randomFormIndex = Random().nextInt(_currentQuestion.forms.length);
        return Column(
          children: [
            Text(
              _currentQuestion.forms[randomFormIndex],
              style: const TextStyle(fontSize: 60, fontFamily: 'Amiri'),
            ),
            const SizedBox(height: 8),
            const Text(
              "Huruf apa bentuk ini?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        );
      default:
        return Text(
          _currentQuestion.arabic,
          style: const TextStyle(fontSize: 80, fontFamily: 'Amiri'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF219EBC),
        elevation: 0,
        title: Text(
          'Level ${widget.level + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Score display
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Skor: $_score',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
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
              // Top status bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Question counter
                  Text(
                    'Pertanyaan ${_questionIndex + 1}/$_totalQuestions',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),

                  // Streak display
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                      ),
                      Text(
                        '$_streak',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Timer and progress
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Progress bar
                  LinearProgressIndicator(
                    value: _timeLeft / _maxTime,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _timeLeft < 5
                          ? Colors.red
                          : (_timeLeft < 10
                                ? Colors.orange
                                : const Color(0xFF219EBC)),
                    ),
                    minHeight: 20,
                  ), // Time left
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      '$_timeLeft det',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Question prompt
              Text(
                _getQuestionText(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF219EBC),
                ),
              ),

              // Question content - letter, pronunciation, etc.
              Expanded(
                flex: 2,
                child: FadeTransition(
                  opacity: _animation,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE9ECEF)),
                    ),
                    child: Center(child: _getQuestionContent()),
                  ),
                ),
              ),

              // Answer options
              Expanded(
                flex: 3,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2,
                  ),
                  itemCount: _options.length,
                  itemBuilder: (context, index) {
                    final option = _options[index];

                    // Determine the button style based on answer status
                    Color bgColor = Colors.white;
                    Color textColor = const Color(0xFF219EBC);
                    Color borderColor = const Color(0xFFE9ECEF);
                    double elevation = 2;

                    if (_isAnswered) {
                      bool isCorrectOption;
                      switch (_questionType) {
                        case 'arabic_to_latin':
                          isCorrectOption = option == _currentQuestion.latin;
                          break;
                        case 'latin_to_arabic':
                          isCorrectOption = option == _currentQuestion.arabic;
                          break;
                        case 'makhraj':
                          isCorrectOption = option == _currentQuestion.makhraj;
                          break;
                        case 'form':
                          isCorrectOption = option == _currentQuestion.arabic;
                          break;
                        default:
                          isCorrectOption = option == _currentQuestion.latin;
                      }

                      if (isCorrectOption) {
                        // Correct answer
                        bgColor = Colors.green.shade100;
                        textColor = Colors.green.shade800;
                        borderColor = Colors.green;
                        elevation = 0;
                      } else if (option == _selectedAnswer) {
                        // Wrong selected answer
                        bgColor = Colors.red.shade100;
                        textColor = Colors.red.shade800;
                        borderColor = Colors.red;
                        elevation = 0;
                      }
                    }

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: ElevatedButton(
                        onPressed: _isAnswered
                            ? null
                            : () => _checkAnswer(option),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bgColor,
                          foregroundColor: textColor,
                          side: BorderSide(color: borderColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: elevation,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            option,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily:
                                  _questionType == 'latin_to_arabic' ||
                                      _questionType == 'form'
                                  ? 'Amiri'
                                  : null,
                              fontSize:
                                  _questionType == 'latin_to_arabic' ||
                                      _questionType == 'form'
                                  ? 28
                                  : 18,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
