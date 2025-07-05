import 'package:flutter/material.dart';
import 'package:quranify/app_routes.dart';
import 'package:quranify/services/youtube_service.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../youtube_ngaji_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  String _hijriDate = '16 Rabiul Awal 1445 H';
  String _location = 'Bantul, Yogyakarta';

  // State untuk YouTube videos
  List<Map<String, dynamic>> _youtubeVideos = [];
  bool _isLoadingVideos = false;
  String _errorMessage = '';

  // Waktu sholat (dalam format 24 jam)
  final Map<String, String> _prayerTimes = {
    'Subuh': '04:05',
    'Dzuhur': '11:28',
    'Ashar': '14:38',
    'Maghrib': '17:33',
    'Isya': '18:43',
  };

  @override
  void initState() {
    super.initState();
    // Update waktu setiap detik untuk jam realtime
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
    
    // Load video YouTube saat aplikasi dimulai
    _loadYouTubeVideos();
  }

  @override
  void dispose() {
    _timer.cancel(); // Bersihkan timer saat widget dihancurkan
    super.dispose();
  }

  /// Fungsi untuk memuat video YouTube dari API
  /// Akan menampilkan loading indicator saat proses berlangsung
  Future<void> _loadYouTubeVideos() async {
    setState(() {
      _isLoadingVideos = true;
      _errorMessage = '';
    });

    try {
      // Ambil video dengan konten Islami dari YouTube API
      final videos = await YouTubeService.getIslamicVideos(maxResults: 5);
      
      setState(() {
        _youtubeVideos = videos;
        _isLoadingVideos = false;
      });
      
      debugPrint('Loaded ${videos.length} YouTube videos');
    } catch (e) {
      setState(() {
        _isLoadingVideos = false;
        _errorMessage = 'Gagal memuat video: $e';
      });
      debugPrint('Error loading YouTube videos: $e');
    }
  }

  String _getFormattedTime() {
    return DateFormat('HH:mm').format(_currentTime);
  }

  String _getFormattedDate() {
    return DateFormat('EEEE, dd MMMM yyyy').format(_currentTime);
  }

  String _getNextPrayerInfo() {
    final now = _currentTime;
    final currentTime = DateFormat('HH:mm').format(now);
    
    for (String prayer in _prayerTimes.keys) {
      final prayerTime = _prayerTimes[prayer]!;
      if (currentTime.compareTo(prayerTime) < 0) {
        final prayerDateTime = DateFormat('HH:mm').parse(prayerTime);
        final nowDateTime = DateFormat('HH:mm').parse(currentTime);
        
        final difference = prayerDateTime.difference(nowDateTime);
        final hours = difference.inHours;
        final minutes = difference.inMinutes % 60;
        
        if (hours > 0) {
          return '$prayer $hours jam $minutes menit lagi';
        } else {
          return '$prayer $minutes menit lagi';
        }
      }
    }
    
    // Jika sudah lewat semua waktu sholat hari ini, hitung untuk subuh besok
    final subuhTomorrow = DateTime(now.year, now.month, now.day + 1, 4, 5);
    final difference = subuhTomorrow.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    
    return 'Subuh $hours jam $minutes menit lagi';
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF219EBC),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, AppRoutes.quran);
          } else if (index == 2) {
            Navigator.pushNamed(context, AppRoutes.hadith);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Al-Qur\'an'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Hadith'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan waktu realtime - Modern Design
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF219EBC),
                    Color(0xFF1B7A96),
                    Color(0xFF145B6B),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Profile Section
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 28,
                              backgroundImage: AssetImage('assets/images/profile.png'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Assalamu\'alaikum',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getFormattedDate(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  _hijriDate,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white70,
                                size: 16,
                              ),
                              Text(
                                _location,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Clock Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _getFormattedTime(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _getNextPrayerInfo(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Prayer Times
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SholatTile(
                              jam: _prayerTimes['Subuh']!,
                              label: 'Subuh',
                              icon: Icons.nightlight_round,
                            ),
                            SholatTile(
                              jam: _prayerTimes['Dzuhur']!,
                              label: 'Dzuhur',
                              icon: Icons.wb_sunny,
                            ),
                            SholatTile(
                              jam: _prayerTimes['Ashar']!,
                              label: 'Ashar',
                              icon: Icons.wb_sunny_outlined,
                            ),
                            SholatTile(
                              jam: _prayerTimes['Maghrib']!,
                              label: 'Maghrib',
                              icon: Icons.brightness_3,
                            ),
                            SholatTile(
                              jam: _prayerTimes['Isya']!,
                              label: 'Isya',
                              icon: Icons.nights_stay,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Action Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      'Ngaji Yuk!',
                      'Baca Al-Qur\'an',
                      Icons.menu_book,
                      const Color(0xFF219EBC),
                      () => Navigator.pushNamed(context, AppRoutes.quran),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      'Hadist',
                      'Pelajari Hadist',
                      Icons.library_books,
                      const Color(0xFF28A745),
                      () => Navigator.pushNamed(context, AppRoutes.hadith),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Hadist favorit
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hadis Favorit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.hadith),
                    child: const Text(
                      'Lihat semua',
                      style: TextStyle(
                        color: Color(0xFF219EBC),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.hadith);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE8F8F5),
                        Color(0xFFD1F2EB),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF219EBC),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.format_quote,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Hadist Pilihan',
                            style: TextStyle(
                              color: Color(0xFF2C3E50),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '"Ketika Nabi ﷺ masuk ke dalam Ka\'bah, beliau berdoa di seluruh sisinya dan tidak melakukan salat hingga beliau keluar darinya..."',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF34495E),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '389/893 | HR Bukhari',
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Ngaji Online Section dengan YouTube API
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ngaji Online',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  // Tombol refresh untuk memuat video baru
                  GestureDetector(
                    onTap: _loadYouTubeVideos,
                    child: Row(
                      children: [
                        const Text(
                          'Refresh',
                          style: TextStyle(
                            color: Color(0xFF219EBC),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _isLoadingVideos ? Icons.refresh : Icons.refresh_outlined,
                          color: const Color(0xFF219EBC),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Tampilkan video YouTube berdasarkan state
            if (_isLoadingVideos)
              // Loading indicator
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF219EBC)),
                  ),
                ),
              )
            else if (_errorMessage.isNotEmpty)
              // Error message dengan tombol retry
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _loadYouTubeVideos,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF219EBC),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (_youtubeVideos.isNotEmpty)
              // Tampilkan video YouTube dari API
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: _youtubeVideos.map((video) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: YoutubeNgajiCard(
                        videoUrl: video['videoUrl'] ?? '',
                        title: video['title'] ?? 'Ngaji Online',
                        description: video['description'] ?? 'Kajian Islam Terbaru',
                      ),
                    );
                  }).toList(),
                ),
              )
            else
              // Fallback jika tidak ada video (tampilkan video default)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.orange,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tidak ada video tersedia saat ini',
                        style: TextStyle(color: Colors.orange),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      // Video default sebagai fallback
                      const YoutubeNgajiCard(
                        videoUrl: 'https://youtu.be/4rbO39alQRU?si=PZ4OEGwuqXI1B1kn',
                        title: 'Ngaji Online - Kajian Islam',
                        description: 'Kajian Islam terbaru yang bermanfaat',
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class SholatTile extends StatelessWidget {
  final String jam;
  final String label;
  final IconData icon;

  const SholatTile({
    super.key,
    required this.jam,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          jam,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}