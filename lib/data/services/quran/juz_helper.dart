class JuzHelper {
  // A map that associates surah numbers with their corresponding Juz
  // This is a simplified mapping of which Juz each surah primarily belongs to
  static final Map<int, List<int>> _surahToJuzMap = {
    1: [1], // Al-Fatihah is in Juz 1
    2: [1, 2, 3], // Al-Baqarah spans Juz 1, 2, 3
    3: [3, 4], // Ali 'Imran spans Juz 3, 4
    4: [4, 5, 6], // An-Nisa spans Juz 4, 5, 6
    5: [6, 7], // Al-Ma'idah spans Juz 6, 7
    6: [7, 8], // Al-An'am spans Juz 7, 8
    7: [8, 9], // Al-A'raf spans Juz 8, 9
    8: [9, 10], // Al-Anfal spans Juz 9, 10
    9: [10, 11], // At-Tawbah spans Juz 10, 11
    10: [11], // Yunus is in Juz 11
    11: [11, 12], // Hud spans Juz 11, 12
    12: [12, 13], // Yusuf spans Juz 12, 13
    13: [13], // Ar-Ra'd is in Juz 13
    14: [13], // Ibrahim is in Juz 13
    15: [14], // Al-Hijr is in Juz 14
    16: [14], // An-Nahl is in Juz 14
    17: [15], // Al-Isra' is in Juz 15
    18: [15, 16], // Al-Kahf spans Juz 15, 16
    19: [16], // Maryam is in Juz 16
    20: [16], // Ta Ha is in Juz 16
    21: [17], // Al-Anbiya' is in Juz 17
    22: [17], // Al-Hajj is in Juz 17
    23: [18], // Al-Mu'minun is in Juz 18
    24: [18], // An-Nur is in Juz 18
    25: [18, 19], // Al-Furqan spans Juz 18, 19
    26: [19], // Ash-Shu'ara' is in Juz 19
    27: [19, 20], // An-Naml spans Juz 19, 20
    28: [20], // Al-Qasas is in Juz 20
    29: [20, 21], // Al-'Ankabut spans Juz 20, 21
    30: [21], // Ar-Rum is in Juz 21
    31: [21], // Luqman is in Juz 21
    32: [21], // As-Sajdah is in Juz 21
    33: [21, 22], // Al-Ahzab spans Juz 21, 22
    34: [22], // Saba' is in Juz 22
    35: [22], // Fatir is in Juz 22
    36: [22, 23], // Ya Sin spans Juz 22, 23
    37: [23], // As-Saffat is in Juz 23
    38: [23], // Sad is in Juz 23
    39: [23, 24], // Az-Zumar spans Juz 23, 24
    40: [24], // Ghafir is in Juz 24
    41: [24, 25], // Fussilat spans Juz 24, 25
    42: [25], // Ash-Shura is in Juz 25
    43: [25], // Az-Zukhruf is in Juz 25
    44: [25], // Ad-Dukhan is in Juz 25
    45: [25], // Al-Jathiyah is in Juz 25
    46: [26], // Al-Ahqaf is in Juz 26
    47: [26], // Muhammad is in Juz 26
    48: [26], // Al-Fath is in Juz 26
    49: [26], // Al-Hujurat is in Juz 26
    50: [26], // Qaf is in Juz 26
    51: [26, 27], // Adh-Dhariyat spans Juz 26, 27
    52: [27], // At-Tur is in Juz 27
    53: [27], // An-Najm is in Juz 27
    54: [27], // Al-Qamar is in Juz 27
    55: [27], // Ar-Rahman is in Juz 27
    56: [27], // Al-Waqi'ah is in Juz 27
    57: [27], // Al-Hadid is in Juz 27
    58: [28], // Al-Mujadilah is in Juz 28
    59: [28], // Al-Hashr is in Juz 28
    60: [28], // Al-Mumtahanah is in Juz 28
    61: [28], // As-Saff is in Juz 28
    62: [28], // Al-Jumu'ah is in Juz 28
    63: [28], // Al-Munafiqun is in Juz 28
    64: [28], // At-Taghabun is in Juz 28
    65: [28], // At-Talaq is in Juz 28
    66: [28], // At-Tahrim is in Juz 28
    67: [29], // Al-Mulk is in Juz 29
    68: [29], // Al-Qalam is in Juz 29
    69: [29], // Al-Haqqah is in Juz 29
    70: [29], // Al-Ma'arij is in Juz 29
    71: [29], // Nuh is in Juz 29
    72: [29], // Al-Jinn is in Juz 29
    73: [29], // Al-Muzzammil is in Juz 29
    74: [29], // Al-Muddaththir is in Juz 29
    75: [29], // Al-Qiyamah is in Juz 29
    76: [29], // Al-Insan is in Juz 29
    77: [29], // Al-Mursalat is in Juz 29
    78: [30], // An-Naba' is in Juz 30
    79: [30], // An-Nazi'at is in Juz 30
    80: [30], // 'Abasa is in Juz 30
    81: [30], // At-Takwir is in Juz 30
    82: [30], // Al-Infitar is in Juz 30
    83: [30], // Al-Mutaffifin is in Juz 30
    84: [30], // Al-Inshiqaq is in Juz 30
    85: [30], // Al-Buruj is in Juz 30
    86: [30], // At-Tariq is in Juz 30
    87: [30], // Al-A'la is in Juz 30
    88: [30], // Al-Ghashiyah is in Juz 30
    89: [30], // Al-Fajr is in Juz 30
    90: [30], // Al-Balad is in Juz 30
    91: [30], // Ash-Shams is in Juz 30
    92: [30], // Al-Lail is in Juz 30
    93: [30], // Ad-Duha is in Juz 30
    94: [30], // Ash-Sharh is in Juz 30
    95: [30], // At-Tin is in Juz 30
    96: [30], // Al-'Alaq is in Juz 30
    97: [30], // Al-Qadr is in Juz 30
    98: [30], // Al-Bayyinah is in Juz 30
    99: [30], // Az-Zalzalah is in Juz 30
    100: [30], // Al-'Adiyat is in Juz 30
    101: [30], // Al-Qari'ah is in Juz 30
    102: [30], // At-Takathur is in Juz 30
    103: [30], // Al-'Asr is in Juz 30
    104: [30], // Al-Humazah is in Juz 30
    105: [30], // Al-Fil is in Juz 30
    106: [30], // Quraish is in Juz 30
    107: [30], // Al-Ma'un is in Juz 30
    108: [30], // Al-Kawthar is in Juz 30
    109: [30], // Al-Kafirun is in Juz 30
    110: [30], // An-Nasr is in Juz 30
    111: [30], // Al-Masad is in Juz 30
    112: [30], // Al-Ikhlas is in Juz 30
    113: [30], // Al-Falaq is in Juz 30
    114: [30], // An-Nas is in Juz 30
  };

  // Get Juz numbers for a specific surah
  static List<int> getJuzForSurah(int surahNumber) {
    if (_surahToJuzMap.containsKey(surahNumber)) {
      return _surahToJuzMap[surahNumber]!;
    }
    return [];
  }

  // Get a formatted string of Juz numbers for display
  static String getJuzDisplayText(int surahNumber) {
    final juzNumbers = getJuzForSurah(surahNumber);
    if (juzNumbers.isEmpty) {
      return "";
    } else if (juzNumbers.length == 1) {
      return "Juz ${juzNumbers[0]}";
    } else {
      return "Juz ${juzNumbers.join(", ")}";
    }
  }
}
