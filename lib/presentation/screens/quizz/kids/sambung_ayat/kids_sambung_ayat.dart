import 'package:flutter/material.dart';
import '../../../../../data/services/provider/sambung_ayat_data_provider.dart';
import '../../../../../services/sambung_ayat_progress_service.dart';
import 'sambung_ayat_game_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KidsSambungAyatScreen extends StatefulWidget {
  const KidsSambungAyatScreen({super.key});

  @override
  State<KidsSambungAyatScreen> createState() => _KidsSambungAyatScreenState();
}

class _KidsSambungAyatScreenState extends State<KidsSambungAyatScreen> {
  // Flag to show level selection or game content
  bool _isLoading = true;

  // Track unlocked levels and stars
  List<int> _unlockedLevels = [0]; // Default to first level unlocked
  Map<int, int> _levelStars = {}; // Map of level -> stars
  int _totalStars = 0;
  int _totalLevels = 10; // We have 10 levels defined in SambungAyatDataProvider

  @override
  void initState() {
    super.initState();
    _loadLevelProgress();
  }

  Future<void> _loadLevelProgress() async {
    // Load unlocked levels and stars data from SharedPreferences
    try {
      final unlockedLevels = await SambungAyatProgressService.getUnlockedLevels(
        _totalLevels,
      );
      final Map<int, int> levelStars = {};
      int totalStars = 0;

      // Get stars for each level
      for (int i = 0; i < _totalLevels; i++) {
        final stars = await SambungAyatProgressService.getLevelStars(i);
        levelStars[i] = stars;
        totalStars += stars;
      }

      setState(() {
        _unlockedLevels = unlockedLevels;
        _levelStars = levelStars;
        _totalStars = totalStars;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading level progress: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Navigate to game screen when a level is selected
  void _startLevel(int level) {
    // Get the verses for the selected level
    final levelVerses = SambungAyatDataProvider.getVersesForLevel(level);

    // Navigate to the game screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SambungAyatGameScreen(level: level, levelVerses: levelVerses),
      ),
    ).then((_) {
      // Refresh the level data when returning from the game screen
      _loadLevelProgress();
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
            // Header with back button and stars
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
                    'Sambung Ayat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF219EBC),
                    ),
                  ),
                  const Spacer(),
                  // Star count display
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 24),
                      const SizedBox(width: 4),
                      Text(
                        '$_totalStars',
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

            // Main content - Level selection
            _isLoading ? _buildLoadingView() : _buildLevelSelectionView(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Expanded(
      child: Center(child: CircularProgressIndicator(color: Color(0xFF219EBC))),
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
            child: SvgPicture.asset(
              'assets/images/mosque_vector.svg',
              height: 150,
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
                itemCount: _totalLevels,
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
          : () => _startLevel(level),
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Level number and icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${level + 1}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isLocked ? Colors.grey.shade600 : Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  levelIcon,
                  color: isLocked ? Colors.grey.shade600 : Colors.white,
                  size: 18,
                ),
              ],
            ),

            // Show stars if level is completed
            if (hasStars) ...[
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
}
