import 'package:flutter/material.dart';
import '../../../../../data/services/provider/advanced_hijaiyah_data_provider.dart';
import '../../../../../services/general_hijaiyah_progress_service.dart';
import 'general_hijaiyah_game_screen.dart';

class GeneralHijaiyahScreen extends StatefulWidget {
  const GeneralHijaiyahScreen({super.key});

  @override
  State<GeneralHijaiyahScreen> createState() => _GeneralHijaiyahScreenState();
}

class _GeneralHijaiyahScreenState extends State<GeneralHijaiyahScreen> {
  // Constants
  static const int _maxLevels = 10;
  bool _isLoading = true;
  List<int> _unlockedLevels = [];
  List<int> _levelStars = [];
  int _totalStars = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  // Load progress data from shared preferences
  Future<void> _loadProgress() async {
    _unlockedLevels = await GeneralHijaiyahProgressService.getUnlockedLevels(
      _maxLevels,
    );
    _totalStars = await GeneralHijaiyahProgressService.getTotalStars(
      _maxLevels,
    );

    // Get stars for each level
    _levelStars = [];
    for (int i = 0; i < _maxLevels; i++) {
      final stars = await GeneralHijaiyahProgressService.getLevelStars(i);
      _levelStars.add(stars);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Navigate to game screen for selected level
  void _startLevel(int level) async {
    if (!_unlockedLevels.contains(level)) {
      return; // Don't start locked levels
    }

    final levelLetters = AdvancedHijaiyahDataProvider.getLettersForLevel(level);
    if (levelLetters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No data available for this level')),
      );
      return;
    }

    // Get high score and best accuracy for the level
    final highScore = await GeneralHijaiyahProgressService.getLevelHighScore(
      level,
    );
    final bestAccuracy =
        await GeneralHijaiyahProgressService.getLevelBestAccuracy(level);

    if (!mounted) return;

    // Show level preview dialog
    final shouldStart = await showDialog<bool>(
      context: context,
      builder: (context) => _buildLevelPreviewDialog(
        level + 1,
        _getLevelDescription(level),
        levelLetters.length,
        highScore,
        bestAccuracy,
      ),
    );

    // Start the game if user confirms
    if (shouldStart == true) {
      // Navigate to game screen
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GeneralHijaiyahGameScreen(
            level: level,
            levelLetters: levelLetters,
          ),
        ),
      );

      // Refresh data when returning from game screen
      if (result != null && result == true) {
        _loadProgress();
      }
    }
  }

  // Build the level preview dialog
  Widget _buildLevelPreviewDialog(
    int levelNumber,
    String description,
    int letterCount,
    int highScore,
    double bestAccuracy,
  ) {
    return AlertDialog(
      title: Text(
        'Level $levelNumber',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF219EBC),
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            description,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Level details
          Row(
            children: [
              const Icon(Icons.menu_book, color: Color(0xFF219EBC), size: 20),
              const SizedBox(width: 8),
              Text('Letters: $letterCount'),
            ],
          ),
          const SizedBox(height: 8),

          // Previous stats if available
          if (highScore > 0) ...[
            Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                Text('High Score: $highScore'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.analytics, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text('Best Accuracy: ${bestAccuracy.toStringAsFixed(1)}%'),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Level tips
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tips:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(_getLevelTip(levelNumber - 1)),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF219EBC),
          ),
          child: const Text(
            'Start Level',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  String _getLevelTip(int levelIndex) {
    final tips = [
      'Focus on the small differences in shapes. Pay attention to dots!',
      'Listen carefully to similar sounding letters and note their differences.',
      'Practice the correct tongue and mouth positions for each letter.',
      'Heavy letters require raising the back of the tongue to the roof of the mouth.',
      'Light letters are pronounced without raising the back of the tongue.',
      'Pay attention to how letters change form based on their position in a word.',
      'Focus on the short vowel marks and how they affect pronunciation.',
      'Speed is key! Try to recognize letters quickly without sacrificing accuracy.',
      'Match the correct articulation point with each letter\'s characteristics.',
      'This level tests all your skills. Take your time and use what you\'ve learned!',
    ];

    return tips[levelIndex];
  }

  String _getLevelDescription(int levelIndex) {
    final descriptions = [
      'Similar Shapes', // Level 1
      'Similar Phonetics', // Level 2
      'Makhraj Focus', // Level 3
      'Heavy Letters', // Level 4
      'Light Letters', // Level 5
      'Forms & Positions', // Level 6
      'Harakat & Vowels', // Level 7
      'Speed Challenge', // Level 8
      'Makhraj & Sifat', // Level 9
      'Master Challenge', // Level 10
    ];

    return descriptions[levelIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button and title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
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
                  const Text(
                    'General Hijaiyah Challenge',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF219EBC),
                    ),
                  ),
                ],
              ),
            ),

            // Progress information
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Total Stars: $_totalStars / ${_maxLevels * 3}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF023047),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Test your knowledge of Hijaiyah letters across 10 challenging levels. Learn the proper pronunciation, forms, and articulation points.',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ),

            const SizedBox(height: 16),

            // Level grid
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.5,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: _maxLevels,
                        itemBuilder: (context, index) {
                          bool isUnlocked = _unlockedLevels.contains(index);
                          int stars = _levelStars[index];

                          return LevelCard(
                            level: index + 1,
                            isUnlocked: isUnlocked,
                            stars: stars,
                            onTap: () => _startLevel(index),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// LevelCard widget to display each level in the grid
class LevelCard extends StatelessWidget {
  final int level;
  final bool isUnlocked;
  final int stars;
  final VoidCallback onTap;

  const LevelCard({
    Key? key,
    required this.level,
    required this.isUnlocked,
    required this.stars,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isUnlocked ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isUnlocked
                ? [Color(0xFF219EBC), Color(0xFF023047)]
                : [Colors.grey[400]!, Colors.grey[600]!],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Level content
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Level number
                  Text(
                    'Level $level',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Level description
                  Text(
                    _getLevelDescription(level - 1),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Lock icon or stars
            Positioned(
              bottom: 10,
              right: 10,
              child: isUnlocked
                  ? Row(
                      children: List.generate(3, (index) {
                        return Icon(
                          index < stars ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    )
                  : const Icon(Icons.lock, color: Colors.white, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  String _getLevelDescription(int levelIndex) {
    final descriptions = [
      'Similar Shapes', // Level 1
      'Similar Phonetics', // Level 2
      'Makhraj Focus', // Level 3
      'Heavy Letters', // Level 4
      'Light Letters', // Level 5
      'Forms & Positions', // Level 6
      'Harakat & Vowels', // Level 7
      'Speed Challenge', // Level 8
      'Makhraj & Sifat', // Level 9
      'Master Challenge', // Level 10
    ];

    return descriptions[levelIndex];
  }
}
