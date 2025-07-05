class ArabicNumbers {
  // Map to convert regular numbers to Arabic numbers
  static const Map<String, String> _arabicNumbers = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
  };

  /// Converts a number to its Arabic representation
  static String convertToArabic(int number) {
    String numString = number.toString();
    String arabicString = '';

    for (int i = 0; i < numString.length; i++) {
      arabicString += _arabicNumbers[numString[i]] ?? numString[i];
    }

    return arabicString;
  }
}
