import '../../models/tajwid/advanced_tajwid_rule.dart';

/// Data provider for advanced Tajwid game with 10 challenging levels
class AdvancedTajwidDataProvider {
  /// Get Tajwid rules for a specific level
  static List<AdvancedTajwidRule> getRulesForLevel(int level) {
    return _allLevelsData[level] ?? [];
  }

  /// Get level title
  static String getLevelTitle(int level) {
    return _levelTitles[level] ?? 'Level Tidak Dikenal';
  }

  /// Get level description
  static String getLevelDescription(int level) {
    return _levelDescriptions[level] ?? 'Deskripsi tidak tersedia';
  }

  /// Level titles
  static final Map<int, String> _levelTitles = {
    0: 'Dasar Nun Sakinah & Tanwin',
    1: 'Kaidah Mim Sakinah',
    2: 'Penguasaan Qalqalah',
    3: 'Kaidah Mad (Panjang Pendek)',
    4: 'Kaidah Ra & Variasinya',
    5: 'Kaidah Lam & Penerapannya',
    6: 'Jenis Mad Lanjutan',
    7: 'Kaidah Waqf (Berhenti)',
    8: 'Kombinasi Kaidah Kompleks',
    9: 'Kuasai Semua Kaidah',
  };

  /// Level descriptions
  static final Map<int, String> _levelDescriptions = {
    0: 'Pelajari kaidah dasar Nun Sakinah dan Tanwin',
    1: 'Kuasai kaidah yang mengatur Mim Sakinah',
    2: 'Sempurnakan pelafalan Qalqalah Anda',
    3: 'Pahami kaidah dasar Mad (panjang pendek)',
    4: 'Pelajari kapan melafalkan Ra tebal atau tipis',
    5: 'Kuasai pelafalan Lam',
    6: 'Jenis Mad lanjutan dan penerapannya',
    7: 'Pelajari kaidah berhenti yang tepat dalam tilawah',
    8: 'Tantang diri dengan kombinasi kaidah kompleks',
    9: 'Ujian tertinggi semua pengetahuan Tajwid',
  };

  /// All game data organized by levels
  static final Map<int, List<AdvancedTajwidRule>> _allLevelsData = {
    // Level 1: Nun Sakinah & Tanwin Basics
    0: [
      AdvancedTajwidRule(
        name: 'Idzhar',
        arabicName: 'إظهار',
        description: 'Pelafalan jelas Nun Sakinah/Tanwin',
        detailedExplanation:
            'Ketika Nun Sakinah atau Tanwin diikuti huruf tenggorokan (ء ه ع ح غ خ), harus dilafalkan dengan jelas tanpa perubahan.',
        examples: ['من هاد', 'من عمل', 'من آمن'],
        arabicExamples: ['مِنْ هَادٍ', 'مِنْ عَمِلَ', 'مِنْ آمَنَ'],
        condition: 'Sebelum huruf tenggorokan: ء ه ع ح غ خ',
        pronunciation: 'Dilafalkan dengan jelas dan tegas',
        category: 'Nun Sakinah & Tanwin',
        color: '#FF6B6B',
        letters: ['ء', 'ه', 'ع', 'ح', 'غ', 'خ'],
        audio: 'assets/audio/hijaiyah/hamzah.mp3',
        difficulty: 2,
      ),
      AdvancedTajwidRule(
        name: 'Idgham',
        arabicName: 'إدغام',
        description: 'Melebur Nun Sakinah/Tanwin dengan huruf berikutnya',
        detailedExplanation:
            'Ketika Nun Sakinah atau Tanwin diikuti huruf tertentu (ي ر م ل و ن), maka melebur dengan huruf berikutnya.',
        examples: ['من يقول', 'من ربك', 'من ماء'],
        arabicExamples: ['مِنْ يَقُولُ', 'مِنْ رَبِّكَ', 'مِنْ مَاءٍ'],
        condition: 'Sebelum huruf: ي ر م ل و ن',
        pronunciation: 'Melebur dengan huruf berikutnya',
        category: 'Nun Sakinah & Tanwin',
        color: '#4ECDC4',
        letters: ['ي', 'ر', 'م', 'ل', 'و', 'ن'],
        audio: 'assets/audio/hijaiyah/ya.mp3',
        difficulty: 3,
      ),
      AdvancedTajwidRule(
        name: 'Ikhfa',
        arabicName: 'إخفاء',
        description: 'Menyembunyikan bunyi Nun Sakinah/Tanwin',
        detailedExplanation:
            'Ketika Nun Sakinah atau Tanwin diikuti 15 huruf tertentu, maka disembunyikan dengan bunyi sengau (ghunnah).',
        examples: ['من قبل', 'من كل', 'من تحت'],
        arabicExamples: ['مِنْ قَبْلِ', 'مِنْ كُلِّ', 'مِنْ تَحْتِ'],
        condition: 'Sebelum 15 huruf: ت ث ج د ذ ز س ش ص ض ط ظ ف ق ك',
        pronunciation: 'Disembunyikan dengan bunyi sengau',
        category: 'Nun Sakinah & Tanwin',
        color: '#45B7D1',
        letters: [
          'ت',
          'ث',
          'ج',
          'د',
          'ذ',
          'ز',
          'س',
          'ش',
          'ص',
          'ض',
          'ط',
          'ظ',
          'ف',
          'ق',
          'ك',
        ],
        audio: 'assets/audio/hijaiyah/ta.mp3',
        difficulty: 4,
      ),
      AdvancedTajwidRule(
        name: 'Iqlab',
        arabicName: 'إقلاب',
        description: 'Mengubah bunyi Nun Sakinah/Tanwin menjadi Mim',
        detailedExplanation:
            'Ketika Nun Sakinah atau Tanwin diikuti huruf Ba (ب), maka diubah menjadi bunyi Mim dengan ghunnah.',
        examples: ['من بعد', 'أنبئهم', 'سمبونة'],
        arabicExamples: ['مِنْ بَعْدِ', 'أَنْبِئْهُمْ', 'سَمْبُونَةٍ'],
        condition: 'Sebelum huruf: ب',
        pronunciation: 'Diubah menjadi bunyi Mim',
        category: 'Nun Sakinah & Tanwin',
        color: '#96CEB4',
        letters: ['ب'],
        audio: 'assets/audio/hijaiyah/ba.mp3',
        difficulty: 3,
      ),
    ],

    // Level 2: Mim Sakinah Rules
    1: [
      AdvancedTajwidRule(
        name: 'Ikhfa Shafawi',
        arabicName: 'إخفاء شفوي',
        description: 'Menyembunyikan Mim Sakinah sebelum Ba',
        detailedExplanation:
            'Ketika Mim Sakinah diikuti huruf Ba (ب), maka disembunyikan dengan bunyi sengau bibir.',
        examples: ['هم بالغيب', 'أم بصير', 'تركهم بظلماتهم'],
        arabicExamples: [
          'هُمْ بِالْغَيْبِ',
          'أَمْ بَصِيرٌ',
          'تَرَكَهُمْ بِظُلُمَاتِهِمْ',
        ],
        condition: 'Mim Sakinah sebelum ب',
        pronunciation: 'Disembunyikan dengan bunyi sengau bibir',
        category: 'Mim Sakinah',
        color: '#F7DC6F',
        letters: ['ب'],
        audio: 'assets/audio/hijaiyah/ba.mp3',
        difficulty: 3,
      ),
      AdvancedTajwidRule(
        name: 'Idgham Shafawi',
        arabicName: 'إدغام شفوي',
        description: 'Melebur Mim Sakinah dengan Mim',
        detailedExplanation:
            'Ketika Mim Sakinah diikuti Mim lainnya, maka keduanya melebur menjadi satu.',
        examples: ['لهم ما', 'أم من', 'كم من'],
        arabicExamples: ['لَهُمْ مَا', 'أَمْ مَنْ', 'كَمْ مِنْ'],
        condition: 'Mim Sakinah sebelum م',
        pronunciation: 'Melebur dengan Mim berikutnya',
        category: 'Mim Sakinah',
        color: '#BB8FCE',
        letters: ['م'],
        audio: 'assets/audio/hijaiyah/mim.mp3',
        difficulty: 2,
      ),
      AdvancedTajwidRule(
        name: 'Idzhar Shafawi',
        arabicName: 'إظهار شفوي',
        description: 'Pelafalan jelas Mim Sakinah',
        detailedExplanation:
            'Ketika Mim Sakinah diikuti huruf apa saja kecuali ب dan م, maka dilafalkan dengan jelas.',
        examples: ['هم فيها', 'أم حسب', 'تمت كلمة'],
        arabicExamples: ['هُمْ فِيهَا', 'أَمْ حَسِبَ', 'تَمَّتْ كَلِمَةُ'],
        condition: 'Mim Sakinah sebelum semua huruf kecuali ب dan م',
        pronunciation: 'Jelas dan tegas',
        category: 'Mim Sakinah',
        color: '#85C1E9',
        letters: [
          'ء',
          'ت',
          'ث',
          'ج',
          'ح',
          'خ',
          'د',
          'ذ',
          'ر',
          'ز',
          'س',
          'ش',
          'ص',
          'ض',
          'ط',
          'ظ',
          'ع',
          'غ',
          'ف',
          'ق',
          'ك',
          'ل',
          'ن',
          'ه',
          'و',
          'ي',
        ],
        audio: 'assets/audio/hijaiyah/mim.mp3',
        difficulty: 2,
      ),
    ],

    // Level 3: Qalqalah Mastery
    2: [
      AdvancedTajwidRule(
        name: 'Qalqalah Sughra',
        arabicName: 'قلقلة صغرى',
        description: 'Qalqalah Kecil (di tengah kata)',
        detailedExplanation:
            'Ketika huruf Qalqalah (ق ط ب ج د) berharakat sukun di tengah kata, dilafalkan dengan pantulan ringan.',
        examples: ['يقطع', 'اجتمع', 'مقطع'],
        arabicExamples: ['يَقْطَعُ', 'اِجْتَمَعَ', 'مَقْطَعٌ'],
        condition: 'Huruf Qalqalah bersukun di tengah kata',
        pronunciation: 'Bunyi pantulan ringan',
        category: 'Qalqalah',
        color: '#F8C471',
        letters: ['ق', 'ط', 'ب', 'ج', 'د'],
        audio: 'assets/audio/hijaiyah/qof.mp3',
        difficulty: 3,
      ),
      AdvancedTajwidRule(
        name: 'Qalqalah Kubra',
        arabicName: 'قلقلة كبرى',
        description: 'Qalqalah Besar (di akhir kata)',
        detailedExplanation:
            'Ketika huruf Qalqalah berada di akhir kata dengan sukun, dilafalkan dengan pantulan yang lebih kuat.',
        examples: ['محيط', 'حب', 'وتد'],
        arabicExamples: ['مُحِيطٌ', 'حَبٌّ', 'وَتَدٌ'],
        condition: 'Huruf Qalqalah di akhir kata dengan sukun',
        pronunciation: 'Bunyi pantulan kuat',
        category: 'Qalqalah',
        color: '#DC7633',
        letters: ['ق', 'ط', 'ب', 'ج', 'د'],
        audio: 'assets/audio/hijaiyah/qof.mp3',
        difficulty: 4,
      ),
    ],

    // Level 4: Mad (Elongation) Rules
    3: [
      AdvancedTajwidRule(
        name: 'Mad Thobi\'i',
        arabicName: 'مد طبيعي',
        description: 'Panjang alami',
        detailedExplanation:
            'Ketika huruf alif, waw, atau ya memiliki panjang alami, maka dipanjangkan selama 2 harakat.',
        examples: ['قال', 'قول', 'قيل'],
        arabicExamples: ['قَالَ', 'قُولُ', 'قِيلَ'],
        condition: 'Huruf Mad alami tanpa hamza atau sukun setelahnya',
        pronunciation: 'Dipanjangkan 2 harakat',
        category: 'Mad',
        color: '#58D68D',
        letters: ['ا', 'و', 'ي'],
        audio: 'assets/audio/hijaiyah/alif.mp3',
        difficulty: 2,
      ),
      AdvancedTajwidRule(
        name: 'Mad Wajib Muttasil',
        arabicName: 'مد واجب متصل',
        description: 'Panjang wajib bersambung',
        detailedExplanation:
            'Ketika huruf Mad diikuti hamza dalam kata yang sama, maka dipanjangkan 4-5 harakat.',
        examples: ['جاء', 'سوء', 'سيء'],
        arabicExamples: ['جَاءَ', 'سُوءٌ', 'سِيءَ'],
        condition: 'Huruf Mad diikuti hamza dalam kata yang sama',
        pronunciation: 'Dipanjangkan 4-5 harakat',
        category: 'Mad',
        color: '#5DADE2',
        letters: ['ا', 'و', 'ي'],
        audio: 'assets/audio/hijaiyah/alif.mp3',
        difficulty: 4,
      ),
      AdvancedTajwidRule(
        name: 'Mad Jaiz Munfasil',
        arabicName: 'مد جائز منفصل',
        description: 'Panjang boleh terpisah',
        detailedExplanation:
            'Ketika huruf Mad diikuti hamza dalam kata yang berbeda, boleh dipanjangkan 2, 4, atau 5 harakat.',
        examples: ['في أنفسهم', 'قوا أنفسكم', 'يا أيها'],
        arabicExamples: [
          'فِي أَنْفُسِهِمْ',
          'قُوا أَنْفُسَكُمْ',
          'يَا أَيُّهَا',
        ],
        condition: 'Huruf Mad diikuti hamza dalam kata yang berbeda',
        pronunciation: 'Dipanjangkan 2, 4, atau 5 harakat',
        category: 'Mad',
        color: '#AF7AC5',
        letters: ['ا', 'و', 'ي'],
        audio: 'assets/audio/hijaiyah/alif.mp3',
        difficulty: 5,
      ),
    ],

    // Level 5: Ra Rules & Variations
    4: [
      AdvancedTajwidRule(
        name: 'Ra Tafkhim',
        arabicName: 'راء تفخيم',
        description: 'Pelafalan Ra tebal',
        detailedExplanation:
            'Ra dilafalkan tebal ketika berharakat fatha, damma, atau diikuti alif.',
        examples: ['رب', 'رحمن', 'قرآن'],
        arabicExamples: ['رَبِّ', 'رَحْمَنِ', 'قُرْآنٌ'],
        condition: 'Ra berharakat fatha, damma, atau diikuti alif',
        pronunciation: 'Tebal dan berat',
        category: 'Ra Rules',
        color: '#E74C3C',
        letters: ['ر'],
        audio: 'assets/audio/hijaiyah/ro.mp3',
        difficulty: 3,
      ),
      AdvancedTajwidRule(
        name: 'Ra Tarqiq',
        arabicName: 'راء ترقيق',
        description: 'Pelafalan Ra tipis',
        detailedExplanation:
            'Ra dilafalkan tipis ketika berharakat kasra atau didahului kasra.',
        examples: ['رجال', 'بر', 'خير'],
        arabicExamples: ['رِجَالٌ', 'بِرٌّ', 'خَيْرٌ'],
        condition: 'Ra berharakat kasra atau didahului kasra',
        pronunciation: 'Tipis dan ringan',
        category: 'Ra Rules',
        color: '#3498DB',
        letters: ['ر'],
        audio: 'assets/audio/hijaiyah/ro.mp3',
        difficulty: 3,
      ),
    ],

    // Level 6: Lam Rules & Applications
    5: [
      AdvancedTajwidRule(
        name: 'Lam Tafkhim',
        arabicName: 'لام تفخيم',
        description: 'Pelafalan Lam tebal',
        detailedExplanation:
            'Lam pada lafadz Allah dilafalkan tebal ketika didahului fatha atau damma.',
        examples: ['قال الله', 'رسول الله', 'عبد الله'],
        arabicExamples: ['قَالَ اللَّهُ', 'رَسُولُ اللَّهِ', 'عَبْدُ اللَّهِ'],
        condition: 'Lam pada Allah didahului fatha atau damma',
        pronunciation: 'Tebal dan berat',
        category: 'Lam Rules',
        color: '#E67E22',
        letters: ['ل'],
        audio: 'assets/audio/hijaiyah/lam.mp3',
        difficulty: 4,
      ),
      AdvancedTajwidRule(
        name: 'Lam Tarqiq',
        arabicName: 'لام ترقيق',
        description: 'Pelafalan Lam tipis',
        detailedExplanation:
            'Lam pada lafadz Allah dilafalkan tipis ketika didahului kasra.',
        examples: ['بسم الله', 'في الله', 'إلى الله'],
        arabicExamples: ['بِسْمِ اللَّهِ', 'فِي اللَّهِ', 'إِلَى اللَّهِ'],
        condition: 'Lam pada Allah didahului kasra',
        pronunciation: 'Tipis dan ringan',
        category: 'Lam Rules',
        color: '#27AE60',
        letters: ['l'],
        audio: 'assets/audio/hijaiyah/lam.mp3',
        difficulty: 4,
      ),
    ],

    // Level 7: Advanced Mad Types
    6: [
      AdvancedTajwidRule(
        name: 'Mad Lazim',
        arabicName: 'مد لازم',
        description: 'Panjang wajib',
        detailedExplanation:
            'Ketika huruf Mad diikuti huruf bertasydid atau bersukun, maka dipanjangkan 6 harakat.',
        examples: ['الضالين', 'الطامة', 'دابة'],
        arabicExamples: ['الضَّالِّينَ', 'الطَّامَّةُ', 'دَابَّةٌ'],
        condition: 'Huruf Mad diikuti huruf bertasydid atau bersukun',
        pronunciation: 'Dipanjangkan 6 harakat',
        category: 'Advanced Mad',
        color: '#8E44AD',
        letters: ['ا', 'و', 'ي'],
        audio: 'assets/audio/hijaiyah/alif.mp3',
        difficulty: 5,
      ),
      AdvancedTajwidRule(
        name: 'Mad Aridh Lissukun',
        arabicName: 'مد عارض للسكون',
        description: 'Panjang karena waqaf',
        detailedExplanation:
            'Ketika berhenti pada kata yang diakhiri huruf Mad, boleh dipanjangkan 2, 4, atau 6 harakat.',
        examples: ['الرحيم', 'العظيم', 'الحكيم'],
        arabicExamples: ['الرَّحِيمْ', 'الْعَظِيمْ', 'الْحَكِيمْ'],
        condition: 'Huruf Mad di akhir kata ketika berhenti',
        pronunciation: 'Dipanjangkan 2, 4, atau 6 harakat',
        category: 'Advanced Mad',
        color: '#16A085',
        letters: ['ا', 'و', 'ي'],
        audio: 'assets/audio/hijaiyah/alif.mp3',
        difficulty: 6,
      ),
    ],

    // Level 8: Waqf (Stopping) Rules
    7: [
      AdvancedTajwidRule(
        name: 'Waqf Tam',
        arabicName: 'وقف تام',
        description: 'Waqaf sempurna',
        detailedExplanation:
            'Boleh dan disukai untuk berhenti di akhir kalimat yang lengkap.',
        examples: ['Akhir ayat', 'Pikiran lengkap', 'Kalimat sempurna'],
        arabicExamples: ['نهاية الآيات', 'الأفكار الكاملة', 'الجمل التامة'],
        condition: 'Di akhir makna yang lengkap',
        pronunciation: 'Boleh berhenti sempurna',
        category: 'Waqf',
        color: '#C0392B',
        letters: [],
        audio: 'waqf_tam.mp3',
        difficulty: 4,
      ),
      AdvancedTajwidRule(
        name: 'Waqf Hasan',
        arabicName: 'وقف حسن',
        description: 'Waqaf baik',
        detailedExplanation:
            'Boleh berhenti tetapi melanjutkan lebih baik untuk makna yang lengkap.',
        examples: [
          'Kalimat sebagian',
          'Klausa bergantung',
          'Ide yang terhubung',
        ],
        arabicExamples: ['الجمل الجزئية', 'الجمل التابعة', 'الأفكار المترابطة'],
        condition: 'Di akhir makna sebagian',
        pronunciation: 'Boleh berhenti tapi lanjut lebih baik',
        category: 'Waqf',
        color: '#D35400',
        letters: [],
        audio: 'waqf_hasan.mp3',
        difficulty: 5,
      ),
    ],

    // Level 9: Complex Rule Combinations
    8: [
      AdvancedTajwidRule(
        name: 'Multiple Rules',
        arabicName: 'قواعد متعددة',
        description: 'Menggabungkan beberapa kaidah Tajwid',
        detailedExplanation:
            'Ayat-ayat tingkat lanjut di mana beberapa kaidah Tajwid berlaku secara bersamaan.',
        examples: ['Ayat kompleks', 'Penerapan berganda', 'Kombinasi lanjutan'],
        arabicExamples: ['آيات معقدة', 'تطبيقات متعددة', 'مجموعات متقدمة'],
        condition: 'Beberapa kaidah dalam satu ayat',
        pronunciation: 'Terapkan semua kaidah yang berlaku',
        category: 'Complex Rules',
        color: '#6C3483',
        letters: [],
        audio: 'complex_rules.mp3',
        difficulty: 8,
      ),
    ],

    // Level 10: Master All Rules
    9: [
      AdvancedTajwidRule(
        name: 'Master Level',
        arabicName: 'المستوى الأعلى',
        description: 'Tantangan Tajwid tertinggi',
        detailedExplanation:
            'Menguji semua pengetahuan Tajwid dengan ayat-ayat dan kombinasi kaidah yang paling menantang.',
        examples: ['Ujian tertinggi', 'Semua kaidah digabung', 'Level ahli'],
        arabicExamples: ['الاختبار الأعلى', 'جميع القواعد', 'المستوى الأعلى'],
        condition: 'Semua kaidah Tajwid',
        pronunciation: 'Penerapan sempurna diperlukan',
        category: 'Master Level',
        color: '#1A5490',
        letters: [],
        audio: 'master_level.mp3',
        difficulty: 10,
      ),
    ],
  };
}
