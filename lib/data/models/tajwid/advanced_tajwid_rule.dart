/// Advanced model class for Tajwid rules in the General mode
class AdvancedTajwidRule {
  final String name;
  final String arabicName;
  final String description;
  final String detailedExplanation;
  final List<String> examples;
  final List<String> arabicExamples;
  final String condition;
  final String pronunciation;
  final String category; // Nun Sakinah, Mim Sakinah, Qalqalah, etc.
  final String color; // Color coding for highlighting
  final List<String> letters; // Letters involved in the rule
  final String audio; // Audio file path
  final int difficulty; // 1-10 difficulty level

  AdvancedTajwidRule({
    required this.name,
    required this.arabicName,
    required this.description,
    required this.detailedExplanation,
    required this.examples,
    required this.arabicExamples,
    required this.condition,
    required this.pronunciation,
    required this.category,
    required this.color,
    required this.letters,
    required this.audio,
    required this.difficulty,
  });

  // Serialization methods
  Map<String, dynamic> toJson() => {
    'name': name,
    'arabicName': arabicName,
    'description': description,
    'detailedExplanation': detailedExplanation,
    'examples': examples,
    'arabicExamples': arabicExamples,
    'condition': condition,
    'pronunciation': pronunciation,
    'category': category,
    'color': color,
    'letters': letters,
    'audio': audio,
    'difficulty': difficulty,
  };

  factory AdvancedTajwidRule.fromJson(Map<String, dynamic> json) =>
      AdvancedTajwidRule(
        name: json['name'] as String,
        arabicName: json['arabicName'] as String,
        description: json['description'] as String,
        detailedExplanation: json['detailedExplanation'] as String,
        examples: List<String>.from(json['examples'] as List),
        arabicExamples: List<String>.from(json['arabicExamples'] as List),
        condition: json['condition'] as String,
        pronunciation: json['pronunciation'] as String,
        category: json['category'] as String,
        color: json['color'] as String,
        letters: List<String>.from(json['letters'] as List),
        audio: json['audio'] as String,
        difficulty: json['difficulty'] as int,
      );

  // Create a copy with modified fields
  AdvancedTajwidRule copyWith({
    String? name,
    String? arabicName,
    String? description,
    String? detailedExplanation,
    List<String>? examples,
    List<String>? arabicExamples,
    String? condition,
    String? pronunciation,
    String? category,
    String? color,
    List<String>? letters,
    String? audio,
    int? difficulty,
  }) {
    return AdvancedTajwidRule(
      name: name ?? this.name,
      arabicName: arabicName ?? this.arabicName,
      description: description ?? this.description,
      detailedExplanation: detailedExplanation ?? this.detailedExplanation,
      examples: examples ?? this.examples,
      arabicExamples: arabicExamples ?? this.arabicExamples,
      condition: condition ?? this.condition,
      pronunciation: pronunciation ?? this.pronunciation,
      category: category ?? this.category,
      color: color ?? this.color,
      letters: letters ?? this.letters,
      audio: audio ?? this.audio,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
