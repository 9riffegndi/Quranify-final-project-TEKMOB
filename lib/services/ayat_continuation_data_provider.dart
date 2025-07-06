import '../../data/models/quran/ayat_continuation.dart';

class AyatContinuationDataProvider {
  // Level titles
  static Map<int, String> _levelTitles = {
    0: 'Surah-surah Pendek',
    1: 'Juz Amma Populer',
    2: 'Al-Baqarah Awal',
    3: 'Al-Baqarah Lanjutan',
    4: 'Ali Imran',
    5: 'An-Nisa dan Al-Maidah',
    6: 'Surah Pilihan Juz 7-12',
    7: 'Surah Pilihan Juz 13-18',
    8: 'Surah Pilihan Juz 19-24',
    9: 'Tantangan Surah Panjang',
  };

  // Level descriptions
  static Map<int, String> _levelDescriptions = {
    0: 'Sambungkan ayat-ayat dari surah pendek yang sering dibaca dalam shalat.',
    1: 'Uji pengetahuan Anda tentang surah-surah populer dari Juz Amma.',
    2: 'Sambungkan ayat-ayat awal dari Surah Al-Baqarah.',
    3: 'Lanjutkan tantangan dengan ayat-ayat pertengahan Surah Al-Baqarah.',
    4: 'Tantangan ayat-ayat dari Surah Ali Imran.',
    5: 'Sambungkan ayat-ayat dari Surah An-Nisa dan Al-Maidah.',
    6: 'Tantangan dari surah-surah pilihan pada Juz 7-12.',
    7: 'Sambungkan ayat-ayat dari surah pilihan Juz 13-18.',
    8: 'Uji hafalan Anda dengan ayat-ayat dari Juz 19-24.',
    9: 'Tantangan terberat dengan ayat-ayat panjang dari berbagai surah.',
  };

  // Get level title
  static String getLevelTitle(int level) {
    return _levelTitles[level] ?? 'Level ${level + 1}';
  }

  // Get level description
  static String getLevelDescription(int level) {
    return _levelDescriptions[level] ?? 'Sambungkan ayat-ayat Al-Quran.';
  }

  // Database of ayat continuation questions by level
  static final Map<int, List<AyatContinuation>> _ayatContinuationsByLevel = {
    // Level 1: Surah-surah Pendek
    0: [
      AyatContinuation(
        surahName: 'Al-Fatihah',
        surahNumber: 1,
        startAyat: 1,
        startAyatText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        continueAyatText: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        options: [
          'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
          'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
          'الرَّحْمَٰنِ الرَّحِيمِ',
          'مَالِكِ يَوْمِ الدِّينِ',
        ],
        correctOptionIndex: 0,
        difficulty: 1,
      ),
      AyatContinuation(
        surahName: 'Al-Fatihah',
        surahNumber: 1,
        startAyat: 3,
        startAyatText: 'الرَّحْمَٰنِ الرَّحِيمِ',
        continueAyatText: 'مَالِكِ يَوْمِ الدِّينِ',
        options: [
          'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
          'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
          'مَالِكِ يَوْمِ الدِّينِ',
          'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
        ],
        correctOptionIndex: 2,
        difficulty: 1,
      ),
      AyatContinuation(
        surahName: 'Al-Ikhlas',
        surahNumber: 112,
        startAyat: 1,
        startAyatText: 'قُلْ هُوَ اللَّهُ أَحَدٌ',
        continueAyatText: 'اللَّهُ الصَّمَدُ',
        options: [
          'اللَّهُ الصَّمَدُ',
          'لَمْ يَلِدْ وَلَمْ يُولَدْ',
          'وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
          'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ',
        ],
        correctOptionIndex: 0,
        difficulty: 1,
      ),
      AyatContinuation(
        surahName: 'Al-Falaq',
        surahNumber: 113,
        startAyat: 1,
        startAyatText: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ',
        continueAyatText: 'مِن شَرِّ مَا خَلَقَ',
        options: [
          'مِن شَرِّ حَاسِدٍ إِذَا حَسَدَ',
          'وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ',
          'مِن شَرِّ مَا خَلَقَ',
          'وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ',
        ],
        correctOptionIndex: 2,
        difficulty: 1,
      ),
      AyatContinuation(
        surahName: 'An-Nas',
        surahNumber: 114,
        startAyat: 1,
        startAyatText: 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
        continueAyatText: 'مَلِكِ النَّاسِ',
        options: [
          'إِلَٰهِ النَّاسِ',
          'مَلِكِ النَّاسِ',
          'مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ',
          'الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ',
        ],
        correctOptionIndex: 1,
        difficulty: 1,
      ),
    ],

    // Level 2: Juz Amma Populer
    1: [
      AyatContinuation(
        surahName: 'Al-Kafirun',
        surahNumber: 109,
        startAyat: 1,
        startAyatText: 'قُلْ يَا أَيُّهَا الْكَافِرُونَ',
        continueAyatText: 'لَا أَعْبُدُ مَا تَعْبُدُونَ',
        options: [
          'لَا أَعْبُدُ مَا تَعْبُدُونَ',
          'وَلَا أَنتُمْ عَابِدُونَ مَا أَعْبُدُ',
          'لَكُمْ دِينُكُمْ وَلِيَ دِينِ',
          'وَلَا أَنَا عَابِدٌ مَّا عَبَدتُّمْ',
        ],
        correctOptionIndex: 0,
        difficulty: 2,
      ),
      AyatContinuation(
        surahName: 'An-Nasr',
        surahNumber: 110,
        startAyat: 1,
        startAyatText: 'إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ',
        continueAyatText:
            'وَرَأَيْتَ النَّاسَ يَدْخُلُونَ فِي دِينِ اللَّهِ أَفْوَاجًا',
        options: [
          'فَسَبِّحْ بِحَمْدِ رَبِّكَ وَاسْتَغْفِرْهُ ۚ إِنَّهُ كَانَ تَوَّابًا',
          'وَرَأَيْتَ النَّاسَ يَدْخُلُونَ فِي دِينِ اللَّهِ أَفْوَاجًا',
          'تَبَّتْ يَدَا أَبِي لَهَبٍ وَتَبَّ',
          'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ',
        ],
        correctOptionIndex: 1,
        difficulty: 2,
      ),
      AyatContinuation(
        surahName: 'Al-Asr',
        surahNumber: 103,
        startAyat: 1,
        startAyatText: 'وَالْعَصْرِ',
        continueAyatText: 'إِنَّ الْإِنسَانَ لَفِي خُسْرٍ',
        options: [
          'إِنَّ الْإِنسَانَ لَفِي خُسْرٍ',
          'وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ',
          'إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ',
          'وَيْلٌ لِّكُلِّ هُمَزَةٍ لُّمَزَةٍ',
        ],
        correctOptionIndex: 0,
        difficulty: 2,
      ),
      AyatContinuation(
        surahName: 'Al-Kauthar',
        surahNumber: 108,
        startAyat: 1,
        startAyatText: 'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ',
        continueAyatText: 'فَصَلِّ لِرَبِّكَ وَانْحَرْ',
        options: [
          'إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ',
          'وَمَا أَدْرَاكَ مَا الْقَارِعَةُ',
          'فَصَلِّ لِرَبِّكَ وَانْحَرْ',
          'قُلْ هُوَ اللَّهُ أَحَدٌ',
        ],
        correctOptionIndex: 2,
        difficulty: 2,
      ),
      AyatContinuation(
        surahName: 'Al-Maun',
        surahNumber: 107,
        startAyat: 1,
        startAyatText: 'أَرَأَيْتَ الَّذِي يُكَذِّبُ بِالدِّينِ',
        continueAyatText: 'فَذَٰلِكَ الَّذِي يَدُعُّ الْيَتِيمَ',
        options: [
          'فَذَٰلِكَ الَّذِي يَدُعُّ الْيَتِيمَ',
          'فَوَيْلٌ لِّلْمُصَلِّينَ',
          'وَلَا يَحُضُّ عَلَىٰ طَعَامِ الْمِسْكِينِ',
          'الَّذِينَ هُمْ عَن صَلَاتِهِمْ سَاهُونَ',
        ],
        correctOptionIndex: 0,
        difficulty: 2,
      ),
    ],

    // Level 3: Al-Baqarah Awal
    2: [
      AyatContinuation(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        startAyat: 1,
        startAyatText: 'الم',
        continueAyatText:
            'ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ',
        options: [
          'ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ',
          'الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ',
          'وَمِمَّا رَزَقْنَاهُمْ يُنفِقُونَ',
          'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
        ],
        correctOptionIndex: 0,
        difficulty: 3,
      ),
      AyatContinuation(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        startAyat: 30,
        startAyatText:
            'وَإِذْ قَالَ رَبُّكَ لِلْمَلَائِكَةِ إِنِّي جَاعِلٌ فِي الْأَرْضِ خَلِيفَةً',
        continueAyatText:
            'قَالُوا أَتَجْعَلُ فِيهَا مَن يُفْسِدُ فِيهَا وَيَسْفِكُ الدِّمَاءَ',
        options: [
          'وَنَحْنُ نُسَبِّحُ بِحَمْدِكَ وَنُقَدِّسُ لَكَ',
          'قَالَ إِنِّي أَعْلَمُ مَا لَا تَعْلَمُونَ',
          'قَالُوا أَتَجْعَلُ فِيهَا مَن يُفْسِدُ فِيهَا وَيَسْفِكُ الدِّمَاءَ',
          'وَعَلَّمَ آدَمَ الْأَسْمَاءَ كُلَّهَا',
        ],
        correctOptionIndex: 2,
        difficulty: 3,
      ),
      AyatContinuation(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        startAyat: 60,
        startAyatText:
            'وَإِذِ اسْتَسْقَىٰ مُوسَىٰ لِقَوْمِهِ فَقُلْنَا اضْرِب بِّعَصَاكَ الْحَجَرَ',
        continueAyatText: 'فَانفَجَرَتْ مِنْهُ اثْنَتَا عَشْرَةَ عَيْنًا',
        options: [
          'فَكُلُوا وَاشْرَبُوا مِن رِّزْقِ اللَّهِ',
          'كُلُوا مِن طَيِّبَاتِ مَا رَزَقْنَاكُمْ',
          'فَانفَجَرَتْ مِنْهُ اثْنَتَا عَشْرَةَ عَيْنًا',
          'وَمَا ظَلَمُونَا وَلَٰكِن كَانُوا أَنفُسَهُمْ يَظْلِمُونَ',
        ],
        correctOptionIndex: 2,
        difficulty: 3,
      ),
      AyatContinuation(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        startAyat: 255,
        startAyatText: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
        continueAyatText: 'لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ',
        options: [
          'لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ',
          'لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ',
          'مَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ',
          'وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ',
        ],
        correctOptionIndex: 1,
        difficulty: 3,
      ),
      AyatContinuation(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        startAyat: 285,
        startAyatText:
            'آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ',
        continueAyatText:
            'كُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ',
        options: [
          'كُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ',
          'وَقَالُوا سَمِعْنَا وَأَطَعْنَا ۖ غُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ',
          'لَا نُفَرِّقُ بَيْنَ أَحَدٍ مِّن رُّسُلِهِ',
          'لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا',
        ],
        correctOptionIndex: 0,
        difficulty: 3,
      ),
    ],

    // Level 4: Al-Baqarah Lanjutan
    3: [
      AyatContinuation(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        startAyat: 286,
        startAyatText: 'لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا',
        continueAyatText: 'لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ',
        options: [
          'وَإِن تُبْدُوا مَا فِي أَنفُسِكُمْ أَوْ تُخْفُوهُ يُحَاسِبْكُم بِهِ اللَّهُ',
          'لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا مَا آتَاهَا',
          'لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ',
          'رَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا',
        ],
        correctOptionIndex: 2,
        difficulty: 4,
      ),
      AyatContinuation(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        startAyat: 200,
        startAyatText:
            'فَإِذَا قَضَيْتُم مَّنَاسِكَكُمْ فَاذْكُرُوا اللَّهَ كَذِكْرِكُمْ آبَاءَكُمْ أَوْ أَشَدَّ ذِكْرًا',
        continueAyatText:
            'فَمِنَ النَّاسِ مَن يَقُولُ رَبَّنَا آتِنَا فِي الدُّنْيَا وَمَا لَهُ فِي الْآخِرَةِ مِنْ خَلَاقٍ',
        options: [
          'وَمَا لَهُ فِي الْآخِرَةِ مِنْ خَلَاقٍ',
          'فَمِنَ النَّاسِ مَن يَقُولُ رَبَّنَا آتِنَا فِي الدُّنْيَا وَمَا لَهُ فِي الْآخِرَةِ مِنْ خَلَاقٍ',
          'وَمِنْهُم مَّن يَقُولُ رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً',
          'اذْكُرُوا اللَّهَ فِي أَيَّامٍ مَّعْدُودَاتٍ',
        ],
        correctOptionIndex: 1,
        difficulty: 4,
      ),
      AyatContinuation(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        startAyat: 152,
        startAyatText: 'فَاذْكُرُونِي أَذْكُرْكُمْ',
        continueAyatText: 'وَاشْكُرُوا لِي وَلَا تَكْفُرُونِ',
        options: [
          'وَاسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ',
          'وَبَشِّرِ الصَّابِرِينَ',
          'وَلَنَبْلُوَنَّكُم بِشَيْءٍ مِّنَ الْخَوْفِ وَالْجُوعِ',
          'وَاشْكُرُوا لِي وَلَا تَكْفُرُونِ',
        ],
        correctOptionIndex: 3,
        difficulty: 4,
      ),
      AyatContinuation(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        startAyat: 45,
        startAyatText: 'وَاسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ',
        continueAyatText: 'وَإِنَّهَا لَكَبِيرَةٌ إِلَّا عَلَى الْخَاشِعِينَ',
        options: [
          'وَإِنَّهَا لَكَبِيرَةٌ إِلَّا عَلَى الْخَاشِعِينَ',
          'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
          'وَلَا تَقُولُوا لِمَن يُقْتَلُ فِي سَبِيلِ اللَّهِ أَمْوَاتٌ',
          'الَّذِينَ إِذَا أَصَابَتْهُم مُّصِيبَةٌ',
        ],
        correctOptionIndex: 0,
        difficulty: 4,
      ),
      AyatContinuation(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        startAyat: 153,
        startAyatText:
            'يَا أَيُّهَا الَّذِينَ آمَنُوا اسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ',
        continueAyatText: 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
        options: [
          'وَلَا تَقُولُوا لِمَن يُقْتَلُ فِي سَبِيلِ اللَّهِ أَمْوَاتٌ',
          'إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ',
          'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
          'أُولَٰئِكَ عَلَيْهِمْ صَلَوَاتٌ مِّن رَّبِّهِمْ وَرَحْمَةٌ',
        ],
        correctOptionIndex: 2,
        difficulty: 4,
      ),
    ],

    // Level 5: Ali Imran
    4: [
      // Tambahkan pertanyaan lanjutan ayat dari Surah Ali Imran
      AyatContinuation(
        surahName: 'Ali Imran',
        surahNumber: 3,
        startAyat: 190,
        startAyatText:
            'إِنَّ فِي خَلْقِ السَّمَاوَاتِ وَالْأَرْضِ وَاخْتِلَافِ اللَّيْلِ وَالنَّهَارِ',
        continueAyatText: 'لَآيَاتٍ لِّأُولِي الْأَلْبَابِ',
        options: [
          'وَاللَّهُ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ',
          'لَآيَاتٍ لِّأُولِي الْأَلْبَابِ',
          'لَآيَاتٍ لِّقَوْمٍ يَتَفَكَّرُونَ',
          'وَمَا يَذَّكَّرُ إِلَّا أُولُو الْأَلْبَابِ',
        ],
        correctOptionIndex: 1,
        difficulty: 5,
      ),
      AyatContinuation(
        surahName: 'Ali Imran',
        surahNumber: 3,
        startAyat: 102,
        startAyatText:
            'يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ حَقَّ تُقَاتِهِ',
        continueAyatText: 'وَلَا تَمُوتُنَّ إِلَّا وَأَنتُم مُّسْلِمُونَ',
        options: [
          'وَاعْتَصِمُوا بِحَبْلِ اللَّهِ جَمِيعًا وَلَا تَفَرَّقُوا',
          'وَاذْكُرُوا نِعْمَتَ اللَّهِ عَلَيْكُمْ إِذْ كُنتُمْ أَعْدَاءً',
          'وَلْتَكُن مِّنكُمْ أُمَّةٌ يَدْعُونَ إِلَى الْخَيْرِ',
          'وَلَا تَمُوتُنَّ إِلَّا وَأَنتُم مُّسْلِمُونَ',
        ],
        correctOptionIndex: 3,
        difficulty: 5,
      ),
    ],

    // Level 6: An-Nisa dan Al-Maidah
    5: [
      // Tambahkan pertanyaan lanjutan ayat dari Surah An-Nisa dan Al-Maidah
      AyatContinuation(
        surahName: 'An-Nisa',
        surahNumber: 4,
        startAyat: 1,
        startAyatText:
            'يَا أَيُّهَا النَّاسُ اتَّقُوا رَبَّكُمُ الَّذِي خَلَقَكُم مِّن نَّفْسٍ وَاحِدَةٍ',
        continueAyatText:
            'وَخَلَقَ مِنْهَا زَوْجَهَا وَبَثَّ مِنْهُمَا رِجَالًا كَثِيرًا وَنِسَاءً',
        options: [
          'وَخَلَقَ مِنْهَا زَوْجَهَا وَبَثَّ مِنْهُمَا رِجَالًا كَثِيرًا وَنِسَاءً',
          'وَاتَّقُوا اللَّهَ الَّذِي تَسَاءَلُونَ بِهِ وَالْأَرْحَامَ',
          'إِنَّ اللَّهَ كَانَ عَلَيْكُمْ رَقِيبًا',
          'وَآتُوا الْيَتَامَىٰ أَمْوَالَهُمْ',
        ],
        correctOptionIndex: 0,
        difficulty: 6,
      ),
    ],

    // Level 7-10: Tambahkan sesuai kebutuhan
    6: [
      // Tambahkan ayat-ayat dari level 7
    ],
    7: [
      // Tambahkan ayat-ayat dari level 8
    ],
    8: [
      // Tambahkan ayat-ayat dari level 9
    ],
    9: [
      // Tambahkan ayat-ayat dari level 10
    ],
  };

  // Get questions for a specific level
  static List<AyatContinuation> getQuestionsForLevel(int level) {
    return _ayatContinuationsByLevel[level] ?? [];
  }
}
