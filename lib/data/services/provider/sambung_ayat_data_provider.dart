import '../../models/ayat_data.dart';

/// Data provider for the Sambung Ayat game
/// Contains verse data for each level
class SambungAyatDataProvider {
  /// Get verse data for a specific level
  static List<AyatData> getVersesForLevel(int level) {
    // Each level has different verses with increasing difficulty
    return _allLevelsData[level] ?? [];
  }

  /// All game data organized by levels
  static final Map<int, List<AyatData>> _allLevelsData = {
    // Level 1: Simple, short verses from Al-Fatihah and short surahs
    0: [
      AyatData(
        surah: "Al-Fatihah",
        surahNumber: 1,
        verseNumber: 1,
        arabicText: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
        translation: "Dengan nama Allah Yang Maha Pengasih, Maha Penyayang",
        continuation: "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
        options: [
          "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
          "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ",
          "مَالِكِ يَوْمِ الدِّينِ",
          "اللَّهُ الصَّمَدُ",
        ],
      ),
      AyatData(
        surah: "Al-Fatihah",
        surahNumber: 1,
        verseNumber: 3,
        arabicText: "الرَّحْمَٰنِ الرَّحِيمِ",
        translation: "Yang Maha Pengasih, Maha Penyayang",
        continuation: "مَالِكِ يَوْمِ الدِّينِ",
        options: [
          "مَالِكِ يَوْمِ الدِّينِ",
          "اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ",
          "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
          "صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ",
        ],
      ),
      AyatData(
        surah: "Al-Ikhlas",
        surahNumber: 112,
        verseNumber: 1,
        arabicText: "قُلْ هُوَ اللَّهُ أَحَدٌ",
        translation: "Katakanlah: 'Dia adalah Allah, Yang Maha Esa'",
        continuation: "اللَّهُ الصَّمَدُ",
        options: [
          "اللَّهُ الصَّمَدُ",
          "وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ",
          "لَمْ يَلِدْ وَلَمْ يُولَدْ",
          "تَبَّتْ يَدَا أَبِي لَهَبٍ وَتَبَّ",
        ],
      ),
    ],

    // Level 2: Continuing with short surahs
    1: [
      AyatData(
        surah: "Al-Ikhlas",
        surahNumber: 112,
        verseNumber: 2,
        arabicText: "اللَّهُ الصَّمَدُ",
        translation: "Allah tempat meminta segala sesuatu",
        continuation: "لَمْ يَلِدْ وَلَمْ يُولَدْ",
        options: [
          "لَمْ يَلِدْ وَلَمْ يُولَدْ",
          "قُلْ هُوَ اللَّهُ أَحَدٌ",
          "وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ",
          "تَبَّتْ يَدَا أَبِي لَهَبٍ وَتَبَّ",
        ],
      ),
      AyatData(
        surah: "Al-Falaq",
        surahNumber: 113,
        verseNumber: 1,
        arabicText: "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ",
        translation:
            "Katakanlah: 'Aku berlindung kepada Tuhan yang menguasai fajar'",
        continuation: "مِنْ شَرِّ مَا خَلَقَ",
        options: [
          "مِنْ شَرِّ مَا خَلَقَ",
          "مِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ",
          "قُلْ أَعُوذُ بِرَبِّ النَّاسِ",
          "وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ",
        ],
      ),
      AyatData(
        surah: "An-Nas",
        surahNumber: 114,
        verseNumber: 1,
        arabicText: "قُلْ أَعُوذُ بِرَبِّ النَّاسِ",
        translation: "Katakanlah: 'Aku berlindung kepada Tuhan manusia'",
        continuation: "مَلِكِ النَّاسِ",
        options: [
          "مَلِكِ النَّاسِ",
          "إِلَٰهِ النَّاسِ",
          "مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ",
          "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ",
        ],
      ),
    ],

    // Level 3: More verses from well-known short surahs
    2: [
      AyatData(
        surah: "Al-Kawthar",
        surahNumber: 108,
        verseNumber: 1,
        arabicText: "إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ",
        translation: "Sesungguhnya, Kami telah memberimu nikmat yang banyak",
        continuation: "فَصَلِّ لِرَبِّكَ وَانْحَرْ",
        options: [
          "فَصَلِّ لِرَبِّكَ وَانْحَرْ",
          "إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ",
          "أَرَأَيْتَ الَّذِي يُكَذِّبُ بِالدِّينِ",
          "إِنَّا أَنْزَلْنَاهُ فِي لَيْلَةِ الْقَدْرِ",
        ],
      ),
      AyatData(
        surah: "An-Nasr",
        surahNumber: 110,
        verseNumber: 1,
        arabicText: "إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ",
        translation: "Apabila telah datang pertolongan Allah dan kemenangan",
        continuation:
            "وَرَأَيْتَ النَّاسَ يَدْخُلُونَ فِي دِينِ اللَّهِ أَفْوَاجًا",
        options: [
          "وَرَأَيْتَ النَّاسَ يَدْخُلُونَ فِي دِينِ اللَّهِ أَفْوَاجًا",
          "فَسَبِّحْ بِحَمْدِ رَبِّكَ وَاسْتَغْفِرْهُ إِنَّهُ كَانَ تَوَّابًا",
          "قُلْ هُوَ اللَّهُ أَحَدٌ",
          "فَصَلِّ لِرَبِّكَ وَانْحَرْ",
        ],
      ),
      AyatData(
        surah: "Al-'Asr",
        surahNumber: 103,
        verseNumber: 1,
        arabicText: "وَالْعَصْرِ",
        translation: "Demi masa",
        continuation: "إِنَّ الْإِنْسَانَ لَفِي خُسْرٍ",
        options: [
          "إِنَّ الْإِنْسَانَ لَفِي خُسْرٍ",
          "إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ",
          "أَلْهَاكُمُ التَّكَاثُرُ",
          "وَيْلٌ لِكُلِّ هُمَزَةٍ لُمَزَةٍ",
        ],
      ),
    ],

    // Level 4: More challenging verses
    3: [
      AyatData(
        surah: "Al-Fatiha",
        surahNumber: 1,
        verseNumber: 5,
        arabicText: "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ",
        translation:
            "Hanya kepada Engkaulah kami menyembah dan hanya kepada Engkaulah kami memohon pertolongan",
        continuation: "اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ",
        options: [
          "اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ",
          "مَالِكِ يَوْمِ الدِّينِ",
          "صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ",
          "غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ",
        ],
      ),
      AyatData(
        surah: "Al-Fatiha",
        surahNumber: 1,
        verseNumber: 6,
        arabicText: "اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ",
        translation: "Tunjukilah kami jalan yang lurus",
        continuation: "صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ",
        options: [
          "صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ",
          "غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ",
          "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ",
          "مَالِكِ يَوْمِ الدِّينِ",
        ],
      ),
      AyatData(
        surah: "Al-Masad",
        surahNumber: 111,
        verseNumber: 1,
        arabicText: "تَبَّتْ يَدَا أَبِي لَهَبٍ وَتَبَّ",
        translation:
            "Binasalah kedua tangan Abu Lahab dan benar-benar binasa dia!",
        continuation: "مَا أَغْنَى عَنْهُ مَالُهُ وَمَا كَسَبَ",
        options: [
          "مَا أَغْنَى عَنْهُ مَالُهُ وَمَا كَسَبَ",
          "سَيَصْلَى نَارًا ذَاتَ لَهَبٍ",
          "وَامْرَأَتُهُ حَمَّالَةَ الْحَطَبِ",
          "فِي جِيدِهَا حَبْلٌ مِنْ مَسَدٍ",
        ],
      ),
    ],

    // Level 5: Ayat from Al-Baqarah
    4: [
      AyatData(
        surah: "Al-Baqarah",
        surahNumber: 2,
        verseNumber: 1,
        arabicText: "الم",
        translation: "Alif Lam Mim",
        continuation:
            "ذَٰلِكَ الْكِتَابُ لَا رَيْبَ فِيهِ هُدًى لِلْمُتَّقِينَ",
        options: [
          "ذَٰلِكَ الْكِتَابُ لَا رَيْبَ فِيهِ هُدًى لِلْمُتَّقِينَ",
          "الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ",
          "وَمِمَّا رَزَقْنَاهُمْ يُنْفِقُونَ",
          "وَإِذْ قَالَ رَبُّكَ لِلْمَلَائِكَةِ إِنِّي جَاعِلٌ فِي الْأَرْضِ خَلِيفَةً",
        ],
      ),
      AyatData(
        surah: "Al-Baqarah",
        surahNumber: 2,
        verseNumber: 255,
        arabicText: "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ",
        translation:
            "Allah, tidak ada tuhan selain Dia. Yang Maha Hidup, Yang terus menerus mengurus (makhluk-Nya)",
        continuation: "لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ",
        options: [
          "لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ",
          "لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ",
          "مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ",
          "يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ",
        ],
      ),
      AyatData(
        surah: "Al-Baqarah",
        surahNumber: 2,
        verseNumber: 285,
        arabicText:
            "آمَنَ الرَّسُولُ بِمَا أُنْزِلَ إِلَيْهِ مِنْ رَبِّهِ وَالْمُؤْمِنُونَ",
        translation:
            "Rasul (Muhammad) beriman kepada apa yang diturunkan kepadanya dari Tuhannya, dan demikian pula orang-orang yang beriman",
        continuation:
            "كُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ",
        options: [
          "كُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ",
          "لَا نُفَرِّقُ بَيْنَ أَحَدٍ مِنْ رُسُلِهِ",
          "وَقَالُوا سَمِعْنَا وَأَطَعْنَا",
          "غُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ",
        ],
      ),
    ],

    // Level 6: More challenging verses from various surahs
    5: [
      AyatData(
        surah: "Al-Imran",
        surahNumber: 3,
        verseNumber: 26,
        arabicText:
            "قُلِ اللَّهُمَّ مَالِكَ الْمُلْكِ تُؤْتِي الْمُلْكَ مَنْ تَشَاءُ",
        translation:
            "Katakanlah: 'Wahai Allah, Pemilik kekuasaan, Engkau berikan kekuasaan kepada siapa yang Engkau kehendaki'",
        continuation:
            "وَتَنْزِعُ الْمُلْكَ مِمَّنْ تَشَاءُ وَتُعِزُّ مَنْ تَشَاءُ وَتُذِلُّ مَنْ تَشَاءُ",
        options: [
          "وَتَنْزِعُ الْمُلْكَ مِمَّنْ تَشَاءُ وَتُعِزُّ مَنْ تَشَاءُ وَتُذِلُّ مَنْ تَشَاءُ",
          "بِيَدِكَ الْخَيْرُ إِنَّكَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ",
          "تُولِجُ اللَّيْلَ فِي النَّهَارِ وَتُولِجُ النَّهَارَ فِي اللَّيْلِ",
          "وَتُخْرِجُ الْحَيَّ مِنَ الْمَيِّتِ وَتُخْرِجُ الْمَيِّتَ مِنَ الْحَيِّ",
        ],
      ),
      AyatData(
        surah: "Al-Kahf",
        surahNumber: 18,
        verseNumber: 45,
        arabicText:
            "وَاضْرِبْ لَهُمْ مَثَلَ الْحَيَاةِ الدُّنْيَا كَمَاءٍ أَنْزَلْنَاهُ مِنَ السَّمَاءِ",
        translation:
            "Dan berilah mereka perumpamaan tentang kehidupan dunia ini, bagaikan air hujan yang Kami turunkan dari langit",
        continuation:
            "فَاخْتَلَطَ بِهِ نَبَاتُ الْأَرْضِ فَأَصْبَحَ هَشِيمًا تَذْرُوهُ الرِّيَاحُ",
        options: [
          "فَاخْتَلَطَ بِهِ نَبَاتُ الْأَرْضِ فَأَصْبَحَ هَشِيمًا تَذْرُوهُ الرِّيَاحُ",
          "وَكَانَ اللَّهُ عَلَىٰ كُلِّ شَيْءٍ مُقْتَدِرًا",
          "الْمَالُ وَالْبَنُونَ زِينَةُ الْحَيَاةِ الدُّنْيَا",
          "وَالْبَاقِيَاتُ الصَّالِحَاتُ خَيْرٌ عِنْدَ رَبِّكَ ثَوَابًا",
        ],
      ),
      AyatData(
        surah: "Ar-Rahman",
        surahNumber: 55,
        verseNumber: 1,
        arabicText: "الرَّحْمَٰنُ",
        translation: "Yang Maha Pengasih",
        continuation: "عَلَّمَ الْقُرْآنَ",
        options: [
          "عَلَّمَ الْقُرْآنَ",
          "خَلَقَ الْإِنْسَانَ",
          "عَلَّمَهُ الْبَيَانَ",
          "الشَّمْسُ وَالْقَمَرُ بِحُسْبَانٍ",
        ],
      ),
    ],

    // Level 7: Even more challenging verses
    6: [
      AyatData(
        surah: "An-Nas",
        surahNumber: 114,
        verseNumber: 3,
        arabicText: "إِلَٰهِ النَّاسِ",
        translation: "Sembahan manusia",
        continuation: "مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ",
        options: [
          "مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ",
          "الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ",
          "مِنَ الْجِنَّةِ وَالنَّاسِ",
          "مَلِكِ النَّاسِ",
        ],
      ),
      AyatData(
        surah: "Al-Asr",
        surahNumber: 103,
        verseNumber: 2,
        arabicText: "إِنَّ الْإِنْسَانَ لَفِي خُسْرٍ",
        translation: "Sungguh, manusia berada dalam kerugian",
        continuation: "إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ",
        options: [
          "إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ",
          "وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ",
          "وَالْعَصْرِ",
          "أَلْهَاكُمُ التَّكَاثُرُ",
        ],
      ),
      AyatData(
        surah: "Al-Qadr",
        surahNumber: 97,
        verseNumber: 1,
        arabicText: "إِنَّا أَنْزَلْنَاهُ فِي لَيْلَةِ الْقَدْرِ",
        translation:
            "Sesungguhnya Kami menurunkannya (Al-Qur'an) pada malam kemuliaan",
        continuation: "وَمَا أَدْرَاكَ مَا لَيْلَةُ الْقَدْرِ",
        options: [
          "وَمَا أَدْرَاكَ مَا لَيْلَةُ الْقَدْرِ",
          "لَيْلَةُ الْقَدْرِ خَيْرٌ مِنْ أَلْفِ شَهْرٍ",
          "تَنَزَّلُ الْمَلَائِكَةُ وَالرُّوحُ فِيهَا بِإِذْنِ رَبِّهِمْ مِنْ كُلِّ أَمْرٍ",
          "سَلَامٌ هِيَ حَتَّىٰ مَطْلَعِ الْفَجْرِ",
        ],
      ),
    ],

    // Level 8: Challenging verses from middle surahs
    7: [
      AyatData(
        surah: "Yaseen",
        surahNumber: 36,
        verseNumber: 1,
        arabicText: "يس",
        translation: "Ya Sin",
        continuation: "وَالْقُرْآنِ الْحَكِيمِ",
        options: [
          "وَالْقُرْآنِ الْحَكِيمِ",
          "إِنَّكَ لَمِنَ الْمُرْسَلِينَ",
          "عَلَىٰ صِرَاطٍ مُسْتَقِيمٍ",
          "تَنْزِيلَ الْعَزِيزِ الرَّحِيمِ",
        ],
      ),
      AyatData(
        surah: "Ar-Rahman",
        surahNumber: 55,
        verseNumber: 3,
        arabicText: "خَلَقَ الْإِنْسَانَ",
        translation: "Dia menciptakan manusia",
        continuation: "عَلَّمَهُ الْبَيَانَ",
        options: [
          "عَلَّمَهُ الْبَيَانَ",
          "الشَّمْسُ وَالْقَمَرُ بِحُسْبَانٍ",
          "وَالنَّجْمُ وَالشَّجَرُ يَسْجُدَانِ",
          "عَلَّمَ الْقُرْآنَ",
        ],
      ),
      AyatData(
        surah: "Ar-Rahman",
        surahNumber: 55,
        verseNumber: 13,
        arabicText: "فَبِأَيِّ آلَاءِ رَبِّكُمَا تُكَذِّبَانِ",
        translation: "Maka nikmat Tuhanmu yang manakah yang kamu dustakan?",
        continuation: "خَلَقَ الْإِنْسَانَ مِنْ صَلْصَالٍ كَالْفَخَّارِ",
        options: [
          "خَلَقَ الْإِنْسَانَ مِنْ صَلْصَالٍ كَالْفَخَّارِ",
          "وَخَلَقَ الْجَانَّ مِنْ مَارِجٍ مِنْ نَارٍ",
          "فِيهِمَا فَاكِهَةٌ وَنَخْلٌ وَرُمَّانٌ",
          "رَبُّ الْمَشْرِقَيْنِ وَرَبُّ الْمَغْرِبَيْنِ",
        ],
      ),
    ],

    // Level 9: Complex verses from different surahs
    8: [
      AyatData(
        surah: "Al-Ankabut",
        surahNumber: 29,
        verseNumber: 2,
        arabicText: "أَحَسِبَ النَّاسُ أَنْ يُتْرَكُوا أَنْ يَقُولُوا آمَنَّا",
        translation:
            "Apakah manusia mengira bahwa mereka akan dibiarkan hanya dengan mengatakan, 'Kami telah beriman'",
        continuation: "وَهُمْ لَا يُفْتَنُونَ",
        options: [
          "وَهُمْ لَا يُفْتَنُونَ",
          "وَلَقَدْ فَتَنَّا الَّذِينَ مِنْ قَبْلِهِمْ",
          "فَلَيَعْلَمَنَّ اللَّهُ الَّذِينَ صَدَقُوا",
          "وَلَيَعْلَمَنَّ الْكَاذِبِينَ",
        ],
      ),
      AyatData(
        surah: "Luqman",
        surahNumber: 31,
        verseNumber: 13,
        arabicText: "وَإِذْ قَالَ لُقْمَانُ لِابْنِهِ وَهُوَ يَعِظُهُ",
        translation:
            "Dan (ingatlah) ketika Luqman berkata kepada anaknya, ketika dia memberi pelajaran kepadanya",
        continuation:
            "يَا بُنَيَّ لَا تُشْرِكْ بِاللَّهِ إِنَّ الشِّرْكَ لَظُلْمٌ عَظِيمٌ",
        options: [
          "يَا بُنَيَّ لَا تُشْرِكْ بِاللَّهِ إِنَّ الشِّرْكَ لَظُلْمٌ عَظِيمٌ",
          "يَا بُنَيَّ أَقِمِ الصَّلَاةَ وَأْمُرْ بِالْمَعْرُوفِ وَانْهَ عَنِ الْمُنْكَرِ",
          "يَا بُنَيَّ إِنَّهَا إِنْ تَكُ مِثْقَالَ حَبَّةٍ مِنْ خَرْدَلٍ",
          "يَا بُنَيَّ لَا تُصَعِّرْ خَدَّكَ لِلنَّاسِ",
        ],
      ),
      AyatData(
        surah: "Al-Mulk",
        surahNumber: 67,
        verseNumber: 1,
        arabicText: "تَبَارَكَ الَّذِي بِيَدِهِ الْمُلْكُ",
        translation: "Maha Suci Allah Yang di tangan-Nya segala kerajaan",
        continuation: "وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ",
        options: [
          "وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ",
          "الَّذِي خَلَقَ الْمَوْتَ وَالْحَيَاةَ لِيَبْلُوَكُمْ أَيُّكُمْ أَحْسَنُ عَمَلًا",
          "الَّذِي خَلَقَ سَبْعَ سَمَاوَاتٍ طِبَاقًا",
          "مَا تَرَىٰ فِي خَلْقِ الرَّحْمَٰنِ مِنْ تَفَاوُتٍ",
        ],
      ),
    ],

    // Level 10: Advanced verses
    9: [
      AyatData(
        surah: "Al-Baqarah",
        surahNumber: 2,
        verseNumber: 286,
        arabicText: "لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا",
        translation:
            "Allah tidak membebani seseorang melainkan sesuai dengan kesanggupannya",
        continuation: "لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ",
        options: [
          "لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ",
          "رَبَّنَا لَا تُؤَاخِذْنَا إِنْ نَسِينَا أَوْ أَخْطَأْنَا",
          "رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِنْ قَبْلِنَا",
          "رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ",
        ],
      ),
      AyatData(
        surah: "Al-Hashr",
        surahNumber: 59,
        verseNumber: 22,
        arabicText: "هُوَ اللَّهُ الَّذِي لَا إِلَٰهَ إِلَّا هُوَ",
        translation: "Dialah Allah, tidak ada tuhan selain Dia",
        continuation:
            "عَالِمُ الْغَيْبِ وَالشَّهَادَةِ هُوَ الرَّحْمَٰنُ الرَّحِيمُ",
        options: [
          "عَالِمُ الْغَيْبِ وَالشَّهَادَةِ هُوَ الرَّحْمَٰنُ الرَّحِيمُ",
          "هُوَ اللَّهُ الَّذِي لَا إِلَٰهَ إِلَّا هُوَ الْمَلِكُ الْقُدُّوسُ",
          "هُوَ اللَّهُ الْخَالِقُ الْبَارِئُ الْمُصَوِّرُ",
          "لَهُ الْأَسْمَاءُ الْحُسْنَىٰ",
        ],
      ),
      AyatData(
        surah: "Al-Ikhlas",
        surahNumber: 112,
        verseNumber: 3,
        arabicText: "لَمْ يَلِدْ وَلَمْ يُولَدْ",
        translation: "Dia tidak beranak dan tidak pula diperanakkan",
        continuation: "وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ",
        options: [
          "وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ",
          "قُلْ هُوَ اللَّهُ أَحَدٌ",
          "اللَّهُ الصَّمَدُ",
          "إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ",
        ],
      ),
    ],
  };
}
