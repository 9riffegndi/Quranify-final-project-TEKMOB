import 'package:flutter/material.dart';
import '../../../../../services/ayat_continuation_data_provider.dart';
import '../../../../../services/sambung_ayat_progress_service.dart';
import 'sambung_ayat_game_screen.dart';

class GeneralSambungAyatScreen extends StatefulWidget {
  const GeneralSambungAyatScreen({super.key});

  @override
  State<GeneralSambungAyatScreen> createState() =>
      _GeneralSambungAyatScreenState();
}

class _GeneralSambungAyatScreenState extends State<GeneralSambungAyatScreen> {
  static const int totalLevels = 10;
  List<int> _unlockedLevels = [];
  Map<int, int> _levelStars = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final unlockedLevels = await SambungAyatProgressService.getUnlockedLevels(
      totalLevels,
    );

    final levelStars = <int, int>{};
    for (int i = 0; i < totalLevels; i++) {
      final stars = await SambungAyatProgressService.getLevelStars(i);
      levelStars[i] = stars;
    }

    setState(() {
      _unlockedLevels = unlockedLevels;
      _levelStars = levelStars;
      _isLoading = false;
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
                ],
              ),
            ),

            // Brief explanation
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Ujilah pengetahuan Anda dengan melanjutkan ayat-ayat Al-Quran. '
                'Selesaikan level untuk membuka level selanjutnya.',
                style: TextStyle(fontSize: 14, color: Color(0xFF023047)),
              ),
            ),

            // Total stars counter
            if (!_isLoading)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFFB703), size: 28),
                    const SizedBox(width: 8),
                    FutureBuilder<int>(
                      future: SambungAyatProgressService.getTotalStars(
                        totalLevels,
                      ),
                      builder: (context, snapshot) {
                        final totalStars = snapshot.data ?? 0;
                        return Text(
                          '$totalStars / ${totalLevels * 3}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF023047),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

            // Levels Grid
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF219EBC),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 1.1,
                                  ),
                              itemCount: totalLevels,
                              itemBuilder: (context, index) {
                                final isUnlocked = _unlockedLevels.contains(
                                  index,
                                );
                                final stars = _levelStars[index] ?? 0;
                                final levelTitle =
                                    AyatContinuationDataProvider.getLevelTitle(
                                      index,
                                    );

                                return LevelCard(
                                  level: index + 1,
                                  title: levelTitle,
                                  stars: stars,
                                  isUnlocked: isUnlocked,
                                  onTap: isUnlocked
                                      ? () => _startLevel(context, index)
                                      : null,
                                );
                              },
                            ),
                          ),

                          // Reset button for testing
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: TextButton.icon(
                              onPressed: () async {
                                await SambungAyatProgressService.resetAllProgress();
                                _loadProgress();
                              },
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.grey,
                              ),
                              label: const Text(
                                'Reset Progres (Pengujian)',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _startLevel(BuildContext context, int level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SambungAyatGameScreen(level: level),
      ),
    ).then((_) {
      // Refresh the levels when coming back from the game
      _loadProgress();
    });
  }
}

class LevelCard extends StatelessWidget {
  final int level;
  final String title;
  final int stars;
  final bool isUnlocked;
  final VoidCallback? onTap;

  const LevelCard({
    super.key,
    required this.level,
    required this.title,
    required this.stars,
    required this.isUnlocked,
    this.onTap,
  });

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
                  // Level title
                  Text(
                    title,
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
}
