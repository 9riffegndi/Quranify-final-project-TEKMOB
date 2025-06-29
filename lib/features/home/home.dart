import 'package:flutter/material.dart';
import 'package:quranify/app_routes.dart'; // pastikan ini sesuai path AppRoutes kamu

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF219EBC),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '16 Rabiul Awal 1445 H',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Bantul, Yogyakarta',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '14.30',
                    style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Maghrib 3 jam 3 menit lagi',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      SholatTile(jam: '04.05', label: 'Subuh', icon: Icons.nightlight_round),
                      SholatTile(jam: '11.28', label: 'Dzuhur', icon: Icons.wb_sunny),
                      SholatTile(jam: '14.38', label: 'Ashar', icon: Icons.wb_sunny_outlined),
                      SholatTile(jam: '17.33', label: 'Maghrib', icon: Icons.brightness_3),
                      SholatTile(jam: '18.43', label: 'Isya', icon: Icons.nights_stay),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.quran);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF219EBC),
                  side: const BorderSide(color: Color(0xFF219EBC)),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Ngaji Yuk!!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Hadis favorit', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Lihat semua', style: TextStyle(color: Color(0xFF219EBC))),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFDFF5F3),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(12),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '“Ketika Nabi ﷺ masuk ke dalam Ka\'bah, beliau berdoa di seluruh sisinya dan tidak melakukan salat hingga beliau keluar darinya...”',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '389/893 | HR Bukhari',
                        style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Ngaji Online', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Lihat semua', style: TextStyle(color: Color(0xFF219EBC))),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/ngaji.png',
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
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
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(jam, style: const TextStyle(color: Colors.white)),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
