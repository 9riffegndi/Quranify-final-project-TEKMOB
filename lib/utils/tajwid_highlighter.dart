import 'package:flutter/material.dart';
import 'tajwid_rules.dart';

/// A simple utility class to highlight tajwid rules in Quran text
class TajwidHighlighter {
  /// Highlight basic tajwid rules in Arabic text
  /// This is a simple implementation that only checks individual characters
  static List<TextSpan> highlightTajwid(String arabicText) {
    List<TextSpan> spans = [];

    for (int i = 0; i < arabicText.length; i++) {
      String char = arabicText[i];

      // Apply simple tajwid coloring based on character
      if (TajwidRules.hasTajwidRule(char)) {
        spans.add(
          TextSpan(
            text: char,
            style: TextStyle(
              color: TajwidRules.getTajwidColor(char),
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

  /// Simple method to analyze and highlight tajwid in a verse
  /// This is a wrapper for the simple highlightTajwid method
  static List<TextSpan> analyzeVerse(String arabicVerse) {
    return highlightTajwid(arabicVerse);
  }
}
