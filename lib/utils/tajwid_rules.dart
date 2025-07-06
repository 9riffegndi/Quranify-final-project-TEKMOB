import 'package:flutter/material.dart';

class TajwidRules {
  // Tajwid rule colors
  static const Color idghamColor = Color(0xFF4CAF50); // Green
  static const Color ikhfaColor = Color(0xFFF44336); // Red
  static const Color iqlabColor = Color(0xFF2196F3); // Blue
  static const Color idghamMislainColor = Color(0xFF9C27B0); // Purple
  static const Color idghamMutaqaribainColor = Color(0xFFFF9800); // Orange
  static const Color idghamMutajanisainColor = Color(0xFF795548); // Brown
  static const Color ghunnahColor = Color(0xFFFFEB3B); // Yellow
  static const Color qalqalahColor = Color(0xFF009688); // Teal
  static const Color madColor = Color(0xFF3F51B5); // Indigo
  static const Color tanwinColor = Color(0xFFE91E63); // Pink
  static const Color izharColor = Color(0xFF607D8B); // Blue Grey

  // Map of Arabic characters to their tajwid rules
  static const Map<String, Map<String, dynamic>> _tajwidRules = {
    // Idgham rules (when noon sakinah or tanween are followed by certain letters)
    'نْ': {'rule': 'idgham', 'color': idghamColor},
    'ن': {'rule': 'idgham', 'color': idghamColor},

    // Ikhfa rules
    'ك': {'rule': 'ikhfa', 'color': ikhfaColor},

    // Iqlab rule and Qalqalah (combined for 'ب' since it can't have duplicate keys)
    'ب': {'rule': 'iqlab+qalqalah', 'color': iqlabColor},

    // Qalqalah letters (combined for 'ق' which is both ikhfa and qalqalah)
    'ق': {'rule': 'ikhfa+qalqalah', 'color': qalqalahColor},
    'ط': {'rule': 'qalqalah', 'color': qalqalahColor},
    'ج': {'rule': 'qalqalah', 'color': qalqalahColor},
    'د': {'rule': 'qalqalah', 'color': qalqalahColor},

    // Mad letters
    'ا': {'rule': 'mad', 'color': madColor},
    'و': {'rule': 'mad', 'color': madColor},
    'ي': {'rule': 'mad', 'color': madColor},

    // Tanwin letters
    'ً': {'rule': 'tanwin', 'color': tanwinColor},
    'ٌ': {'rule': 'tanwin', 'color': tanwinColor},
    'ٍ': {'rule': 'tanwin', 'color': tanwinColor},
  };

  /// Check if a character has a tajwid rule
  static bool hasTajwidRule(String character) {
    return _tajwidRules.containsKey(character);
  }

  /// Get the color for a tajwid rule
  static Color getTajwidColor(String character) {
    if (_tajwidRules.containsKey(character)) {
      return _tajwidRules[character]!['color'] as Color;
    }
    return Colors.black;
  }

  /// Apply tajwid highlighting to Arabic text
  static List<TextSpan> highlightTajwid(String arabicText) {
    List<TextSpan> spans = [];

    // Simple initial implementation - color each character if it has a tajwid rule
    for (int i = 0; i < arabicText.length; i++) {
      String char = arabicText[i];

      // Check for tajwid rules
      if (hasTajwidRule(char)) {
        spans.add(
          TextSpan(
            text: char,
            style: TextStyle(
              color: getTajwidColor(char),
              fontSize: 24,
              height: 1.5,
              fontFamily: 'Scheherazade',
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: char,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              height: 1.5,
              fontFamily: 'Scheherazade',
            ),
          ),
        );
      }
    }

    return spans;
  }

  /// Build a modal bottom sheet with Tajwid legend
  static Widget buildTajwidLegendModal(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Tajwid',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTajwidLegendItem(
                    'Idgham',
                    idghamColor,
                    'Ketika nun mati atau tanwin bertemu dengan huruf ي و ن م ر ل',
                  ),
                  _buildTajwidLegendItem(
                    'Ikhfa',
                    ikhfaColor,
                    'Ketika nun mati atau tanwin bertemu dengan huruf ت ث ج د ذ ز س ش ص ض ط ظ ف ق ك',
                  ),
                  _buildTajwidLegendItem(
                    'Iqlab',
                    iqlabColor,
                    'Ketika nun mati atau tanwin bertemu dengan huruf ب',
                  ),
                  _buildTajwidLegendItem(
                    'Izhar',
                    izharColor,
                    'Ketika nun mati atau tanwin bertemu dengan huruf ء أ إ ئ ؤ ه ع ح غ خ',
                  ),
                  _buildTajwidLegendItem(
                    'Qalqalah',
                    qalqalahColor,
                    'Huruf qalqalah: ق ط ب ج د',
                  ),
                  _buildTajwidLegendItem('Mad', madColor, 'Huruf mad: ا و ي'),
                  _buildTajwidLegendItem(
                    'Tanwin',
                    tanwinColor,
                    'Tanda baca tanwin: ً ٌ ٍ',
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF54A59F),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildTajwidLegendItem(
    String title,
    Color color,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
