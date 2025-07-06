import 'package:flutter/material.dart';

class KidsTajwidScreen extends StatelessWidget {
  const KidsTajwidScreen({super.key});

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
                    'Tajwid',
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
                    // Kids mode image
                    Image.asset(
                      'assets/images/quiz/kids_mode.png',
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
                            context,
                            title: 'IDGHAM',
                            color: const Color(0xFF50C6E4),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Materi Idgham - Segera Hadir'),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          // Ikhfa Card
                          _buildCategoryCard(
                            context,
                            title: 'IKHFA',
                            color: const Color(0xFF50C6E4),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Materi Ikhfa - Segera Hadir'),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          // Iqlab Card
                          _buildCategoryCard(
                            context,
                            title: 'IQLAB',
                            color: const Color(0xFF50C6E4),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Materi Iqlab - Segera Hadir'),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // Idzhar Card
                          _buildCategoryCard(
                            context,
                            title: 'IDZHAR',
                            color: const Color(0xFF50C6E4),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Materi Idzhar - Segera Hadir'),
                                ),
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
