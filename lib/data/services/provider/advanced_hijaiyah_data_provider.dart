import '../../models/hijaiyah/advanced_hijaiyah_letter.dart';

/// Data provider for advanced Hijaiyah game
class AdvancedHijaiyahDataProvider {
  /// Get letter data for a specific level
  static List<AdvancedHijaiyahLetter> getLettersForLevel(int level) {
    return _allLevelsData[level] ?? [];
  }

  /// All game data organized by levels with increasing difficulty
  static final Map<int, List<AdvancedHijaiyahLetter>> _allLevelsData = {
    // Level 1: Identification of letters with similar shapes
    0: [
      AdvancedHijaiyahLetter(
        arabic: 'ب',
        latin: 'Ba',
        audio: 'ba.mp3',
        forms: ['ﺑ', 'ﺒ', 'ﺐ', 'ب'],
        pronounciation:
            'Produced by pressing both lips together and then separating them',
        examples: ['بَاب (door)', 'بَلَد (country)'],
        makhraj: 'Bi-labial (Both lips)',
        sifat:
            'Jahr (Voiced), Shiddah (Stop), Istifal (Lowered), Infitah (Open)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'ت',
        latin: 'Ta',
        audio: 'ta.mp3',
        forms: ['ﺗ', 'ﺘ', 'ﺖ', 'ت'],
        pronounciation:
            'Produced by pressing the tip of the tongue against the base of the front teeth',
        examples: ['تَمْر (dates)', 'تِين (fig)'],
        makhraj: 'Tip of the tongue and base of the front teeth',
        sifat:
            'Hams (Whispered), Shiddah (Stop), Istifal (Lowered), Infitah (Open)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'ث',
        latin: 'Tsa',
        audio: 'tsa.mp3',
        forms: ['ﺛ', 'ﺜ', 'ﺚ', 'ث'],
        pronounciation:
            'Produced by placing the tip of the tongue between the teeth',
        examples: ['ثَلَاثَة (three)', 'ثَوْب (dress)'],
        makhraj: 'Tip of the tongue and the edges of the front teeth',
        sifat:
            'Hams (Whispered), Rakhawah (Friction), Istifal (Lowered), Infitah (Open)',
      ),
    ],

    // Level 2: Letters with similar phonetics
    1: [
      AdvancedHijaiyahLetter(
        arabic: 'ح',
        latin: 'Ha',
        audio: 'ha.mp3',
        forms: ['ﺣ', 'ﺤ', 'ﺢ', 'ح'],
        pronounciation: 'Produced from the middle of the throat with friction',
        examples: ['حَمْد (praise)', 'حَبْل (rope)'],
        makhraj: 'Middle of the throat',
        sifat:
            'Hams (Whispered), Rakhawah (Friction), Istifal (Lowered), Infitah (Open)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'خ',
        latin: 'Kha',
        audio: 'kha.mp3',
        forms: ['ﺧ', 'ﺨ', 'ﺦ', 'خ'],
        pronounciation: 'Produced from the top of the throat with friction',
        examples: ['خَيْر (good)', 'خُبْز (bread)'],
        makhraj: 'Top of the throat',
        sifat:
            'Hams (Whispered), Rakhawah (Friction), Isti\'la (Raised), Infitah (Open)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'هـ',
        latin: 'Ha (end)',
        audio: 'ha_end.mp3',
        forms: ['ﻫ', 'ﻬ', 'ﻪ', 'ه'],
        pronounciation:
            'Produced from the bottom of the throat with an open flow of air',
        examples: ['هُوَ (he)', 'هَذَا (this)'],
        makhraj: 'Bottom of the throat',
        sifat:
            'Hams (Whispered), Rakhawah (Friction), Istifal (Lowered), Infitah (Open)',
      ),
    ],

    // Level 3: Dots and their impact on letters
    2: [
      AdvancedHijaiyahLetter(
        arabic: 'ج',
        latin: 'Jim',
        audio: 'jim.mp3',
        forms: ['ﺟ', 'ﺠ', 'ﺞ', 'ج'],
        pronounciation:
            'Produced from the middle of the tongue touching the roof of the mouth',
        examples: ['جَبَل (mountain)', 'جَمِيل (beautiful)'],
        makhraj: 'Middle of the tongue and the roof of the mouth',
        sifat:
            'Jahr (Voiced), Shiddah (Stop), Istifal (Lowered), Infitah (Open)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'ح',
        latin: 'Ha',
        audio: 'ha.mp3',
        forms: ['ﺣ', 'ﺤ', 'ﺢ', 'ح'],
        pronounciation: 'Produced from the middle of the throat with friction',
        examples: ['حَمْد (praise)', 'حَبْل (rope)'],
        makhraj: 'Middle of the throat',
        sifat:
            'Hams (Whispered), Rakhawah (Friction), Istifal (Lowered), Infitah (Open)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'خ',
        latin: 'Kha',
        audio: 'kha.mp3',
        forms: ['ﺧ', 'ﺨ', 'ﺦ', 'خ'],
        pronounciation: 'Produced from the top of the throat with friction',
        examples: ['خَيْر (good)', 'خُبْز (bread)'],
        makhraj: 'Top of the throat',
        sifat:
            'Hams (Whispered), Rakhawah (Friction), Isti\'la (Raised), Infitah (Open)',
      ),
    ],

    // Level 4: Letters with different makhraj (articulation points)
    3: [
      AdvancedHijaiyahLetter(
        arabic: 'ق',
        latin: 'Qaf',
        audio: 'qaf.mp3',
        forms: ['ﻗ', 'ﻘ', 'ﻖ', 'ق'],
        pronounciation:
            'Produced from the back of the tongue touching the soft palate',
        examples: ['قَلَم (pen)', 'قَمَر (moon)'],
        makhraj: 'Back of the tongue and the soft palate',
        sifat:
            'Jahr (Voiced), Shiddah (Stop), Isti\'la (Raised), Infitah (Open)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'ك',
        latin: 'Kaf',
        audio: 'kaf.mp3',
        forms: ['ﻛ', 'ﻜ', 'ﻚ', 'ك'],
        pronounciation:
            'Produced from the back of the tongue touching the roof of the mouth',
        examples: ['كِتَاب (book)', 'كَبِير (big)'],
        makhraj: 'Back of the tongue and the roof of the mouth',
        sifat:
            'Hams (Whispered), Shiddah (Stop), Istifal (Lowered), Infitah (Open)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'ل',
        latin: 'Lam',
        audio: 'lam.mp3',
        forms: ['ﻟ', 'ﻠ', 'ﻞ', 'ل'],
        pronounciation:
            'Produced from the sides of the tongue touching the molars',
        examples: ['لَيْل (night)', 'لَطِيف (gentle)'],
        makhraj: 'Sides of the tongue and the molars',
        sifat:
            'Jahr (Voiced), Tawassut (Moderate), Istifal (Lowered), Infitah (Open)',
      ),
    ],

    // Level 5: Emphasis letters (heavy letters)
    4: [
      AdvancedHijaiyahLetter(
        arabic: 'ص',
        latin: 'Sad',
        audio: 'sad.mp3',
        forms: ['ﺻ', 'ﺼ', 'ﺺ', 'ص'],
        pronounciation:
            'Produced with the tip of the tongue near the teeth with emphasis',
        examples: ['صَلَاة (prayer)', 'صَبْر (patience)'],
        makhraj: 'Tip of the tongue and the base of the front teeth',
        sifat:
            'Hams (Whispered), Rakhawah (Friction), Isti\'la (Raised), Itbaq (Closed)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'ض',
        latin: 'Dad',
        audio: 'dad.mp3',
        forms: ['ﺿ', 'ﻀ', 'ﺾ', 'ض'],
        pronounciation:
            'Produced with the side of the tongue touching the molars with emphasis',
        examples: ['ضَرْب (hitting)', 'ضَعِيف (weak)'],
        makhraj: 'Side of the tongue and the molars',
        sifat:
            'Jahr (Voiced), Shiddah (Stop), Isti\'la (Raised), Itbaq (Closed)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'ط',
        latin: 'Ta (heavy)',
        audio: 'ta_heavy.mp3',
        forms: ['ﻃ', 'ﻄ', 'ﻂ', 'ط'],
        pronounciation:
            'Produced with the tip of the tongue touching the base of the front teeth with emphasis',
        examples: ['طَرِيق (road)', 'طَعَام (food)'],
        makhraj: 'Tip of the tongue and the base of the front teeth',
        sifat:
            'Jahr (Voiced), Shiddah (Stop), Isti\'la (Raised), Itbaq (Closed)',
      ),
    ],

    // Level 6: Throat letters
    5: [
      AdvancedHijaiyahLetter(
        arabic: 'ء',
        latin: 'Hamzah',
        audio: 'hamzah.mp3',
        forms: ['ء', 'ء', 'ء', 'ء'],
        pronounciation:
            'Produced from the deepest part of the throat with a glottal stop',
        examples: ['أَكَل (ate)', 'سَأَل (asked)'],
        makhraj: 'Deepest part of the throat',
        sifat:
            'Jahr (Voiced), Shiddah (Stop), Istifal (Lowered), Infitah (Open)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'ع',
        latin: 'Ain',
        audio: 'ain.mp3',
        forms: ['ﻋ', 'ﻌ', 'ﻊ', 'ع'],
        pronounciation:
            'Produced from the middle of the throat with constriction',
        examples: ['عِلْم (knowledge)', 'عَمَل (work)'],
        makhraj: 'Middle of the throat',
        sifat:
            'Jahr (Voiced), Tawassut (Moderate), Istifal (Lowered), Infitah (Open)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'غ',
        latin: 'Ghain',
        audio: 'ghain.mp3',
        forms: ['ﻏ', 'ﻐ', 'ﻎ', 'غ'],
        pronounciation:
            'Produced from the top of the throat with friction and vibration',
        examples: ['غَنِي (rich)', 'غَيْر (other)'],
        makhraj: 'Top of the throat',
        sifat:
            'Jahr (Voiced), Rakhawah (Friction), Isti\'la (Raised), Infitah (Open)',
      ),
    ],

    // Level 7: Whispered vs Voiced letters
    6: [
      AdvancedHijaiyahLetter(
        arabic: 'س',
        latin: 'Sin',
        audio: 'sin.mp3',
        forms: ['ﺳ', 'ﺴ', 'ﺲ', 'س'],
        pronounciation:
            'Produced with the tip of the tongue near the teeth with a hissing sound',
        examples: ['سَلَام (peace)', 'سَمَاء (sky)'],
        makhraj: 'Tip of the tongue near the teeth',
        sifat:
            'Hams (Whispered), Rakhawah (Friction), Istifal (Lowered), Infitah (Open)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'ز',
        latin: 'Zain',
        audio: 'zain.mp3',
        forms: ['ﺯ', 'ﺰ', 'ﺰ', 'ز'],
        pronounciation:
            'Produced with the tip of the tongue near the teeth with vibration',
        examples: ['زَكَاة (charity)', 'زَيْت (oil)'],
        makhraj: 'Tip of the tongue near the teeth',
        sifat:
            'Jahr (Voiced), Rakhawah (Friction), Istifal (Lowered), Infitah (Open)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'ف',
        latin: 'Fa',
        audio: 'fa.mp3',
        forms: ['ﻓ', 'ﻔ', 'ﻒ', 'ف'],
        pronounciation: 'Produced with the bottom lip against the upper teeth',
        examples: ['فَتْح (opening)', 'فَجْر (dawn)'],
        makhraj: 'Bottom lip and upper teeth',
        sifat:
            'Hams (Whispered), Rakhawah (Friction), Istifal (Lowered), Infitah (Open)',
      ),
    ],

    // Level 8: Letters with special characteristics
    7: [
      AdvancedHijaiyahLetter(
        arabic: 'ر',
        latin: 'Ra',
        audio: 'ra.mp3',
        forms: ['ﺭ', 'ﺮ', 'ﺮ', 'ر'],
        pronounciation:
            'Produced by tapping the tip of the tongue on the roof of the mouth',
        examples: ['رَحْمَة (mercy)', 'رَسُول (messenger)'],
        makhraj: 'Tip of the tongue and the roof of the mouth',
        sifat:
            'Jahr (Voiced), Tawassut (Moderate), Istifal (Lowered), Infitah (Open), Takrir (Rolled)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'ن',
        latin: 'Nun',
        audio: 'nun.mp3',
        forms: ['ﻧ', 'ﻨ', 'ﻦ', 'ن'],
        pronounciation:
            'Produced with the tip of the tongue behind the front teeth with nasalization',
        examples: ['نُور (light)', 'نَهْر (river)'],
        makhraj: 'Tip of the tongue behind the front teeth',
        sifat:
            'Jahr (Voiced), Tawassut (Moderate), Istifal (Lowered), Infitah (Open), Ghunnah (Nasalization)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'م',
        latin: 'Mim',
        audio: 'mim.mp3',
        forms: ['ﻣ', 'ﻤ', 'ﻢ', 'م'],
        pronounciation:
            'Produced with the lips pressed together with nasalization',
        examples: ['مَسْجِد (mosque)', 'مَاء (water)'],
        makhraj: 'Lips pressed together',
        sifat:
            'Jahr (Voiced), Tawassut (Moderate), Istifal (Lowered), Infitah (Open), Ghunnah (Nasalization)',
      ),
    ],

    // Level 9: Advanced Harakat (vowel marks)
    8: [
      AdvancedHijaiyahLetter(
        arabic: 'بَ',
        latin: 'Ba (fathah)',
        audio: 'ba_fathah.mp3',
        forms: ['ﺑَ', 'ﺒَ', 'ﺐَ', 'بَ'],
        pronounciation: 'Ba with short "a" sound',
        examples: ['بَاب (door)', 'بَلَد (country)'],
        makhraj: 'Bi-labial (Both lips) with fathah',
        sifat:
            'Jahr (Voiced), Shiddah (Stop), Istifal (Lowered), Infitah (Open)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'بِ',
        latin: 'Bi (kasrah)',
        audio: 'bi_kasrah.mp3',
        forms: ['ﺑِ', 'ﺒِ', 'ﺐِ', 'بِ'],
        pronounciation: 'Ba with short "i" sound',
        examples: ['بِنْت (girl)', 'بِئْر (well)'],
        makhraj: 'Bi-labial (Both lips) with kasrah',
        sifat:
            'Jahr (Voiced), Shiddah (Stop), Istifal (Lowered), Infitah (Open)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'بُ',
        latin: 'Bu (dammah)',
        audio: 'bu_dammah.mp3',
        forms: ['ﺑُ', 'ﺒُ', 'ﺐُ', 'بُ'],
        pronounciation: 'Ba with short "u" sound',
        examples: ['بُسْتَان (garden)', 'بُرْج (tower)'],
        makhraj: 'Bi-labial (Both lips) with dammah',
        sifat:
            'Jahr (Voiced), Shiddah (Stop), Istifal (Lowered), Infitah (Open)',
      ),
    ],

    // Level 10: Advanced Tanwin and Special Rules
    9: [
      AdvancedHijaiyahLetter(
        arabic: 'بً',
        latin: 'Ban (fathatain)',
        audio: 'ban_fathatain.mp3',
        forms: ['ﺑً', 'ﺒً', 'ﺐً', 'بً'],
        pronounciation: 'Ba with double fathah, pronounced as "ban"',
        examples: ['كِتَابًا (a book)', 'شُكْرًا (thank you)'],
        makhraj: 'Bi-labial (Both lips) with fathatain',
        sifat:
            'Jahr (Voiced), Shiddah (Stop), Istifal (Lowered), Infitah (Open)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'بٍ',
        latin: 'Bin (kasratain)',
        audio: 'bin_kasratain.mp3',
        forms: ['ﺑٍ', 'ﺒٍ', 'ﺐٍ', 'بٍ'],
        pronounciation: 'Ba with double kasrah, pronounced as "bin"',
        examples: ['بِسْمِ (in the name of)', 'بِكَلِمَةٍ (with a word)'],
        makhraj: 'Bi-labial (Both lips) with kasratain',
        sifat:
            'Jahr (Voiced), Shiddah (Stop), Istifal (Lowered), Infitah (Open)',
      ),
      AdvancedHijaiyahLetter(
        arabic: 'بٌ',
        latin: 'Bun (dammatain)',
        audio: 'bun_dammatain.mp3',
        forms: ['ﺑٌ', 'ﺒٌ', 'ﺐٌ', 'بٌ'],
        pronounciation: 'Ba with double dammah, pronounced as "bun"',
        examples: ['كِتَابٌ (a book)', 'بَابٌ (a door)'],
        makhraj: 'Bi-labial (Both lips) with dammatain',
        sifat:
            'Jahr (Voiced), Shiddah (Stop), Istifal (Lowered), Infitah (Open)',
      ),
    ],
  };
}
