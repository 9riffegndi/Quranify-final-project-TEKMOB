import 'package:flutter/material.dart';
import 'package:quranify/features/home/youtube_ngaji_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight * 0.3,
                decoration: const BoxDecoration(color: Color(0xFF219EBC)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      '16 Rabiul Awal 1445 H',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      'Bantul, Yogyakarta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: screenWidth,
                      height: screenHeight * 0.15,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("https://placehold.co/428x208"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text('Subuh'),
                  Text('Dzuhur'),
                  Text('Asar'),
                  Text('Magrib'),
                  Text('Isya'),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text('04:05'),
                  Text('11:28'),
                  Text('14:36'),
                  Text('17:33'),
                  Text('18:43'),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: screenWidth,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0x99E1EFFF),
                  border: Border.all(color: const Color(0xFF219EBC)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Text(
                    'Ngaji Yuk!!',
                    style: TextStyle(
                      color: Color(0xFF0990AF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hadis favorit',
                  style: TextStyle(
                    color: Color(0xFF0990AF),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: screenWidth,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xB2E4F2E5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '"Ketika Nabi \uFDFA masuk ke dalam Ka\'bah..."',
                  style: TextStyle(
                    color: Color(0xFF023047),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ngaji Online',
                  style: TextStyle(
                    color: Color(0xFF0990AF),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const YoutubeNgajiCard(
                videoUrl: 'https://youtu.be/4rbO39alQRU?si=PZ4OEGwuqXI1B1kn',
                title: 'Ngaji Online - Kajian Islam',
                description: 'Kajian Islam terbaru yang bermanfaat',
              ),
              const SizedBox(height: 16),
              const YoutubeNgajiCard(
                videoUrl: 'https://youtu.be/dQw4w9WgXcQ',
                title: 'Tafsir Al-Quran',
                description: 'Memahami makna Al-Quran dengan lebih dalam',
              ),
              const SizedBox(height: 16),
              const YoutubeNgajiCard(
                videoUrl: 'https://youtu.be/ScMzIvxBSi4',
                title: 'Hadist Pilihan',
                description: 'Hadist-hadist pilihan yang mudah dipahami',
              ),
              const SizedBox(height: 16),
             Container(
  width: screenWidth,
  height: 100,
   decoration: BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: Colors.grey.shade300)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem('Home', true),
          _navItem('Al-Qur’an', false),
          _navItem('Hadith', false),
          _navItem('Propil', false),
        ],
      ),
    ),
)

            ],
          ),
        ),
      ),
    );
  }

  static Widget _navItem(String label, bool active) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: active ? const Color(0xFFBCE2EB) : Colors.transparent,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: active ? const Color(0xFF023047) : const Color(0x4C023047),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
