import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/routes.dart';
import '../../../data/services/quran/bookmark_service.dart';
import '../../../data/models/hadith/hadith_book_model.dart';
import '../../../data/services/hadith/hadith_service.dart';
import '../../../data/services/hadith/bookmark_service.dart';
import '../../../data/services/youtube_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
    _loadBookmarks(); // Load Quran bookmarks
    _loadHadithBookmarks(); // Load Hadith bookmarks
    _loadYoutubeVideos(); // Load YouTube videos
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
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

  // Load YouTube videos from service
  Future<void> _loadYoutubeVideos() async {
    setState(() {
      _loadingYoutubeVideos = true;
    });

    try {
      final YouTubeService youtubeService = YouTubeService();
      final videos = await youtubeService.getIslamicStudyVideos();

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
    super.dispose();
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
        // Hadist screen
        Navigator.pushNamed(context, AppRoutes.hadist);
        break;
      case 3:
        // Profile screen
        ScaffoldMessenger.of(
          context,
        ).clearSnackBars(); // Clear any existing snackbars
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile screen needs to be created'),
            duration: Duration(seconds: 1),
          ),
        );
        // When implemented: Navigator.pushNamed(context, AppRoutes.profile);
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
                        300.0, // Increased height for the new layout
                    floating: false,
                    pinned: true,
                    backgroundColor: const Color(0xFF219EBC),
                    automaticallyImplyLeading: false, // Remove back button
                    flexibleSpace: FlexibleSpaceBar(
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
                            './assets/images/mosquee.png',
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: double.infinity,
                            color: Colors.white.withOpacity(0.1),
                            colorBlendMode: BlendMode.srcIn,
                          ),
                          // Header content
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top header section
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Left side: User profile with Hijri date & location to the right
                                    Row(
                                      children: [
                                        // User profile initial
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundColor: Colors.white,
                                          child: Text(
                                            _getProfileInitial(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Color(0xFF219EBC),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Hijri date and location to the right of profile
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Hijri date
                                            Text(
                                              _getHijriDate(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            // Location directly below Hijri date
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                                const SizedBox(width: 4),
                                                const Text(
                                                  'Bantul, Yogyakarta',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    // Right side: Notification
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.notifications,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),

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
                                                      MainAxisAlignment.center,
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
                      // Use constraints to fit content rather than infinite height
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context).size.height -
                            190, // Account for app bar and bottom nav
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                            30.0,
                          ), // Proper rounded top corners
                        ),
                      ),
                      child: SingleChildScrollView(
                        // Use padding only as needed for bottom nav
                        padding: const EdgeInsets.only(bottom: 80),
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
                                              : ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      _youtubeVideos.length,
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

                  // Floating search bar
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      height: 45,
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
                        decoration: InputDecoration(
                          hintText: 'Search Surah, Ayat, or Topic...',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF219EBC),
                          ),
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
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF219EBC),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        onTap: _onNavItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Al Quran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_edu),
            label: 'Hadist',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// BookmarkItem widget for displaying a bookmark in the horizontal list
class BookmarkItem extends StatelessWidget {
  final String surahName;
  final int surahNumber;
  final int ayatNumber;
  final VoidCallback onTap;

  const BookmarkItem({
    Key? key,
    required this.surahName,
    required this.surahNumber,
    required this.ayatNumber,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF219EBC).withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF219EBC).withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Color(0xFF219EBC),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$surahNumber',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    surahName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color(0xFF219EBC),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Ayat $ayatNumber',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
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
        width: 130,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF219EBC).withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF219EBC).withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Color(0xFF219EBC),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.history_edu,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    bookName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color(0xFF219EBC),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'No. $hadithNumber',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
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
                  child: Image.network(
                    thumbnailUrl,
                    height: 130, // Reduced height to prevent overflow
                    width: double.infinity,
                    fit: BoxFit.cover,
                    // Placeholder and error handling
                    errorBuilder: (context, error, stackTrace) {
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
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 130,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF219EBC),
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
