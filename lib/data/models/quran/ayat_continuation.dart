class AyatContinuation {
  final String surahName;
  final int surahNumber;
  final int startAyat;
  final String startAyatText;
  final String continueAyatText;
  final List<String> options;
  final int correctOptionIndex;
  final int difficulty; // 1-10 scale

  AyatContinuation({
    required this.surahName,
    required this.surahNumber,
    required this.startAyat,
    required this.startAyatText,
    required this.continueAyatText,
    required this.options,
    required this.correctOptionIndex,
    required this.difficulty,
  });
}
