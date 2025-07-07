import 'package:flutter/material.dart';
import 'dart:math';
import '../../../../../routes/routes.dart';
import '../../../../../data/models/hijaiyah/hijaiyah_letter.dart';
import '../../../../../services/level_progress_service.dart';

class KidsHijaiyahScreen extends StatefulWidget {
  const KidsHijaiyahScreen({super.key});

  @override
  State<KidsHijaiyahScreen> createState() => _KidsHijaiyahScreenState();
}

class _KidsHijaiyahScreenState extends State<KidsHijaiyahScreen> {
  // Flag to show level selection or game content
  bool _showLevelSelection = true;
  int _selectedLevel = 0;

  // Track unlocked levels and stars
  List<int> _unlockedLevels = [0]; // Default to first level unlocked
  Map<int, int> _levelStars = {}; // Map of level -> stars
  int _currentStars = 0; // Stars for the current level

  // List of hijaiyah letters for different levels
  final List<List<HijaiyahLetter>> _levelLetters = [
    // Level 1: Basic letters (Alif to Kha)
    [
      HijaiyahLetter(arabic: 'ا', latin: 'Alif', audio: 'alif.mp3'),
      HijaiyahLetter(arabic: 'ب', latin: 'Ba', audio: 'ba.mp3'),
      HijaiyahLetter(arabic: 'ت', latin: 'Ta', audio: 'ta.mp3'),
      HijaiyahLetter(arabic: 'ث', latin: 'Tsa', audio: 'tsa.mp3'),
      HijaiyahLetter(arabic: 'ج', latin: 'Jim', audio: 'jim.mp3'),
      HijaiyahLetter(arabic: 'ح', latin: 'Ha', audio: 'ha.mp3'),
      HijaiyahLetter(arabic: 'خ', latin: 'Kha', audio: 'kha.mp3'),
    ],
    // Level 2: Next set of letters (Dal to Zai)
    [
      HijaiyahLetter(arabic: 'د', latin: 'Dal', audio: 'dal.mp3'),
      HijaiyahLetter(
        arabic: 'ذ',
        latin: 'Dzal',
        audio: 'dza.mp3',
      ), // Menyesuaikan dengan nama file yang tersedia
      HijaiyahLetter(
        arabic: 'ر',
        latin: 'Ra',
        audio: 'ro.mp3',
      ), // Menyesuaikan dengan nama file yang tersedia
      HijaiyahLetter(
        arabic: 'ز',
        latin: 'Zai',
        audio: 'zay.mp3',
      ), // Menyesuaikan dengan nama file yang tersedia
    ],
    // Level 3: (Sin to Dhad)
    [
      HijaiyahLetter(arabic: 'س', latin: 'Sin', audio: 'sin.mp3'),
      HijaiyahLetter(arabic: 'ش', latin: 'Syin', audio: 'syin.mp3'),
      HijaiyahLetter(
        arabic: 'ص',
        latin: 'Shad',
        audio: 'shod.mp3',
      ), // Menyesuaikan dengan nama file yang tersedia
      HijaiyahLetter(
        arabic: 'ض',
        latin: 'Dhad',
        audio: 'dhod.mp3',
      ), // Menyesuaikan dengan nama file yang tersedia
    ],
    // Level 4: (Tha to Ain)
    [
      HijaiyahLetter(
        arabic: 'ط',
        latin: 'Tha',
        audio: 'tho.mp3',
      ), // Menyesuaikan dengan nama file yang tersedia
      HijaiyahLetter(
        arabic: 'ظ',
        latin: 'Zha',
        audio: 'dhzo.mp3',
      ), // Menyesuaikan dengan nama file yang tersedia
      HijaiyahLetter(arabic: 'ع', latin: 'Ain', audio: 'ain.mp3'),
    ],
    // Level 5: (Ghain to Lam)
    [
      HijaiyahLetter(
        arabic: 'غ',
        latin: 'Ghain',
        audio: 'ghoin.mp3',
      ), // Menyesuaikan dengan nama file yang tersedia
      HijaiyahLetter(arabic: 'ف', latin: 'Fa', audio: 'fa.mp3'),
      HijaiyahLetter(
        arabic: 'ق',
        latin: 'Qaf',
        audio: 'qof.mp3',
      ), // Menyesuaikan dengan nama file yang tersedia
      HijaiyahLetter(arabic: 'ك', latin: 'Kaf', audio: 'kaf.mp3'),
      HijaiyahLetter(arabic: 'ل', latin: 'Lam', audio: 'lam.mp3'),
    ],
    // Level 6: (Mim to Ya)
    [
      HijaiyahLetter(arabic: 'م', latin: 'Mim', audio: 'mim.mp3'),
      HijaiyahLetter(arabic: 'ن', latin: 'Nun', audio: 'nun.mp3'),
      HijaiyahLetter(arabic: 'و', latin: 'Waw', audio: 'waw.mp3'),
      HijaiyahLetter(
        arabic: 'ه',
        latin: 'Ha',
        audio: 'ha.mp3',
      ), // Menggunakan ha.mp3 yang tersedia
      HijaiyahLetter(arabic: 'ء', latin: 'Hamzah', audio: 'hamzah.mp3'),
      HijaiyahLetter(arabic: 'ي', latin: 'Ya', audio: 'ya.mp3'),
    ],
    // Level 7: Mixed letters (review) - Group 1
    [
      HijaiyahLetter(arabic: 'ا', latin: 'Alif', audio: 'alif.mp3'),
      HijaiyahLetter(arabic: 'ب', latin: 'Ba', audio: 'ba.mp3'),
      HijaiyahLetter(arabic: 'د', latin: 'Dal', audio: 'dal.mp3'),
      HijaiyahLetter(arabic: 'س', latin: 'Sin', audio: 'sin.mp3'),
      HijaiyahLetter(
        arabic: 'ط',
        latin: 'Tha',
        audio: 'tho.mp3',
      ), // Menyesuaikan dengan nama file yang tersedia
    ],
    // Level 8: Mixed letters (review) - Group 2
    [
      HijaiyahLetter(arabic: 'ج', latin: 'Jim', audio: 'jim.mp3'),
      HijaiyahLetter(arabic: 'ح', latin: 'Ha', audio: 'ha.mp3'),
      HijaiyahLetter(
        arabic: 'ق',
        latin: 'Qaf',
        audio: 'qof.mp3',
      ), // Menyesuaikan dengan nama file yang tersedia
      HijaiyahLetter(arabic: 'م', latin: 'Mim', audio: 'mim.mp3'),
      HijaiyahLetter(arabic: 'ي', latin: 'Ya', audio: 'ya.mp3'),
    ],
    // Level 9: Advanced - Harakat practice
    [
      HijaiyahLetter(
        arabic: 'بَ',
        latin: 'Ba (fathah)',
        audio: 'ba.mp3', // Menggunakan audio dasar yang tersedia
      ),
      HijaiyahLetter(
        arabic: 'بِ',
        latin: 'Bi (kasrah)',
        audio: 'ba.mp3', // Menggunakan audio dasar yang tersedia
      ),
      HijaiyahLetter(
        arabic: 'بُ',
        latin: 'Bu (dhammah)',
        audio: 'ba.mp3', // Menggunakan audio dasar yang tersedia
      ),
      HijaiyahLetter(
        arabic: 'تَ',
        latin: 'Ta (fathah)',
        audio: 'ta.mp3', // Menggunakan audio dasar yang tersedia
      ),
      HijaiyahLetter(
        arabic: 'تِ',
        latin: 'Ti (kasrah)',
        audio: 'ta.mp3', // Menggunakan audio dasar yang tersedia
      ),
      HijaiyahLetter(
        arabic: 'تُ',
        latin: 'Tu (dhammah)',
        audio: 'ta.mp3', // Menggunakan audio dasar yang tersedia
      ),
    ],
    // Level 10: Advanced - Tanwin
    [
      HijaiyahLetter(
        arabic: 'بً',
        latin: 'Ban (fathatain)',
        audio: 'ba.mp3', // Menggunakan audio dasar yang tersedia
      ),
      HijaiyahLetter(
        arabic: 'بٍ',
        latin: 'Bin (kasratain)',
        audio: 'ba.mp3', // Menggunakan audio dasar yang tersedia
      ),
      HijaiyahLetter(
        arabic: 'بٌ',
        latin: 'Bun (dhammatain)',
        audio: 'ba.mp3', // Menggunakan audio dasar yang tersedia
      ),
      HijaiyahLetter(
        arabic: 'مً',
        latin: 'Man (fathatain)',
        audio: 'mim.mp3', // Menggunakan audio dasar yang tersedia
      ),
      HijaiyahLetter(
        arabic: 'مٍ',
        latin: 'Min (kasratain)',
        audio: 'mim.mp3', // Menggunakan audio dasar yang tersedia
      ),
      HijaiyahLetter(
        arabic: 'مٌ',
        latin: 'Mun (dhammatain)',
        audio: 'mim.mp3', // Menggunakan audio dasar yang tersedia
      ),
    ],
  ];

  // Game variables
  List<HijaiyahLetter> _currentGameLetters = [];
  HijaiyahLetter? _currentQuestion;
  List<HijaiyahLetter> _options = [];
  bool _isAnswerCorrect = false;
  bool _isAnswerSelected = false;
  int _questionIndex = 0;
  int _correctAnswers = 0;
  int _totalQuestions = 5; // Number of questions per game

  @override
  void initState() {
    super.initState();
    _loadLevelProgress();
  }

  // Load level progress from storage
  Future<void> _loadLevelProgress() async {
    try {
      final maxLevels = _levelLetters.length;
      final unlockedLevels = await LevelProgressService.getUnlockedLevels(
        maxLevels,
      );

      // Load stars for each level
      final Map<int, int> levelStars = {};
      for (int level in unlockedLevels) {
        final stars = await LevelProgressService.getLevelStars(level);
        levelStars[level] = stars;
      }

      setState(() {
        _unlockedLevels = unlockedLevels;
        _levelStars = levelStars;
      });
    } catch (e) {
      print('Error loading level progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (!_showLevelSelection) {
                        setState(() {
                          _showLevelSelection = true;
                        });
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF219EBC),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    _showLevelSelection
                        ? 'Hijaiyah'
                        : 'Level ${_selectedLevel + 1}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF219EBC),
                    ),
                  ),
                  const Spacer(),
                  if (_showLevelSelection)
                    // Debug option to reset progress (for testing)
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.grey),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Reset Progress?'),
                            content: const Text(
                              'This will reset all level progress. This is for testing only.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Reset'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await LevelProgressService.resetAllProgress();
                          await _loadLevelProgress();

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Progress has been reset'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                    )
                  else if (!_showLevelSelection)
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '$_currentStars',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF219EBC),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Main content based on current view
            _showLevelSelection ? _buildLevelSelectionView() : _buildGameView(),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelSelectionView() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image at the top
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Image.asset(
              'assets/images/quiz/kids_mode.png',
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
          const Text(
            'Pilih Level',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF219EBC),
            ),
          ),
          const SizedBox(height: 16),

          // Grid of level buttons
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: _levelLetters.length,
                itemBuilder: (context, index) {
                  return _buildLevelButton(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelButton(int level) {
    // Get level completion status based on unlocked levels
    bool isLocked = !_unlockedLevels.contains(level);

    // Define colors and icons based on level status
    Color buttonColor = const Color(0xFF50C6E4);
    IconData levelIcon = Icons.lock_open;

    // Stars for this level (if any)
    final stars = _levelStars[level] ?? 0;
    final hasStars = stars > 0;

    if (isLocked) {
      buttonColor = Colors.grey.shade400;
      levelIcon = Icons.lock;
    } else if (hasStars) {
      // Level is completed
      buttonColor = const Color(0xFF219EBC);
      levelIcon = Icons.check_circle;
    }

    return InkWell(
      onTap: isLocked
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Selesaikan level sebelumnya dulu ya!'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          : () {
              // Show options dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Level ${level + 1} - Hijaiyah'),
                  content: const Text('Pilih mode belajar:'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        try {
                          // Create a copy of the letters using the toJson method for cleaner serialization
                          final letters = _levelLetters[level]
                              .map((letter) => letter.toJson())
                              .toList();

                          Navigator.pop(context); // Close dialog

                          // Add loading indicator
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Membuka mode belajar...'),
                              duration: Duration(milliseconds: 500),
                            ),
                          );

                          // Use a slight delay to allow animation to complete
                          Future.delayed(const Duration(milliseconds: 100), () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.kidsHijaiyahGame,
                              arguments: {
                                'level': level,
                                'levelLetters': letters,
                              },
                            ).then((_) {
                              // Refresh level progress when returning from game screen
                              _loadLevelProgress();
                            });
                          });
                        } catch (e) {
                          // Error handling
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Terjadi kesalahan: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          print('Error navigating to game screen: $e');
                        }
                      },
                      child: const Text('Pelajari Huruf'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        setState(() {
                          _selectedLevel = level;
                          _showLevelSelection = false;
                          _startGame(level);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF219EBC),
                      ),
                      child: const Text('Mulai Kuis'),
                    ),
                  ],
                ),
              );
            },
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(levelIcon, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              'Level ${level + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (stars > 0) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => Icon(
                    index < stars ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _startGame(int level) async {
    // Reset game variables
    _questionIndex = 0;
    _correctAnswers = 0;
    _isAnswerSelected = false;

    // Load previous stars for this level
    _currentStars = await LevelProgressService.getLevelStars(level);

    // Get letters for the selected level
    _currentGameLetters = _levelLetters[level];

    // Set up the first question
    _setupNextQuestion();
  }

  void _setupNextQuestion() {
    // Reset state
    _isAnswerSelected = false;

    // Randomly select a letter as the question
    final random = Random();
    _currentQuestion =
        _currentGameLetters[random.nextInt(_currentGameLetters.length)];

    // Create options (including the correct answer and random wrong answers)
    _options = [_currentQuestion!];

    // Add random wrong options from all available letters
    List<HijaiyahLetter> allLetters = _levelLetters
        .expand((letters) => letters)
        .toList();
    allLetters.remove(_currentQuestion);
    allLetters.shuffle();

    // Take 3 wrong options (or fewer if not enough letters)
    int wrongOptionsCount = min(3, allLetters.length);
    _options.addAll(allLetters.take(wrongOptionsCount));

    // Shuffle options
    _options.shuffle();
  }

  Widget _buildGameView() {
    if (_questionIndex >= _totalQuestions) {
      // Show game completion screen
      return _buildGameCompletionView();
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (_questionIndex + 1) / _totalQuestions,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF219EBC),
              ),
            ),
            const SizedBox(height: 16),

            // Question display
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Manakah huruf "${_currentQuestion?.latin}"?',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF219EBC),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Options grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: _options.length,
                itemBuilder: (context, index) {
                  return _buildOptionCard(_options[index]);
                },
              ),
            ),

            // Next button appears after answering
            if (_isAnswerSelected)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_questionIndex < _totalQuestions - 1) {
                      setState(() {
                        _questionIndex++;
                        _setupNextQuestion();
                      });
                    } else {
                      // End of game
                      setState(() {
                        _questionIndex = _totalQuestions;
                        // Calculate stars based on performance
                        _currentStars = (_correctAnswers / _totalQuestions * 3)
                            .round();

                        // Save the progress
                        LevelProgressService.completeLevel(
                          _selectedLevel,
                          _currentStars,
                        );
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF50C6E4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Lanjutkan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(HijaiyahLetter letter) {
    bool isCorrectAnswer = letter.arabic == _currentQuestion?.arabic;

    // Determine the card color based on selection status
    Color cardColor = const Color(0xFF50C6E4);
    if (_isAnswerSelected) {
      if (isCorrectAnswer) {
        cardColor = Colors.green;
      } else if (_isAnswerCorrect == false &&
          letter.arabic == _currentQuestion?.arabic) {
        cardColor = Colors.red;
      }
    }

    return InkWell(
      onTap: _isAnswerSelected
          ? null
          : () {
              setState(() {
                _isAnswerSelected = true;
                _isAnswerCorrect = isCorrectAnswer;
                if (_isAnswerCorrect) {
                  _correctAnswers++;
                }
              });

              // Feedback when option is selected
              if (isCorrectAnswer) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Hebat! Jawaban benar!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 1),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Jawaban benar adalah: ${_currentQuestion?.arabic} (${_currentQuestion?.latin})',
                    ),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            letter.arabic,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameCompletionView() {
    // Calculate stars based on performance
    int stars = (_correctAnswers / _totalQuestions * 3).round();

    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Congratulatory message
            const Text(
              'Selamat!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF219EBC),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Kamu benar $_correctAnswers dari $_totalQuestions soal',
              style: const TextStyle(fontSize: 18, color: Color(0xFF50C6E4)),
            ),
            const SizedBox(height: 32),

            // Stars display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Icon(
                  index < stars ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 48,
                );
              }),
            ),
            const SizedBox(height: 40),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Replay button
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _startGame(_selectedLevel);
                    });
                  },
                  icon: const Icon(Icons.replay),
                  label: const Text('Main Lagi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF50C6E4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Back to levels button
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showLevelSelection = true;
                    });
                  },
                  icon: const Icon(Icons.grid_view),
                  label: const Text('Pilih Level'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF219EBC),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
