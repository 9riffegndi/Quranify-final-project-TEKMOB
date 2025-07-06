import 'package:flutter/material.dart';
import '../../../../../data/services/provider/advanced_tajwid_data_provider.dart';
import '../../../../../services/general_tajwid_progress_service.dart';
import 'general_tajwid_game_screen.dart';

class GeneralTajwidScreen extends StatefulWidget {
  const GeneralTajwidScreen({super.key});

  @override
  State<GeneralTajwidScreen> createState() => _GeneralTajwidScreenState();
}

class _GeneralTajwidScreenState extends State<GeneralTajwidScreen> {
  // Constants
  static const int _maxLevels = 10;
  bool _isLoading = true;
  List<int> _unlockedLevels = [];
  List<int> _levelStars = [];
  int _totalStars = 0;
  double _completionPercentage = 0.0;
  int _masteredRules = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  // Load progress data from shared preferences
  Future<void> _loadProgress() async {
    _unlockedLevels = await GeneralTajwidProgressService.getUnlockedLevels(
      _maxLevels,
    );
    _totalStars = await GeneralTajwidProgressService.getTotalStars(_maxLevels);
    _completionPercentage =
        await GeneralTajwidProgressService.getCompletionPercentage(_maxLevels);
    _masteredRules = await GeneralTajwidProgressService.getMasteredRulesCount();

    // Get stars for each level
    _levelStars = [];
    for (int i = 0; i < _maxLevels; i++) {
      final stars = await GeneralTajwidProgressService.getLevelStars(i);
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

    final levelRules = AdvancedTajwidDataProvider.getRulesForLevel(level);
    final levelTitle = AdvancedTajwidDataProvider.getLevelTitle(level);

    if (levelRules.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data tidak tersedia untuk level ini')),
      );
      return;
    }

    // Get high score and best accuracy for the level
    final highScore = await GeneralTajwidProgressService.getLevelHighScore(
      level,
    );
    final bestAccuracy =
        await GeneralTajwidProgressService.getLevelBestAccuracy(level);

    if (!mounted) return;

    // Show level preview dialog
    final shouldStart = await showDialog<bool>(
      context: context,
      builder: (context) => _buildLevelPreviewDialog(
        level + 1,
        levelTitle,
        AdvancedTajwidDataProvider.getLevelDescription(level),
        levelRules.length,
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
          builder: (context) => GeneralTajwidGameScreen(
            level: level,
            levelRules: levelRules,
            levelTitle: levelTitle,
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
    String title,
    String description,
    int rulesCount,
    int highScore,
    double bestAccuracy,
  ) {
    return AlertDialog(
      title: Text(
        'Level $levelNumber: $title',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF219EBC),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            description,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),

          // Level details
          Row(
            children: [
              const Icon(Icons.school, color: Color(0xFF219EBC), size: 20),
              const SizedBox(width: 8),
              Text('Kaidah: $rulesCount'),
            ],
          ),
          const SizedBox(height: 8),

          // Previous stats if available
          if (highScore > 0) ...[
            Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                Text('Skor Tertinggi: $highScore'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.analytics, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text('Akurasi Terbaik: ${bestAccuracy.toStringAsFixed(1)}%'),
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
          child: const Text('Batal', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF219EBC),
          ),
          child: const Text(
            'Mulai Level',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  String _getLevelTip(int levelIndex) {
    final tips = [
      'Fokus pada empat kaidah utama: Idzhar, Idgham, Ikhfa, dan Iqlab.',
      'Ingat kaidah bibir: Ikhfa Shafawi, Idgham Shafawi, dan Idzhar Shafawi.',
      'Dengarkan bunyi pantulan pada huruf Qalqalah: ق ط ب ج د',
      'Perhatikan panjang Mad: 2, 4, 5, atau 6 harakat.',
      'Latih pelafalan Ra tebal dan tipis berdasarkan harakat.',
      'Kuasai kaidah Lam tebal dan tipis pada lafadz "Allah".',
      'Kaidah Mad lanjutan memerlukan latihan yang teliti.',
      'Pelajari tempat waqaf yang tepat untuk bacaan yang indah.',
      'Kombinasi kompleks menguji penguasaan berbagai kaidah.',
      'Ini adalah ujian tertinggi - terapkan seluruh pengetahuan Tajwid Anda!',
    ];

    return tips[levelIndex];
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
                    'Tantangan Tajwid Umum',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stars and completion
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Bintang: $_totalStars / ${_maxLevels * 3}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF023047),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Progres: ${_completionPercentage.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF023047),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Mastered rules
                  Row(
                    children: [
                      const Icon(Icons.verified, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Kaidah Dikuasai: $_masteredRules',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Kuasai seni Tajwid melalui 10 level komprehensif. Pelajari kaidah pelafalan, mad (panjang pendek), dan teknik tilawah yang benar.',
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
                              childAspectRatio: 1.2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: _maxLevels,
                        itemBuilder: (context, index) {
                          bool isUnlocked = _unlockedLevels.contains(index);
                          int stars = _levelStars[index];
                          String levelTitle =
                              AdvancedTajwidDataProvider.getLevelTitle(index);

                          return TajwidLevelCard(
                            level: index + 1,
                            title: levelTitle,
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

// TajwidLevelCard widget to display each level in the grid
class TajwidLevelCard extends StatelessWidget {
  final int level;
  final String title;
  final bool isUnlocked;
  final int stars;
  final VoidCallback onTap;

  const TajwidLevelCard({
    Key? key,
    required this.level,
    required this.title,
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Level title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Lock icon or stars
            Positioned(
              bottom: 8,
              right: 8,
              child: isUnlocked
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        return Icon(
                          index < stars ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 18,
                        );
                      }),
                    )
                  : const Icon(Icons.lock, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
