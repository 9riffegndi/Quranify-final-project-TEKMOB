import 'package:flutter/material.dart';
import '../../../../../data/models/tajwid/tajwid_rule.dart';
import '../../../../../services/tajwid_progress_service.dart';

class TajwidGameScreen extends StatefulWidget {
  final int level;
  final List<TajwidRule> levelRules;

  const TajwidGameScreen({
    Key? key,
    required this.level,
    required this.levelRules,
  }) : super(key: key);

  @override
  State<TajwidGameScreen> createState() => _TajwidGameScreenState();
}

class _TajwidGameScreenState extends State<TajwidGameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late List<TajwidRule> _gameRules;
  int _currentIndex = 0;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  bool _isAnswered = false;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _gameRules = widget.levelRules;

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
      if (option == _gameRules[_currentIndex].name) {
        _correctAnswers++;
      } else {
        _wrongAnswers++;
      }
    });

    // Add a delay before moving to the next question
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_currentIndex < _gameRules.length - 1) {
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
    final totalQuestions = _gameRules.length;
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
    await TajwidProgressService.completeLevel(widget.level, earnedStars);

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

  String _getTypeIcon(String type) {
    switch (type) {
      case 'idgham':
        return "🔄"; // Symbol for merging/combining
      case 'ikhfa':
        return "🔍"; // Symbol for hiding/subtle
      case 'iqlab':
        return "🔄"; // Symbol for conversion
      case 'izhhar':
        return "👁️"; // Symbol for clear/visible
      default:
        return "📖";
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'idgham':
        return Colors.purple.shade200;
      case 'ikhfa':
        return Colors.teal.shade200;
      case 'iqlab':
        return Colors.orange.shade200;
      case 'izhhar':
        return Colors.blue.shade200;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRule = _gameRules[_currentIndex];
    final options = currentRule.options;

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
                value: (_currentIndex + 1) / _gameRules.length,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF219EBC),
                ),
              ),
              const SizedBox(height: 8),

              // Question counter
              Text(
                'Pertanyaan ${_currentIndex + 1} dari ${_gameRules.length}',
                textAlign: TextAlign.end,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 16),

              // Rule type tag
              FadeTransition(
                opacity: _animation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(currentRule.type),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _getTypeIcon(currentRule.type),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            currentRule.type.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                    currentRule.arabicText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      height: 1.5,
                      fontFamily: 'Amiri', // Use a suitable Arabic font
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                currentRule.description,
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
                'Apa hukum tajwid yang benar?',
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
                      if (option == currentRule.name) {
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
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Example text at the bottom
              if (currentRule.example.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contoh:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentRule.example,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 20,
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
