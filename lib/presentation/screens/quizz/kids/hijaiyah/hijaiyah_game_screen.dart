import 'package:flutter/material.dart';
import '../../../../../data/models/hijaiyah/hijaiyah_letter.dart';
import '../../../../../services/level_progress_service.dart';

class HijaiyahGameScreen extends StatefulWidget {
  final int level;
  final List<dynamic> levelLetters;

  const HijaiyahGameScreen({
    Key? key,
    required this.level,
    required this.levelLetters,
  }) : super(key: key);

  @override
  State<HijaiyahGameScreen> createState() => _HijaiyahGameScreenState();
}

class _HijaiyahGameScreenState extends State<HijaiyahGameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late List<HijaiyahLetter> _gameLetters;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Convert the dynamic map data back to HijaiyahLetter objects - with error handling and using fromJson
    try {
      _gameLetters = widget.levelLetters
          .map(
            (letterData) =>
                HijaiyahLetter.fromJson(letterData as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      // Fallback if there's an error with the data format
      print('Error processing letter data: $e');
      _gameLetters = [
        HijaiyahLetter(arabic: 'ا', latin: 'Alif', audio: 'alif.mp3'),
      ];
    }

    // Animation controller for letter transitions
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

  void _nextLetter() {
    if (_currentIndex < _gameLetters.length - 1) {
      setState(() {
        _currentIndex++;
        _controller.reset();
        _controller.forward();
      });
    }
  }

  void _previousLetter() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _controller.reset();
        _controller.forward();
      });
    }
  }

  // Function to mark the level as completed
  Future<void> _completeLevel() async {
    try {
      // Default to 3 stars for completing the learning mode
      // In a real app, you might calculate stars based on performance
      const int earnedStars = 3;

      // Mark the level as completed and save progress
      await LevelProgressService.completeLevel(widget.level, earnedStars);

      print('Level ${widget.level + 1} completed with $earnedStars stars');
    } catch (e) {
      print('Error saving level progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLetter = _gameLetters[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Belajar Hijaiyah - Level ${widget.level + 1}'),
        backgroundColor: const Color(0xFF219EBC),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: (_currentIndex + 1) / _gameLetters.length,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF219EBC),
                ),
              ),
              const SizedBox(height: 24),

              // Main content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Letter display with animation
                    GestureDetector(
                      onTap: () {
                        // Interactive tap animation
                        _controller.reset();
                        _controller.forward();

                        // Play audio when tapped (in real app)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Melafalkan: ${currentLetter.latin}'),
                            duration: const Duration(seconds: 1),
                            backgroundColor: const Color(0xFF219EBC),
                          ),
                        );
                      },
                      child: ScaleTransition(
                        scale: _animation,
                        child: Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            color: const Color(0xFF50C6E4),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF50C6E4), Color(0xFF219EBC)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              currentLetter.arabic,
                              style: const TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 3,
                                    color: Color(0x55000000),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tap instruction
                    const Text(
                      "(Ketuk huruf untuk mendengar bunyi)",
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Pronunciation guide
                    Text(
                      currentLetter.latin,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF219EBC),
                      ),
                    ),

                    // Pronounce button
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // In a real app, play audio here
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Melafalkan: ${currentLetter.latin}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.volume_up),
                      label: const Text('Dengarkan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF219EBC),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Page indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _gameLetters.length > 10 ? 10 : _gameLetters.length,
                    (index) {
                      // If there are more than 10 letters, show "..." in the middle
                      if (_gameLetters.length > 10 &&
                          index == 5 &&
                          _currentIndex >= 5 &&
                          _currentIndex < _gameLetters.length - 5) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            '...',
                            style: TextStyle(color: Color(0xFF219EBC)),
                          ),
                        );
                      }

                      int dotIndex;
                      if (_gameLetters.length <= 10) {
                        dotIndex = index;
                      } else if (_currentIndex < 5) {
                        dotIndex = index;
                      } else if (_currentIndex >= _gameLetters.length - 5) {
                        dotIndex = _gameLetters.length - (10 - index);
                      } else {
                        dotIndex = _currentIndex - 5 + index;
                      }

                      if (dotIndex < 0 || dotIndex >= _gameLetters.length)
                        return const SizedBox.shrink();

                      return Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: dotIndex == _currentIndex
                              ? const Color(0xFF219EBC)
                              : Colors.grey.shade300,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous button
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: _currentIndex > 0
                          ? [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _currentIndex > 0 ? _previousLetter : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF50C6E4),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text(
                        'Sebelumnya',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  // Next button
                  Container(
                    decoration: BoxDecoration(
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
                    child: ElevatedButton.icon(
                      onPressed: _currentIndex < _gameLetters.length - 1
                          ? _nextLetter
                          : () {
                              // If at the last letter, show completion dialog
                              // Mark the level as completed
                              _completeLevel();

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => AlertDialog(
                                  title: const Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                      SizedBox(width: 10),
                                      Text('Hebat!'),
                                    ],
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'assets/images/quiz/kids_mode.png',
                                        height: 100,
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Kamu telah mempelajari semua huruf pada level ini. Ayo coba kuis untuk menguji pemahamanmu!',
                                      ),
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Close dialog
                                        Navigator.pop(
                                          context,
                                        ); // Return to level screen
                                      },
                                      child: const Text('Kembali ke Level'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Close dialog
                                        Navigator.pop(
                                          context,
                                        ); // Return to level screen
                                        // In a real app, navigate to quiz here
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF219EBC,
                                        ),
                                      ),
                                      child: const Text('Mulai Kuis'),
                                    ),
                                  ],
                                ),
                              );
                            },
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(
                        _currentIndex < _gameLetters.length - 1
                            ? 'Selanjutnya'
                            : 'Selesai',
                        style: const TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF50C6E4),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
