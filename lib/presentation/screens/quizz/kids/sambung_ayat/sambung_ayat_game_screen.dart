import 'package:flutter/material.dart';
import '../../../../../data/models/ayat_data.dart';
import '../../../../../services/sambung_ayat_progress_service.dart';

class SambungAyatGameScreen extends StatefulWidget {
  final int level;
  final List<AyatData> levelVerses;

  const SambungAyatGameScreen({
    Key? key,
    required this.level,
    required this.levelVerses,
  }) : super(key: key);

  @override
  State<SambungAyatGameScreen> createState() => _SambungAyatGameScreenState();
}

class _SambungAyatGameScreenState extends State<SambungAyatGameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late List<AyatData> _gameVerses;
  int _currentIndex = 0;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  bool _isAnswered = false;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _gameVerses = widget.levelVerses;

    // Animation controller for transitions
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkAnswer(String option) {
    if (_isAnswered) return; // Prevent multiple selections

    setState(() {
      _isAnswered = true;
      _selectedAnswer = option;

      // Check if answer is correct
      if (option == _gameVerses[_currentIndex].continuation) {
        _correctAnswers++;
      } else {
        _wrongAnswers++;
      }
    });

    // Add a delay before moving to the next question
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_currentIndex < _gameVerses.length - 1) {
        _nextQuestion();
      } else {
        _finishGame();
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentIndex++;
      _isAnswered = false;
      _selectedAnswer = null;
      _controller.reset();
      _controller.forward();
    });
  }

  Future<void> _finishGame() async {
    // Calculate stars based on performance
    final totalQuestions = _gameVerses.length;
    final percentageCorrect = _correctAnswers / totalQuestions;

    int earnedStars = 0;
    if (percentageCorrect >= 0.9) {
      earnedStars = 3; // 90%+ correct = 3 stars
    } else if (percentageCorrect >= 0.7) {
      earnedStars = 2; // 70%+ correct = 2 stars
    } else if (percentageCorrect >= 0.5) {
      earnedStars = 1; // 50%+ correct = 1 star
    }

    // Save progress
    await SambungAyatProgressService.completeLevel(widget.level, earnedStars);

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
          'Selamat!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF219EBC),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Kamu telah menyelesaikan level ini',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            Text(
              'Jawaban Benar: $_correctAnswers',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Jawaban Salah: $_wrongAnswers',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Return to level selection
            },
            child: const Text(
              'Kembali ke Pilihan Level',
              style: TextStyle(color: Color(0xFF219EBC)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentVerse = _gameVerses[_currentIndex];
    final options = currentVerse.options;

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: (_currentIndex + 1) / _gameVerses.length,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF219EBC),
                ),
              ),
              const SizedBox(height: 8),

              // Question counter
              Text(
                'Pertanyaan ${_currentIndex + 1} dari ${_gameVerses.length}',
                textAlign: TextAlign.end,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Surah and verse info
              FadeTransition(
                opacity: _animation,
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text(
                          '${currentVerse.surah} (${currentVerse.surahNumber}:${currentVerse.verseNumber})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF219EBC),
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Arabic text
              FadeTransition(
                opacity: _animation,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE9ECEF)),
                  ),
                  child: Text(
                    currentVerse.arabicText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      height: 1.5,
                      fontFamily: 'Amiri', // Use a suitable Arabic font
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Translation
              Text(
                currentVerse.translation,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 24),

              // Question prompt
              const Text(
                'Sambungkan ayat di atas:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF219EBC),
                ),
              ),

              const SizedBox(height: 16),

              // Answer options
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];

                    // Determine the button color based on answer status
                    Color bgColor = Colors.white;
                    Color textColor = Colors.black;
                    Color borderColor = Colors.grey;

                    if (_isAnswered) {
                      if (option == currentVerse.continuation) {
                        // Correct answer
                        bgColor = Colors.green.shade100;
                        textColor = Colors.green.shade800;
                        borderColor = Colors.green;
                      } else if (option == _selectedAnswer) {
                        // Wrong selected answer
                        bgColor = Colors.red.shade100;
                        textColor = Colors.red.shade800;
                        borderColor = Colors.red;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: AnimatedContainer(
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
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            elevation: _isAnswered ? 0 : 2,
                          ),
                          child: Text(
                            option,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Amiri', // Use a suitable Arabic font
                              color: textColor,
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
