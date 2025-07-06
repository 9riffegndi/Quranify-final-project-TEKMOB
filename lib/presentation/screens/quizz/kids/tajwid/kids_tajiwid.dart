import 'package:flutter/material.dart';
import '../../../../../data/services/provider/tajwid_data_provider.dart';
import '../../../../../services/tajwid_progress_service.dart';
import 'tajwid_game_screen.dart';

class KidsTajwidScreen extends StatefulWidget {
  const KidsTajwidScreen({super.key});

  @override
  State<KidsTajwidScreen> createState() => _KidsTajwidScreenState();
}

class _KidsTajwidScreenState extends State<KidsTajwidScreen>
    with SingleTickerProviderStateMixin {
  // Flag for loading state
  bool _isLoading = true;

  // Tab controller for switching between Learn and Play modes
  late TabController _tabController;

  // Track unlocked levels and stars
  List<int> _unlockedLevels = [0]; // Default to first level unlocked
  Map<int, int> _levelStars = {}; // Map of level -> stars
  int _totalStars = 0;
  int _totalLevels = 10; // We have 10 levels defined in TajwidDataProvider

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLevelProgress();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLevelProgress() async {
    // Load unlocked levels and stars data from SharedPreferences
    try {
      final unlockedLevels = await TajwidProgressService.getUnlockedLevels(
        _totalLevels,
      );
      final Map<int, int> levelStars = {};
      int totalStars = 0;

      // Get stars for each level
      for (int i = 0; i < _totalLevels; i++) {
        final stars = await TajwidProgressService.getLevelStars(i);
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
    // Get the rules for the selected level
    final levelRules = TajwidDataProvider.getRulesForLevel(level);

    // Navigate to the game screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TajwidGameScreen(level: level, levelRules: levelRules),
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
                    'Tajwid',
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

            // Tab bar for switching between Learn and Play
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF219EBC),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF219EBC),
                tabs: const [
                  Tab(icon: Icon(Icons.menu_book), text: "PELAJARI"),
                  Tab(icon: Icon(Icons.games), text: "BERMAIN"),
                ],
              ),
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // First tab: Learn about tajwid rules
                  _buildLearnTab(),

                  // Second tab: Play tajwid games
                  _isLoading ? _buildLoadingView() : _buildLevelSelectionView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFF219EBC)),
    );
  }

  Widget _buildLearnTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Kids mode image
          Image.asset(
            '../../../../../assets/images/quiz/hijaiyah.png',
            height: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),

          // Tajwid content
          Expanded(
            child: ListView(
              children: [
                // Idgham Card
                _buildCategoryCard(
                  title: 'IDGHAM',
                  description: 'Hukum nun mati/tanwin bertemu huruf idgham',
                  color: Colors.purple.shade200,
                  icon: Icons.merge_type,
                  onTap: () {
                    _showTajwidRuleDialog(
                      context,
                      title: 'Idgham',
                      content:
                          'Idgham adalah menggabungkan nun sukun/tanwin '
                          'dengan huruf berikutnya. Idgham terbagi menjadi dua:\n\n'
                          '1. Idgham Bighunnah (dengan dengung): bertemu huruf ي ن م و\n'
                          '2. Idgham Bilaghunnah (tanpa dengung): bertemu huruf ل ر',
                      examples: [
                        'مَن يَقُولُ',
                        'مِن نِّعْمَةٍ',
                        'مِن لَّدُنْهُ',
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Ikhfa Card
                _buildCategoryCard(
                  title: 'IKHFA',
                  description: 'Hukum nun mati/tanwin bertemu huruf ikhfa',
                  color: Colors.teal.shade200,
                  icon: Icons.visibility_off,
                  onTap: () {
                    _showTajwidRuleDialog(
                      context,
                      title: 'Ikhfa',
                      content:
                          'Ikhfa adalah menyembunyikan nun sukun/tanwin dengan '
                          'sifat antara izhhar dan idgham. Huruf ikhfa ada 15:\n\n'
                          'ت ث ج د ذ ز س ش ص ض ط ظ ف ق ك',
                      examples: ['مِن قَبْلُ', 'كُنتُمْ', 'مِن ثَمَرَةٍ'],
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Iqlab Card
                _buildCategoryCard(
                  title: 'IQLAB',
                  description: 'Hukum nun mati/tanwin bertemu huruf ب',
                  color: Colors.orange.shade200,
                  icon: Icons.swap_horiz,
                  onTap: () {
                    _showTajwidRuleDialog(
                      context,
                      title: 'Iqlab',
                      content:
                          'Iqlab adalah mengubah nun sukun/tanwin menjadi '
                          'mim sukun ketika bertemu dengan huruf ba (ب).',
                      examples: ['مِنۢ بَعْدِ', 'سَمِيعٌ بَصِيرٌ'],
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Idzhar Card
                _buildCategoryCard(
                  title: 'IDZHAR',
                  description: 'Hukum nun mati/tanwin bertemu huruf idzhar',
                  color: Colors.blue.shade200,
                  icon: Icons.visibility,
                  onTap: () {
                    _showTajwidRuleDialog(
                      context,
                      title: 'Idzhar',
                      content:
                          'Idzhar adalah menampakkan nun sukun/tanwin '
                          'dengan jelas tanpa dengung. Huruf idzhar ada 6:\n\n'
                          'ء ه ع ح غ خ',
                      examples: ['مِنْ عِلْمٍ', 'مَنْ أَرَادَ', 'مِنْ خَوْفٍ'],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelSelectionView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Pilih Level',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF219EBC),
            ),
          ),
        ),

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

    // Generate a tajwid icon based on the level
    IconData tajwidIcon;
    if (level < 2) {
      tajwidIcon = Icons.merge_type; // Idgham levels
    } else if (level < 5) {
      tajwidIcon = Icons.visibility_off; // Ikhfa levels
    } else if (level < 6) {
      tajwidIcon = Icons.swap_horiz; // Iqlab levels
    } else if (level < 8) {
      tajwidIcon = Icons.visibility; // Idzhar levels
    } else {
      tajwidIcon = Icons.school; // Mixed levels
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

            // Tajwid icon
            Icon(
              tajwidIcon,
              color: isLocked ? Colors.grey.shade600 : Colors.white,
              size: 22,
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

  Widget _buildCategoryCard({
    required String title,
    required String description,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(width: 16),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            const Icon(Icons.chevron_right, color: Colors.white, size: 30),
          ],
        ),
      ),
    );
  }

  void _showTajwidRuleDialog(
    BuildContext context, {
    required String title,
    required String content,
    required List<String> examples,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF219EBC),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(content),
              const SizedBox(height: 16),
              const Text(
                'Contoh:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...examples.map(
                (example) => Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    example,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontFamily: 'Amiri', fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Tutup',
              style: TextStyle(color: Color(0xFF219EBC)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _tabController.animateTo(1); // Switch to Play tab
            },
            child: const Text(
              'Main Game',
              style: TextStyle(color: Color(0xFF219EBC)),
            ),
          ),
        ],
      ),
    );
  }
}
