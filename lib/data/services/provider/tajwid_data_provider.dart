import '../../models/tajwid/tajwid_rule.dart';

/// Data provider for the Tajwid game
/// Contains tajwid rules data for each level
class TajwidDataProvider {
  /// Get tajwid rules for a specific level
  static List<TajwidRule> getRulesForLevel(int level) {
    // Each level has different rules with increasing complexity
    return _allLevelsData[level] ?? [];
  }

  /// All game data organized by levels
  static final Map<int, List<TajwidRule>> _allLevelsData = {
    // Level 1: Introduction to Idgham (Nun sukun & tanwin)
    0: [
      TajwidRule(
        name: "Idgham Bighunnah",
        type: "idgham",
        arabicText: "مَن يَقُولُ",
        description: "Nun sukun/tanwin bertemu huruf Ya (ي)",
        example: "مَن يَقُولُ",
        options: ["Idgham Bighunnah", "Idgham Bilaghunnah", "Ikhfa", "Iqlab"],
      ),
      TajwidRule(
        name: "Idgham Bighunnah",
        type: "idgham",
        arabicText: "مِن نِّعْمَةٍ",
        description: "Nun sukun/tanwin bertemu huruf Nun (ن)",
        example: "مِن نِّعْمَةٍ",
        options: ["Idgham Bighunnah", "Idgham Bilaghunnah", "Ikhfa", "Iqlab"],
      ),
      TajwidRule(
        name: "Idgham Bighunnah",
        type: "idgham",
        arabicText: "خَيْرٌ مِّنْ",
        description: "Nun sukun/tanwin bertemu huruf Mim (م)",
        example: "خَيْرٌ مِّنْ",
        options: ["Idgham Bighunnah", "Idgham Bilaghunnah", "Ikhfa", "Iqlab"],
      ),
    ],

    // Level 2: More Idgham examples
    1: [
      TajwidRule(
        name: "Idgham Bighunnah",
        type: "idgham",
        arabicText: "عَلِيمٌ وَ",
        description: "Nun sukun/tanwin bertemu huruf Waw (و)",
        example: "عَلِيمٌ وَ",
        options: ["Idgham Bighunnah", "Idgham Bilaghunnah", "Izhhar", "Iqlab"],
      ),
      TajwidRule(
        name: "Idgham Bilaghunnah",
        type: "idgham",
        arabicText: "مِن رَّبِّهِمْ",
        description: "Nun sukun/tanwin bertemu huruf Ra (ر)",
        example: "مِن رَّبِّهِمْ",
        options: ["Idgham Bilaghunnah", "Idgham Bighunnah", "Ikhfa", "Iqlab"],
      ),
      TajwidRule(
        name: "Idgham Bilaghunnah",
        type: "idgham",
        arabicText: "مِن لَّدُنْهُ",
        description: "Nun sukun/tanwin bertemu huruf Lam (ل)",
        example: "مِن لَّدُنْهُ",
        options: ["Idgham Bilaghunnah", "Idgham Bighunnah", "Ikhfa", "Izhhar"],
      ),
    ],

    // Level 3: Introduction to Ikhfa
    2: [
      TajwidRule(
        name: "Ikhfa",
        type: "ikhfa",
        arabicText: "مِن قَبْلُ",
        description: "Nun sukun/tanwin bertemu huruf Qaf (ق)",
        example: "مِن قَبْلُ",
        options: ["Ikhfa", "Idgham Bighunnah", "Idgham Bilaghunnah", "Iqlab"],
      ),
      TajwidRule(
        name: "Ikhfa",
        type: "ikhfa",
        arabicText: "كُنتُمْ",
        description: "Nun sukun/tanwin bertemu huruf Ta (ت)",
        example: "كُنتُمْ",
        options: ["Ikhfa", "Idgham Bighunnah", "Izhhar", "Iqlab"],
      ),
      TajwidRule(
        name: "Ikhfa",
        type: "ikhfa",
        arabicText: "مِن ثَمَرَةٍ",
        description: "Nun sukun/tanwin bertemu huruf Tsa (ث)",
        example: "مِن ثَمَرَةٍ",
        options: ["Ikhfa", "Idgham Bilaghunnah", "Izhhar", "Iqlab"],
      ),
    ],

    // Level 4: More Ikhfa examples
    3: [
      TajwidRule(
        name: "Ikhfa",
        type: "ikhfa",
        arabicText: "مِنْ جُوعٍ",
        description: "Nun sukun/tanwin bertemu huruf Jim (ج)",
        example: "مِنْ جُوعٍ",
        options: ["Ikhfa", "Idgham Bighunnah", "Idgham Bilaghunnah", "Izhhar"],
      ),
      TajwidRule(
        name: "Ikhfa",
        type: "ikhfa",
        arabicText: "أَن دَّعَاهُ",
        description: "Nun sukun/tanwin bertemu huruf Dal (د)",
        example: "أَن دَّعَاهُ",
        options: ["Ikhfa", "Idgham Bighunnah", "Izhhar", "Iqlab"],
      ),
      TajwidRule(
        name: "Ikhfa",
        type: "ikhfa",
        arabicText: "مِن ذَكَرٍ",
        description: "Nun sukun/tanwin bertemu huruf Dzal (ذ)",
        example: "مِن ذَكَرٍ",
        options: ["Ikhfa", "Idgham Bilaghunnah", "Idgham Bighunnah", "Iqlab"],
      ),
    ],

    // Level 5: Iqlab and more Ikhfa
    4: [
      TajwidRule(
        name: "Iqlab",
        type: "iqlab",
        arabicText: "مِنۢ بَعْدِ",
        description: "Nun sukun/tanwin bertemu huruf Ba (ب)",
        example: "مِنۢ بَعْدِ",
        options: ["Iqlab", "Ikhfa", "Idgham Bighunnah", "Izhhar"],
      ),
      TajwidRule(
        name: "Ikhfa",
        type: "ikhfa",
        arabicText: "أَن زَّيَّنَّا",
        description: "Nun sukun/tanwin bertemu huruf Za (ز)",
        example: "أَن زَّيَّنَّا",
        options: ["Ikhfa", "Idgham Bighunnah", "Izhhar", "Iqlab"],
      ),
      TajwidRule(
        name: "Ikhfa",
        type: "ikhfa",
        arabicText: "مَنْ سَمِعَ",
        description: "Nun sukun/tanwin bertemu huruf Sin (س)",
        example: "مَنْ سَمِعَ",
        options: ["Ikhfa", "Idgham Bilaghunnah", "Izhhar", "Iqlab"],
      ),
    ],

    // Level 6: Izhhar and more Ikhfa
    5: [
      TajwidRule(
        name: "Izhhar",
        type: "izhhar",
        arabicText: "مِنْ عِلْمٍ",
        description: "Nun sukun/tanwin bertemu huruf 'Ain (ع)",
        example: "مِنْ عِلْمٍ",
        options: ["Izhhar", "Ikhfa", "Idgham Bighunnah", "Iqlab"],
      ),
      TajwidRule(
        name: "Ikhfa",
        type: "ikhfa",
        arabicText: "مَنْ شَاءَ",
        description: "Nun sukun/tanwin bertemu huruf Syin (ش)",
        example: "مَنْ شَاءَ",
        options: ["Ikhfa", "Idgham Bighunnah", "Izhhar", "Iqlab"],
      ),
      TajwidRule(
        name: "Ikhfa",
        type: "ikhfa",
        arabicText: "مِن صَدَقَةٍ",
        description: "Nun sukun/tanwin bertemu huruf Shad (ص)",
        example: "مِن صَدَقَةٍ",
        options: ["Ikhfa", "Idgham Bilaghunnah", "Izhhar", "Iqlab"],
      ),
    ],

    // Level 7: More Izhhar and Ikhfa examples
    6: [
      TajwidRule(
        name: "Izhhar",
        type: "izhhar",
        arabicText: "مِنْ غِلٍّ",
        description: "Nun sukun/tanwin bertemu huruf Ghain (غ)",
        example: "مِنْ غِلٍّ",
        options: ["Izhhar", "Ikhfa", "Idgham Bighunnah", "Iqlab"],
      ),
      TajwidRule(
        name: "Izhhar",
        type: "izhhar",
        arabicText: "مِنْ هَادٍ",
        description: "Nun sukun/tanwin bertemu huruf Ha (هـ)",
        example: "مِنْ هَادٍ",
        options: ["Izhhar", "Ikhfa", "Idgham Bilaghunnah", "Iqlab"],
      ),
      TajwidRule(
        name: "Ikhfa",
        type: "ikhfa",
        arabicText: "مِن ضَرِيعٍ",
        description: "Nun sukun/tanwin bertemu huruf Dhad (ض)",
        example: "مِن ضَرِيعٍ",
        options: ["Ikhfa", "Idgham Bighunnah", "Izhhar", "Idgham Bilaghunnah"],
      ),
    ],

    // Level 8: Mixed examples to test knowledge
    7: [
      TajwidRule(
        name: "Ikhfa",
        type: "ikhfa",
        arabicText: "مِن طَيِّبَاتِ",
        description: "Nun sukun/tanwin bertemu huruf Tha (ط)",
        example: "مِن طَيِّبَاتِ",
        options: ["Ikhfa", "Izhhar", "Idgham Bighunnah", "Iqlab"],
      ),
      TajwidRule(
        name: "Ikhfa",
        type: "ikhfa",
        arabicText: "كُنتُم ظَالِمِينَ",
        description: "Nun sukun/tanwin bertemu huruf Zha (ظ)",
        example: "كُنتُم ظَالِمِينَ",
        options: ["Ikhfa", "Izhhar", "Idgham Bilaghunnah", "Iqlab"],
      ),
      TajwidRule(
        name: "Ikhfa",
        type: "ikhfa",
        arabicText: "مِن فَضْلِهِ",
        description: "Nun sukun/tanwin bertemu huruf Fa (ف)",
        example: "مِن فَضْلِهِ",
        options: ["Ikhfa", "Idgham Bighunnah", "Izhhar", "Idgham Bilaghunnah"],
      ),
    ],

    // Level 9: More challenging mixed examples
    8: [
      TajwidRule(
        name: "Izhhar",
        type: "izhhar",
        arabicText: "مَنْ أَرَادَ",
        description: "Nun sukun/tanwin bertemu huruf Alif (ا)",
        example: "مَنْ أَرَادَ",
        options: ["Izhhar", "Ikhfa", "Idgham Bighunnah", "Iqlab"],
      ),
      TajwidRule(
        name: "Ikhfa",
        type: "ikhfa",
        arabicText: "مِن كُلِّ",
        description: "Nun sukun/tanwin bertemu huruf Kaf (ك)",
        example: "مِن كُلِّ",
        options: ["Ikhfa", "Izhhar", "Idgham Bilaghunnah", "Idgham Bighunnah"],
      ),
      TajwidRule(
        name: "Izhhar",
        type: "izhhar",
        arabicText: "مِنْ خَوْفٍ",
        description: "Nun sukun/tanwin bertemu huruf Kha (خ)",
        example: "مِنْ خَوْفٍ",
        options: ["Izhhar", "Ikhfa", "Idgham Bighunnah", "Iqlab"],
      ),
    ],

    // Level 10: Advanced mixed practice
    9: [
      TajwidRule(
        name: "Izhhar",
        type: "izhhar",
        arabicText: "مِنْ حَكِيمٍ",
        description: "Nun sukun/tanwin bertemu huruf Ha (ح)",
        example: "مِنْ حَكِيمٍ",
        options: ["Izhhar", "Ikhfa", "Idgham Bilaghunnah", "Iqlab"],
      ),
      TajwidRule(
        name: "Idgham Bighunnah",
        type: "idgham",
        arabicText: "قَوْلٌ مَّعْرُوفٌ",
        description: "Nun sukun/tanwin bertemu huruf Mim (م)",
        example: "قَوْلٌ مَّعْرُوفٌ",
        options: ["Idgham Bighunnah", "Idgham Bilaghunnah", "Ikhfa", "Izhhar"],
      ),
      TajwidRule(
        name: "Iqlab",
        type: "iqlab",
        arabicText: "سَمِيعٌ بَصِيرٌ",
        description: "Nun sukun/tanwin bertemu huruf Ba (ب)",
        example: "سَمِيعٌ بَصِيرٌ",
        options: ["Iqlab", "Ikhfa", "Idgham Bighunnah", "Izhhar"],
      ),
    ],
  };
}
