import 'package:flutter/material.dart';
import '../../../../../data/models/quran/ayat_continuation.dart';
import '../../../../../services/ayat_continuation_data_provider.dart';
import '../../../../../services/sambung_ayat_game_service.dart';
import '../../../../../services/sambung_ayat_progress_service.dart';

class SambungAyatGameScreen extends StatefulWidget {
  final int level;

  const SambungAyatGameScreen({super.key, required this.level});

  @override
  State<SambungAyatGameScreen> createState() => _SambungAyatGameScreenState();
}

class _SambungAyatGameScreenState extends State<SambungAyatGameScreen> {
  late AyatContinuation? _currentQuestion;
  bool _isLoading = true;
  bool _showResults = false;
  bool _isAnswering = false;
  int? _selectedOptionIndex;
  int _stars = 0;
  String _levelTitle = '';

  // Animation controllers
  bool _showCorrectAnswer = false;
  bool _showIncorrectFeedback = false;

  @override
  void initState() {
    super.initState();
    _initLevel();
  }

  Future<void> _initLevel() async {
    // Get level information
    _levelTitle = AyatContinuationDataProvider.getLevelTitle(widget.level);

    // Start the game session
    SambungAyatGameService.startLevel(widget.level);
    _currentQuestion = SambungAyatGameService.getCurrentQuestion();

    setState(() {
      _isLoading = false;
      _showResults = false;
      _selectedOptionIndex = null;
    });
  }

  void _selectOption(int index) {
    if (_isAnswering) return;

    setState(() {
      _selectedOptionIndex = index;
      _isAnswering = true;
    });

    // Check if the answer is correct
    final isCorrect = SambungAyatGameService.submitAnswer(index);

    // Show animation for correct/incorrect
    setState(() {
      if (isCorrect) {
        _showCorrectAnswer = true;
      } else {
        _showIncorrectFeedback = true;
      }
    });

    // Wait for animation to complete then move to next question
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      setState(() {
        _showCorrectAnswer = false;
        _showIncorrectFeedback = false;
        _isAnswering = false;
        _selectedOptionIndex = null;
      });

      // Check if there are more questions
      if (SambungAyatGameService.hasMoreQuestions()) {
        setState(() {
          _currentQuestion = SambungAyatGameService.getCurrentQuestion();
        });
      } else {
        _finishLevel();
      }
    });
  }

  Future<void> _finishLevel() async {
    // Calculate stars based on performance
    final stars = SambungAyatGameService.calculateStars();

    // Save progress
    await SambungAyatProgressService.completeLevel(widget.level, stars);

    // Show results
    setState(() {
      _stars = stars;
      _showResults = true;
    });
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
                      _showExitDialog(context);
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Level ${widget.level + 1}: $_levelTitle',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF219EBC),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!_isLoading && !_showResults)
                          Text(
                            'Pertanyaan: ${SambungAyatGameService.getProgress()}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF219EBC),
                      ),
                    )
                  : _showResults
                  ? _buildResultScreen()
                  : _buildQuestionScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Surah information
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Surah ${_currentQuestion!.surahName} (${_currentQuestion!.surahNumber})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF023047),
                  ),
                ),
                Text(
                  'Ayat ${_currentQuestion!.startAyat}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Ayat text
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  _currentQuestion!.startAyatText,
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'KFGQPC Uthmanic Script',
                    height: 1.5,
                    color: Color(0xFF023047),
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.blue.shade100, thickness: 1),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Lanjutkan dengan',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.blue.shade100, thickness: 1),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Options
          ...List.generate(
            _currentQuestion!.options.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GestureDetector(
                onTap: _isAnswering ? null : () => _selectOption(index),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: _getOptionColor(index),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: _getOptionBorderColor(index),
                      width: _selectedOptionIndex == index ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    _currentQuestion!.options[index],
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'KFGQPC Uthmanic Script',
                      height: 1.5,
                      color: _selectedOptionIndex == index
                          ? Colors.white
                          : const Color(0xFF023047),
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getOptionColor(int index) {
    if (!_isAnswering) {
      return Colors.white;
    }
    if (_showCorrectAnswer && index == _currentQuestion!.correctOptionIndex) {
      return Colors.green; // Green for correct answer
    }

    if (_showIncorrectFeedback) {
      if (index == _selectedOptionIndex) {
        return Colors.red; // Red for selected wrong answer
      }
      if (index == _currentQuestion!.correctOptionIndex) {
        return Colors.blue.shade50; // Light blue for the correct one
      }
    }

    if (_selectedOptionIndex == index) {
      return const Color(0xFF219EBC); // Blue for selection
    }

    return Colors.white;
  }

  Color _getOptionBorderColor(int index) {
    if (_isAnswering) {
      if (_showCorrectAnswer && index == _currentQuestion!.correctOptionIndex) {
        return Colors.green; // Green for correct
      }
      if (_showIncorrectFeedback) {
        if (index == _selectedOptionIndex) {
          return Colors.red; // Red for incorrect
        }
        if (index == _currentQuestion!.correctOptionIndex) {
          return Colors.green; // Green for correct
        }
      }
      if (_selectedOptionIndex == index) {
        return const Color(0xFF219EBC); // Blue for selection
      }
    }
    return const Color(0xFFDCECF2); // Default border
  }

  Widget _buildResultScreen() {
    final correctAnswers = SambungAyatGameService.getCorrectAnswers();
    final totalQuestions = SambungAyatGameService.getTotalQuestions();
    final percentCorrect = (correctAnswers / totalQuestions * 100).round();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Result title
          const Text(
            'Selamat!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF219EBC),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Anda telah menyelesaikan Level ${widget.level + 1}',
            style: const TextStyle(fontSize: 18, color: Color(0xFF023047)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  index < _stars ? Icons.star : Icons.star_border,
                  color: index < _stars
                      ? Colors.amber
                      : const Color(0xFFCCCCCC),
                  size: 48,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Score
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Jawaban Benar:',
                      style: TextStyle(fontSize: 16, color: Color(0xFF023047)),
                    ),
                    Text(
                      '$correctAnswers dari $totalQuestions',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF023047),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Persentase:',
                      style: TextStyle(fontSize: 16, color: Color(0xFF023047)),
                    ),
                    Text(
                      '$percentCorrect%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF023047),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),

          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: Colors.blue.shade50,
                    foregroundColor: const Color(0xFF219EBC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(color: Colors.blue.shade100),
                    ),
                  ),
                  child: const Text(
                    'Kembali ke Level',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    _initLevel();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: const Color(0xFF219EBC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Coba Lagi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (widget.level < 9) // Not the last level
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FutureBuilder<bool>(
                future: SambungAyatProgressService.isLevelUnlocked(
                  widget.level + 1,
                ),
                builder: (context, snapshot) {
                  final nextLevelUnlocked = snapshot.data ?? false;
                  if (nextLevelUnlocked) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SambungAyatGameScreen(level: widget.level + 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24,
                        ),
                        backgroundColor: const Color(0xFF023047),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Level Selanjutnya',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Keluar dari Level',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF023047),
            ),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar? Progres pada level ini tidak akan disimpan.',
            style: TextStyle(color: Colors.grey),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Batal',
                style: TextStyle(color: Color(0xFF219EBC)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF219EBC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Keluar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
