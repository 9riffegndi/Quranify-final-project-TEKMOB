import 'package:flutter/material.dart';
import '../../../../routes/routes.dart';

class BaseGeneralFLScreen extends StatelessWidget {
  const BaseGeneralFLScreen({super.key});

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
                    'Belajar Umum',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF219EBC),
                    ),
                  ),
                ],
              ),
            ),

            // Content area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // General mode image
                    Image.asset(
                      '../../../../assets/images/quiz/hallo_general.png',
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    // Fun Learn text below image
                    const Text(
                      'FUN LEARN',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF219EBC),
                      ),
                    ),
                    const Text(
                      'tempat asik belajar al quran',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        color: Color(0xFF50C6E4),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Categories in nested column
                    Expanded(
                      child: ListView(
                        children: [
                          // Hijaiyah Card
                          _buildCategoryCard(
                            context,
                            title: 'HIJAIYAH',
                            color: const Color(0xFF50C6E4),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.generalHijaiyah,
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          // Tajwid Card
                          _buildCategoryCard(
                            context,
                            title: 'TAJWID',
                            color: const Color(0xFF50C6E4),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.generalTajwid,
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          // Sambung Ayat Card
                          _buildCategoryCard(
                            context,
                            title: 'SAMBUNG AYAT',
                            color: const Color(0xFF50C6E4),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.generalSambungAyat,
                              );
                            },
                          ),
                        ],
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

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
