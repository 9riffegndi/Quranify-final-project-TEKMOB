import 'package:flutter/material.dart';
import '../../../routes/routes.dart';

class BaseFunLearnScreen extends StatelessWidget {
  const BaseFunLearnScreen({super.key});

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
                    'Fun Learn',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF219EBC),
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(child: _buildCategoryList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: Text(
              'FUN LEARN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF219EBC),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Kamu yang mana nih?',
              style: TextStyle(fontSize: 18, color: Color(0xFF219EBC)),
            ),
          ),
          const SizedBox(height: 24),

          // Item 1: Kids Category
          _buildKidsCategoryItem(
            context,
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.kidsFunLearn);
            },
            color: const Color(0xFF50C6E4),
            leftImage: 'assets/images/quiz/hallo.png',
            rightImage: 'assets/images/quiz/ngaji.png',
            label: 'ANAK',
          ),

          const SizedBox(height: 24),
          // Item 2: General Category
          _buildGeneralCategoryItem(
            context,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.generalFunLearn),
            color: const Color(0xFF50C6E4),
            image: 'assets/images/quiz/hallo_general.png',
            label: 'UMUM',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildKidsCategoryItem(
    BuildContext context, {
    required VoidCallback onTap,
    required Color color,
    required String leftImage,
    required String rightImage,
    required String label,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        height: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Left image without padding
            Align(
              alignment: Alignment.bottomLeft,
              child: Image.asset(leftImage, height: 80, fit: BoxFit.fitHeight),
            ),
            Expanded(
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Image.asset(rightImage, height: 80, fit: BoxFit.fitHeight),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralCategoryItem(
    BuildContext context, {
    required VoidCallback onTap,
    required Color color,
    required String image,
    required String label,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        height: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background image on the left side
            Positioned(
              left: 10,
              bottom: 0,
              child: Opacity(
                opacity: 1, // Slightly transparent so text is more readable
                child: Image.asset(image, height: 80, fit: BoxFit.fitHeight),
              ),
            ),
            // Centered label
            Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
