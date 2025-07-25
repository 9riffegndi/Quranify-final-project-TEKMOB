import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/routes.dart';
import '../../../data/services/quran/bookmark_service.dart';
import '../../../data/services/hadith/bookmark_service.dart';
import '../../../data/services/youtube_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../ai-feature/widgets/ai_feature_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  final BookmarkService _bookmarkService =
      BookmarkService(); // Quran bookmark service
  final HadithBookmarkService _hadithBookmarkService =
      HadithBookmarkService(); // Hadith bookmark service
  final YouTubeService _youtubeService = YouTubeService(); // YouTube service
  final TextEditingController _searchController =
      TextEditingController(); // Search text controller
  bool _isSearching = false; // Track if search is active
  List<Map<String, dynamic>> _surahSearchResults =
      []; // Store Surah search results
  List<Map<String, dynamic>> _hadithSearchResults =
      []; // Store Hadith search results
  bool _searchLoading = false; // Track loading state for search
  UserModel? _user;
  bool _isGuest = false;
  bool _isLoading = true;
  String _currentTime = '';
  late Timer _timer;
  int _currentIndex = 0; // For bottom navigation bar
  List<Map<String, dynamic>> _bookmarks = []; // Store Quran bookmarks
  List<Map<String, dynamic>> _hadithBookmarks = []; // Store Hadith bookmarks
  List<Map<String, dynamic>> _youtubeVideos = []; // Store YouTube videos
  bool _loadingBookmarks = true; // Track loading state for Quran bookmarks
  bool _loadingHadithBookmarks =
      true; // Track loading state for Hadith bookmarks
  bool _loadingYoutubeVideos = true; // Track loading state for YouTube videos

  // Prayer times - in real app would be fetched from API
  final Map<String, String> _prayerTimes = {
    'Subuh': '04:30',
    'Dzuhur': '11:45',
    'Ashar': '15:00',
    'Maghrib': '17:45',
    'Isya': '19:00',
  };

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Delay loading of resources to prevent too many WebGL contexts
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _loadBookmarks(); // Load Quran bookmarks
      }
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _loadHadithBookmarks(); // Load Hadith bookmarks
      }
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        _loadYoutubeVideos(); // Load YouTube videos
      }
    });

    _updateTime();
    // Update time every 5 seconds instead of every second to reduce WebGL contexts
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _updateTime());
  }

  // Load bookmarks from service
  Future<void> _loadBookmarks() async {
    setState(() {
      _loadingBookmarks = true;
    });
    try {
      final bookmarks = await _bookmarkService.getBookmarks();
      setState(() {
        _bookmarks = bookmarks;
        _loadingBookmarks = false;
      });
    } catch (e) {
      setState(() {
        _loadingBookmarks = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load bookmarks: ${e.toString()}')),
        );
      }
    }
  }

  // Load hadith bookmarks from service
  Future<void> _loadHadithBookmarks() async {
    setState(() {
      _loadingHadithBookmarks = true;
    });
    try {
      final hadithBookmarks = await _hadithBookmarkService.getBookmarks();
      setState(() {
        _hadithBookmarks = hadithBookmarks;
        _loadingHadithBookmarks = false;
      });
    } catch (e) {
      setState(() {
        _loadingHadithBookmarks = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load hadith bookmarks: ${e.toString()}'),
          ),
        );
      }
    }
  }

  // Load YouTube videos from service with caching
  Future<void> _loadYoutubeVideos({bool forceRefresh = false}) async {
    setState(() {
      _loadingYoutubeVideos = true;
    });

    try {
      // Clear cache if forcing refresh
      if (forceRefresh) {
        await _youtubeService.clearIslamicVideosCache();
      }

      final videos = await _youtubeService.getIslamicStudyVideos();

      setState(() {
        _youtubeVideos = videos;
        _loadingYoutubeVideos = false;
      });
    } catch (e) {
      print('Error loading YouTube videos: $e');
      setState(() {
        _loadingYoutubeVideos = false;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // Search for Surah and Hadith
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _surahSearchResults.clear();
        _hadithSearchResults.clear();
      });
      return;
    }

    setState(() {
      _searchLoading = true;
      _isSearching = true;
    });

    try {
      // Mock search results for Surah - in a real app this would come from an API or database
      final List<Map<String, dynamic>> surahResults = [];

      // Example Surahs for search results
      final List<Map<String, dynamic>> allSurahs = [
        {'number': 1, 'name': 'Al-Fatihah', 'englishName': 'The Opening'},
        {'number': 2, 'name': 'Al-Baqarah', 'englishName': 'The Cow'},
        {'number': 3, 'name': 'Ali \'Imran', 'englishName': 'Family of Imran'},
        {'number': 4, 'name': 'An-Nisa', 'englishName': 'The Women'},
        {'number': 5, 'name': 'Al-Ma\'idah', 'englishName': 'The Table Spread'},
        {'number': 36, 'name': 'Ya Sin', 'englishName': 'Ya Sin'},
        {'number': 55, 'name': 'Ar-Rahman', 'englishName': 'The Beneficent'},
        {'number': 56, 'name': 'Al-Waqi\'ah', 'englishName': 'The Inevitable'},
        {'number': 67, 'name': 'Al-Mulk', 'englishName': 'The Sovereignty'},
        {'number': 78, 'name': 'An-Naba', 'englishName': 'The Announcement'},
        {'number': 112, 'name': 'Al-Ikhlas', 'englishName': 'The Sincerity'},
        {'number': 113, 'name': 'Al-Falaq', 'englishName': 'The Daybreak'},
        {'number': 114, 'name': 'An-Nas', 'englishName': 'Mankind'},
      ];

      // Filter surahs based on search query
      for (var surah in allSurahs) {
        if (surah['name'].toString().toLowerCase().contains(
              query.toLowerCase(),
            ) ||
            surah['englishName'].toString().toLowerCase().contains(
              query.toLowerCase(),
            ) ||
            surah['number'].toString() == query) {
          surahResults.add(surah);
        }
      }

      // Mock search results for Hadith
      final List<Map<String, dynamic>> hadithResults = [];

      // Example Hadith collections for search
      final List<Map<String, dynamic>> allHadithBooks = [
        {'id': 'bukhari', 'name': 'Sahih Bukhari', 'available': true},
        {'id': 'muslim', 'name': 'Sahih Muslim', 'available': true},
        {'id': 'abudawud', 'name': 'Abu Dawud', 'available': true},
        {'id': 'tirmidhi', 'name': 'Jami at-Tirmidhi', 'available': true},
        {'id': 'nasai', 'name': 'Sunan an-Nasai', 'available': true},
        {'id': 'ibnmajah', 'name': 'Sunan Ibn Majah', 'available': true},
        {'id': 'malik', 'name': 'Muwatta Malik', 'available': true},
      ];

      // Filter hadith books based on search query
      for (var book in allHadithBooks) {
        if (book['name'].toString().toLowerCase().contains(
          query.toLowerCase(),
        )) {
          hadithResults.add(book);
        }
      }

      setState(() {
        _surahSearchResults = surahResults;
        _hadithSearchResults = hadithResults;
        _searchLoading = false;
      });
    } catch (e) {
      setState(() {
        _searchLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Search error: ${e.toString()}')),
        );
      }
    }
  }

  // Navigate to the selected Surah
  void _navigateToSurah(int surahNumber) {
    Navigator.pushNamed(
      context,
      AppRoutes.detailSurah,
      arguments: {'surahNumber': surahNumber},
    );
    // Clear search after navigation
    _clearSearch();
  }

  // Navigate to the selected Hadith book
  void _navigateToHadithBook(String bookId) {
    Navigator.pushNamed(
      context,
      AppRoutes.hadist,
      arguments: {'bookId': bookId},
    );
    // Clear search after navigation
    _clearSearch();
  }

  // Clear search results and reset search state
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _surahSearchResults.clear();
      _hadithSearchResults.clear();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('HH:mm:ss');
    setState(() {
      _currentTime = formatter.format(now);
    });
  }

  String _getHijriDate() {
    final today = HijriCalendar.now();
    return '${today.hDay} ${_getHijriMonthName(today.hMonth)} ${today.hYear} H';
  }

  String _getHijriMonthName(int month) {
    const months = [
      'Muharram',
      'Safar',
      'Rabiul Awal',
      'Rabiul Akhir',
      'Jumadil Awal',
      'Jumadil Akhir',
      'Rajab',
      'Syaban',
      'Ramadhan',
      'Syawal',
      'Dzulkaidah',
      'Dzulhijjah',
    ];
    return months[month - 1];
  }

  // Gregorian date method removed

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _authService.getCurrentUser();
      final isGuest = await _authService.isGuest();

      setState(() {
        _user = user;
        _isGuest = isGuest;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Logout method removed

  String _getProfileInitial() {
    if (_isGuest) return 'G';
    if (_user?.username != null && _user!.username.isNotEmpty) {
      return _user!.username.substring(0, 1).toUpperCase();
    }
    return 'U';
  }

  // Method removed as it's no longer used

  // Build a prayer time display with icon in a column layout
  Widget _buildCompactPrayerTime(String prayerName, String time) {
    // Select appropriate icon based on prayer name
    IconData getIconForPrayer(String prayer) {
      switch (prayer) {
        case 'Subuh':
          return Icons.wb_twilight;
        case 'Dzuhur':
          return Icons.wb_sunny;
        case 'Ashar':
          return Icons.brightness_5;
        case 'Maghrib':
          return Icons.brightness_4;
        case 'Isya':
          return Icons.nightlight_round;
        default:
          return Icons.access_time;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Prayer name at the top
          Text(
            prayerName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          // Icon in the middle
          Icon(getIconForPrayer(prayerName), color: Colors.white, size: 18),
          const SizedBox(height: 6),
          // Time at the bottom
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getNextPrayerTime() {
    // Simple version - just returns Dzuhur
    return 'Dzuhur: ${_prayerTimes['Dzuhur']}';
  }

  String _getNextPrayerTimeCalculated() {
    // A more accurate calculation of the next prayer time
    final now = DateFormat('HH:mm').format(DateTime.now());

    // Convert all prayer times and current time to comparable format (minutes since midnight)
    int currentMinutes = _convertTimeToMinutes(now);

    // Find the next prayer time
    String nextPrayer = 'Subuh';
    int nextPrayerMinutes = 24 * 60; // Default to maximum (end of day)

    _prayerTimes.forEach((name, time) {
      int prayerMinutes = _convertTimeToMinutes(time);
      if (prayerMinutes > currentMinutes && prayerMinutes < nextPrayerMinutes) {
        nextPrayer = name;
        nextPrayerMinutes = prayerMinutes;
      }
    });

    // If no prayer time is found after current time, the next is Subuh tomorrow
    if (nextPrayer == 'Subuh' && nextPrayerMinutes == 24 * 60) {
      nextPrayer = 'Subuh';
      nextPrayerMinutes = _convertTimeToMinutes(_prayerTimes['Subuh']!);
    }

    // Calculate time remaining
    int minutesRemaining = nextPrayerMinutes - currentMinutes;
    if (minutesRemaining < 0) {
      minutesRemaining += 24 * 60; // Add 24 hours if it's for tomorrow
    }

    int hoursRemaining = minutesRemaining ~/ 60;
    int minsRemaining = minutesRemaining % 60;

    String timeRemainingStr = '';
    if (hoursRemaining > 0) {
      timeRemainingStr = '$hoursRemaining h $minsRemaining m';
    } else {
      timeRemainingStr = '$minsRemaining m';
    }

    // More concise format to prevent overflow
    return '$nextPrayer ${_prayerTimes[nextPrayer]} ($timeRemainingStr)';
  }

  // Method to handle navigation based on bottom nav selection
  void _onNavItemTapped(int index) {
    // If we're already on this tab, don't do anything
    if (_currentIndex == index) {
      return;
    }

    // Update the selected index
    setState(() {
      _currentIndex = index;
    });

    // Navigate based on the selected index
    switch (index) {
      case 0:
        // Home - just navigate once
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        // Al Quran screen
        Navigator.pushNamed(context, AppRoutes.quran);
        break;
      case 2:
        // Fun Learn screen
        Navigator.pushNamed(context, AppRoutes.funLearn);
        break;
      case 3:
        // Hadist screen
        Navigator.pushNamed(context, AppRoutes.hadist);
        break;
      case 4:
        // Profile screen
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
    }
  }

  int _convertTimeToMinutes(String time) {
    List<String> parts = time.split(':');
    if (parts.length == 2) {
      int hours = int.tryParse(parts[0]) ?? 0;
      int minutes = int.tryParse(parts[1]) ?? 0;
      return hours * 60 + minutes;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight:
                        310.0, // Increased height for status bar and better mobile display
                    floating: false,
                    pinned: true,
                    snap: false,
                    stretch: true, // Enable stretch effect on scroll
                    elevation: innerBoxIsScrolled
                        ? 4.0
                        : 0.0, // Add elevation when scrolled
                    backgroundColor: innerBoxIsScrolled
                        ? const Color(
                            0xFF1A8CAB,
                          ) // Slightly darker when scrolled
                        : const Color(0xFF219EBC),
                    automaticallyImplyLeading: false, // Remove back button
                    // Keep title visible at all times
                    title: SafeArea(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.only(
                          top: innerBoxIsScrolled ? 4.0 : 6.0,
                          bottom: innerBoxIsScrolled ? 4.0 : 6.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Profile and Hijri date
                            Row(
                              children: [
                                // User profile initial with tap to navigate to profile
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.profile,
                                    );
                                  },
                                  child: Hero(
                                    tag: 'profileAvatar',
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      width: innerBoxIsScrolled ? 36 : 42,
                                      height: innerBoxIsScrolled ? 36 : 42,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Text(
                                          _getProfileInitial(),
                                          style: TextStyle(
                                            fontSize: innerBoxIsScrolled
                                                ? 16
                                                : 18,
                                            color: const Color(0xFF219EBC),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Hijri date and location in column layout
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Hijri date
                                    Text(
                                      _getHijriDate(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: innerBoxIsScrolled ? 12 : 13,
                                      ),
                                    ),
                                    // Location under Hijri date
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                          size: innerBoxIsScrolled ? 10 : 12,
                                        ),
                                        SizedBox(width: 2),
                                        Text(
                                          'Bantul, Yogyakarta',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: innerBoxIsScrolled
                                                ? 10
                                                : 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Notification icon
                            Container(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.notifications,
                                color: Colors.white,
                                size: innerBoxIsScrolled ? 20 : 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      // Hide the default title
                      titlePadding: EdgeInsets.zero,
                      title: null,
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Semi-transparent overlay (first in the stack)
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFF219EBC).withOpacity(0.7),
                                  const Color(0xFF219EBC).withOpacity(0.85),
                                ],
                              ),
                            ),
                          ),
                          // Background image (below the overlay in z-order)
                          Image.asset(
                            'assets/images/mosquee.png',
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: double.infinity,
                            color: Colors.white.withOpacity(0.1),
                            colorBlendMode: BlendMode.srcIn,
                          ),
                          // Header content
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                16.0,
                                60.0, // Increased top padding to account for pinned header
                                16.0,
                                16.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Empty space where the pinned header elements would be
                                  SizedBox(height: 50),

                                  // Center section with time and next prayer
                                  Expanded(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Current time in large display
                                          Text(
                                            _currentTime,
                                            style: const TextStyle(
                                              fontSize:
                                                  42, // Reduced from 48 to prevent overflow
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ), // Reduced spacing
                                          // Next prayer time
                                          const SizedBox(height: 4),
                                          FutureBuilder<String>(
                                            future: Future.value(
                                              _getNextPrayerTimeCalculated(),
                                            ),
                                            builder: (context, snapshot) {
                                              // Get the prayer time text
                                              String prayerTimeText =
                                                  snapshot.data ??
                                                  _getNextPrayerTime();

                                              return Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                        Icons.access_time,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      // Use Flexible to prevent text overflow
                                                      Flexible(
                                                        child: Text(
                                                          prayerTimeText,
                                                          style: const TextStyle(
                                                            fontSize:
                                                                16, // Reduced from 18 to prevent overflow
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  // Prayer Times section below next prayer - column layout with icons
                                                  const SizedBox(height: 16),
                                                  Container(
                                                    height:
                                                        65, // Further increased height for better visibility
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        _buildCompactPrayerTime(
                                                          'Subuh',
                                                          _prayerTimes['Subuh']!,
                                                        ),
                                                        _buildCompactPrayerTime(
                                                          'Dzuhur',
                                                          _prayerTimes['Dzuhur']!,
                                                        ),
                                                        _buildCompactPrayerTime(
                                                          'Ashar',
                                                          _prayerTimes['Ashar']!,
                                                        ),
                                                        _buildCompactPrayerTime(
                                                          'Maghrib',
                                                          _prayerTimes['Maghrib']!,
                                                        ),
                                                        _buildCompactPrayerTime(
                                                          'Isya',
                                                          _prayerTimes['Isya']!,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Gregorian date removed
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // No actions here anymore (logout button removed)
                  ),
                ];
              },

              body: Stack(
                fit: StackFit.passthrough,
                children: [
                  // Background color for the entire body
                  Container(color: Color(0xFF39A9C6)),
                  // Main white container with rounded top corners
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 25.0,
                    ), // Space for search bar
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                            30.0,
                          ), // Proper rounded top corners
                        ),
                      ),
                      // Let the content determine the height
                      child: SingleChildScrollView(
                        // Increased bottom padding to ensure content isn't covered by bottom nav bar
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min, // Use min size to fit content
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Main content area
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // AI Feature Button - Tambahkan di bagian atas
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 10,
                                      top: 5,
                                    ),
                                    child: AIFeatureButton(),
                                  ),

                                  // Bookmarks Horizontal List
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(
                                      bottom: 16,
                                      top: 18,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFF219EBC),
                                                    Color(0xFF0097A7),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(
                                                      0xFF219EBC,
                                                    ).withOpacity(0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.menu_book,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    'Surat Ditandai',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          height:
                                              230, // Increased from 80 to accommodate the YouTube card style
                                          child: _loadingBookmarks
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Color.fromARGB(
                                                          255,
                                                          0,
                                                          0,
                                                          0,
                                                        ),
                                                      ),
                                                )
                                              : _bookmarks.isEmpty
                                              ? Center(
                                                  child: Container(
                                                    width: double.infinity,
                                                    margin:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFF219EBC,
                                                      ).withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                0.05,
                                                              ),
                                                          blurRadius: 5,
                                                          offset: const Offset(
                                                            0,
                                                            2,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        // Image section - like YouTube thumbnail
                                                        Container(
                                                          height: 120,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius.vertical(
                                                                  top:
                                                                      Radius.circular(
                                                                        12,
                                                                      ),
                                                                ),
                                                            color: const Color(
                                                              0xFF219EBC,
                                                            ).withOpacity(0.15),
                                                          ),
                                                          child: Center(
                                                            child: Stack(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .menu_book_rounded,
                                                                  size: 50,
                                                                  color:
                                                                      const Color(
                                                                        0xFF219EBC,
                                                                      ).withOpacity(
                                                                        0.7,
                                                                      ),
                                                                ),
                                                                Container(
                                                                  height: 60,
                                                                  width: 60,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border: Border.all(
                                                                      color: const Color(
                                                                        0xFF219EBC,
                                                                      ).withOpacity(0.3),
                                                                      width: 2,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        // Info section - like YouTube video details
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                12,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 40,
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                  color: const Color(
                                                                    0xFF219EBC,
                                                                  ),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: const Icon(
                                                                  Icons
                                                                      .bookmark_add,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 12,
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Text(
                                                                      'Belum Ada Surat Ditandai',
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Color(
                                                                          0xFF333333,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    Text(
                                                                      'Tandai ayat favoritmu untuk akses cepat',
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .grey[700],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: _bookmarks.length,
                                                  itemBuilder: (context, index) {
                                                    final bookmark =
                                                        _bookmarks[index];
                                                    return BookmarkItem(
                                                      surahName:
                                                          bookmark['surahName'],
                                                      surahNumber:
                                                          bookmark['surahNumber'],
                                                      ayatNumber:
                                                          bookmark['ayatNumber'],
                                                      // Include content if available
                                                      ayatContent:
                                                          bookmark['content'] ??
                                                          "إِنَّمَا الْمُؤْمِنُونَ إِخْوَةٌ فَأَصْلِحُوا بَيْنَ أَخَوَيْكُمْ وَاتَّقُوا اللَّهَ لَعَلَّكُمْ تُرْحَمُونَ",
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          AppRoutes.detailSurah,
                                                          arguments: {
                                                            'surahNumber':
                                                                bookmark['surahNumber'],
                                                            'ayatNumber':
                                                                bookmark['ayatNumber'],
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Hadith Bookmarks Horizontal List
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFF219EBC),
                                                    Color(0xFF0097A7),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(
                                                      0xFF219EBC,
                                                    ).withOpacity(0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.history_edu,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    'Hadist Ditandai',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          height:
                                              230, // Increased from 80 to accommodate the YouTube card style
                                          child: _loadingHadithBookmarks
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Color(
                                                          0xFF219EBC,
                                                        ),
                                                      ),
                                                )
                                              : _hadithBookmarks.isEmpty
                                              ? Center(
                                                  child: Container(
                                                    width: double.infinity,
                                                    margin:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFF219EBC,
                                                      ).withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                0.05,
                                                              ),
                                                          blurRadius: 5,
                                                          offset: const Offset(
                                                            0,
                                                            2,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        // Image section - like YouTube thumbnail
                                                        Container(
                                                          height: 120,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius.vertical(
                                                                  top:
                                                                      Radius.circular(
                                                                        12,
                                                                      ),
                                                                ),
                                                            color: const Color(
                                                              0xFF219EBC,
                                                            ).withOpacity(0.15),
                                                          ),
                                                          child: Center(
                                                            child: Stack(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .history_edu_rounded,
                                                                  size: 50,
                                                                  color:
                                                                      const Color(
                                                                        0xFF219EBC,
                                                                      ).withOpacity(
                                                                        0.7,
                                                                      ),
                                                                ),
                                                                Container(
                                                                  height: 60,
                                                                  width: 60,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border: Border.all(
                                                                      color: const Color(
                                                                        0xFF219EBC,
                                                                      ).withOpacity(0.3),
                                                                      width: 2,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        // Info section - like YouTube video details
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                12,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 40,
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                  color: const Color(
                                                                    0xFF219EBC,
                                                                  ),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: const Icon(
                                                                  Icons
                                                                      .bookmark_add,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 12,
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Text(
                                                                      'Belum Ada Hadist Ditandai',
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Color(
                                                                          0xFF333333,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    Text(
                                                                      'Tandai hadist favoritmu untuk akses cepat',
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .grey[700],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      _hadithBookmarks.length,
                                                  itemBuilder: (context, index) {
                                                    final bookmark =
                                                        _hadithBookmarks[index];
                                                    return HadithBookmarkItem(
                                                      bookName:
                                                          bookmark['bookName'],
                                                      bookId:
                                                          bookmark['bookId'],
                                                      hadithNumber:
                                                          bookmark['hadithNumber'],
                                                      hadithText:
                                                          bookmark['hadithText'],
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          AppRoutes
                                                              .detailHadith,
                                                          arguments: {
                                                            'bookId':
                                                                bookmark['bookId'],
                                                            'hadithNumber':
                                                                bookmark['hadithNumber'],
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // YouTube Kajian Islam Section
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Header with See All button
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFF219EBC),
                                                    Color(0xFF39A9C6),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(
                                                      0xFF219EBC,
                                                    ).withOpacity(0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.video_library,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    'Kajian Islam',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Refresh button
                                            IconButton(
                                              icon: const Icon(
                                                Icons.refresh,
                                                color: Color(0xFF219EBC),
                                                size: 20,
                                              ),
                                              onPressed: () =>
                                                  _loadYoutubeVideos(
                                                    forceRefresh: true,
                                                  ),
                                              tooltip:
                                                  'Refresh dan hapus cache',
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Navigate to YouTube videos list page
                                                Navigator.pushNamed(
                                                  context,
                                                  AppRoutes.youtubeVideos,
                                                );
                                              },
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Lihat Semua',
                                                    style: TextStyle(
                                                      color: Color(0xFF219EBC),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 4),
                                                  Icon(
                                                    Icons.arrow_forward,
                                                    size: 16,
                                                    color: Color(0xFF219EBC),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        // YouTube videos horizontal list
                                        SizedBox(
                                          height:
                                              208, // Adjusted height for better fit
                                          child: _loadingYoutubeVideos
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Color(
                                                          0xFF219EBC,
                                                        ),
                                                      ),
                                                )
                                              : NotificationListener<
                                                  ScrollNotification
                                                >(
                                                  onNotification:
                                                      (
                                                        ScrollNotification
                                                        scrollInfo,
                                                      ) {
                                                        // You can add scroll optimization logic here if needed
                                                        return false;
                                                      },
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        _youtubeVideos.length,
                                                    cacheExtent:
                                                        300, // Cache items ahead of rendering
                                                    itemBuilder: (context, index) {
                                                      final video =
                                                          _youtubeVideos[index];
                                                      return YouTubeVideoItem(
                                                        thumbnailUrl:
                                                            video['thumbnailUrl'] ??
                                                            '',
                                                        title:
                                                            video['title'] ??
                                                            'Video',
                                                        channelName:
                                                            video['channelName'] ??
                                                            'Channel',
                                                        duration:
                                                            video['duration'] ??
                                                            '0:00',
                                                        videoId:
                                                            video['id'] ?? '',
                                                      );
                                                    },
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Small space at the bottom for better visual appearance
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Floating search bar and search results
                  Stack(
                    children: [
                      // Search bar
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 200),
                        top:
                            5, // Added top margin for better spacing with content
                        left: 0,
                        right: 0,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          height:
                              48, // Slightly increased height for better touch target
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              25.0,
                            ), // Fully rounded
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              _performSearch(value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Search Surah, Ayat, or Topic...',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Color(0xFF219EBC),
                              ),
                              suffixIcon: _isSearching
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Color(0xFF219EBC),
                                      ),
                                      onPressed: _clearSearch,
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                              ),
                              hintStyle: const TextStyle(
                                color: Color(0xFF219EBC),
                                fontSize: 14,
                              ),
                            ),
                            cursorColor: const Color(0xFF219EBC),
                            style: const TextStyle(color: Color(0xFF219EBC)),
                          ),
                        ),
                      ),

                      // Search Results
                      if (_isSearching)
                        Positioned(
                          top: 55, // Position below search bar
                          left: 16,
                          right: 16,
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: _searchLoading
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF219EBC),
                                      ),
                                    ),
                                  )
                                : SingleChildScrollView(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Surah results
                                        if (_surahSearchResults.isNotEmpty) ...[
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 8.0,
                                            ),
                                            child: Text(
                                              'Surahs',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color(0xFF219EBC),
                                              ),
                                            ),
                                          ),
                                          ...List.generate(
                                            _surahSearchResults.length > 5
                                                ? 5
                                                : _surahSearchResults
                                                      .length, // Limit to 5 results
                                            (index) {
                                              final surah =
                                                  _surahSearchResults[index];
                                              return ListTile(
                                                leading: Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFF219EBC,
                                                    ).withOpacity(0.1),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '${surah['number']}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color(
                                                          0xFF219EBC,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  surah['name'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  surah['englishName'],
                                                ),
                                                contentPadding: EdgeInsets.zero,
                                                onTap: () => _navigateToSurah(
                                                  surah['number'],
                                                ),
                                              );
                                            },
                                          ),
                                          if (_surahSearchResults.length > 5)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
                                              ),
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    AppRoutes.quran,
                                                  );
                                                  _clearSearch();
                                                },
                                                child: const Text(
                                                  'View All Surahs',
                                                  style: TextStyle(
                                                    color: Color(0xFF219EBC),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          const Divider(),
                                        ],

                                        // Hadith results
                                        if (_hadithSearchResults
                                            .isNotEmpty) ...[
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 8.0,
                                            ),
                                            child: Text(
                                              'Hadith Collections',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color(0xFF219EBC),
                                              ),
                                            ),
                                          ),
                                          ...List.generate(
                                            _hadithSearchResults.length > 5
                                                ? 5
                                                : _hadithSearchResults
                                                      .length, // Limit to 5 results
                                            (index) {
                                              final hadithBook =
                                                  _hadithSearchResults[index];
                                              return ListTile(
                                                leading: const Icon(
                                                  Icons.history_edu,
                                                  color: Color(0xFF219EBC),
                                                ),
                                                title: Text(
                                                  hadithBook['name'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                contentPadding: EdgeInsets.zero,
                                                onTap: () =>
                                                    _navigateToHadithBook(
                                                      hadithBook['id'],
                                                    ),
                                              );
                                            },
                                          ),
                                          if (_hadithSearchResults.length > 5)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
                                              ),
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    AppRoutes.hadist,
                                                  );
                                                  _clearSearch();
                                                },
                                                child: const Text(
                                                  'View All Hadith Collections',
                                                  style: TextStyle(
                                                    color: Color(0xFF219EBC),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],

                                        // No results message
                                        if (_surahSearchResults.isEmpty &&
                                            _hadithSearchResults.isEmpty)
                                          const Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Center(
                                              child: Text(
                                                'No results found',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        // Use SafeArea to account for system navigation bar
        child: SafeArea(
          // Add bottom padding specifically for system navigation bar
          bottom: true,
          child: Padding(
            // Extra padding at the bottom to ensure space from system navigation
            padding: const EdgeInsets.only(bottom: 0),
            child: BottomNavigationBar(
              elevation: 8,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              currentIndex: _currentIndex,
              selectedItemColor: const Color(0xFF219EBC),
              unselectedItemColor: Colors.grey,
              // Increase font size and padding for better visibility
              selectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              // Add more vertical padding for better touch targets
              iconSize: 26,
              onTap: _onNavItemTapped,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.menu_book),
                  label: 'Al Quran',
                ),
                // Center the Fun Learn item with a circular background
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF219EBC),
                      shape: BoxShape.circle, // radius full
                    ),
                    child: Icon(
                      Icons.school,
                      size: 24,
                      color: Colors.white, // opsional: biar kontras
                    ),
                  ),
                  label: 'Fun Learn',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.history_edu),
                  label: 'Hadist',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// BookmarkItem widget for displaying a bookmark in the horizontal list with content preview
class BookmarkItem extends StatelessWidget {
  final String surahName;
  final int surahNumber;
  final int ayatNumber;
  final VoidCallback onTap;
  final String? ayatContent; // Optional content to display

  const BookmarkItem({
    Key? key,
    required this.surahName,
    required this.surahNumber,
    required this.ayatNumber,
    required this.onTap,
    this.ayatContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200, // Wider for better content display
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF219EBC).withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF219EBC), const Color(0xFF1A8CAB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  // Surah number indicator
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        '$surahNumber',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Surah name and ayat number
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          surahName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Ayat $ayatNumber',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content preview section
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Preview text of the ayat
                    Text(
                      ayatContent ?? 'Tap to read ayat...',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                    const Spacer(),
                    // "Read more" button at bottom
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Baca Selengkapnya',
                          style: TextStyle(
                            fontSize: 11,
                            color: const Color(0xFF219EBC),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: Color(0xFF219EBC),
                        ),
                      ],
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
}

// HadithBookmarkItem widget for displaying a hadith bookmark in the horizontal list
class HadithBookmarkItem extends StatelessWidget {
  final String bookName;
  final String bookId;
  final int hadithNumber;
  final String hadithText;
  final VoidCallback onTap;

  const HadithBookmarkItem({
    Key? key,
    required this.bookName,
    required this.bookId,
    required this.hadithNumber,
    required this.hadithText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200, // Wider for better content display
        height: 180, // Fixed height for consistent layout
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF219EBC).withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with gradient background
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0097A7), // Different color scheme for hadith
                    Color(0xFF219EBC),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  // Hadith collection icon
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.history_edu,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Book name and hadith number
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Hadith No. $hadithNumber',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content preview section
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Preview text of the hadith
                    Expanded(
                      child: Text(
                        hadithText,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[800],
                          height: 1.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                    // "Read more" button at bottom
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Baca Selengkapnya',
                          style: TextStyle(
                            fontSize: 11,
                            color: const Color(0xFF0097A7),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: Color(0xFF0097A7),
                        ),
                      ],
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
}

// YouTube Video Item for displaying videos in the horizontal list
class YouTubeVideoItem extends StatelessWidget {
  final String thumbnailUrl;
  final String title;
  final String channelName;
  final String duration;
  final String videoId;

  const YouTubeVideoItem({
    Key? key,
    required this.thumbnailUrl,
    required this.title,
    required this.channelName,
    required this.duration,
    required this.videoId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to YouTube player screen
        Navigator.of(context).pushNamed(
          AppRoutes.youtubePlayer,
          arguments: {'videoId': videoId, 'title': title},
        );
      },
      child: Container(
        width: 280,
        height: 200, // Fixed height to prevent overflow
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video thumbnail with duration
            Stack(
              children: [
                // Thumbnail image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/logo.png',
                    image: thumbnailUrl,
                    height: 130, // Reduced height to prevent overflow
                    width: double.infinity,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 300),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 130,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Play button overlay
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),

                // Duration badge
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      duration,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Video title and channel info
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ), // Reduced vertical padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4), // Reduced spacing
                  Text(
                    channelName,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
