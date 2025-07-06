/// Model class for Tajwid rule data used in the Tajwid game
class TajwidRule {
  final String name;
  final String type; // idgham, ikhfa, iqlab, idzhar
  final String arabicText;
  final String description;
  final String example;
  final List<String> options; // Options for multiple choice questions

  TajwidRule({
    required this.name,
    required this.type,
    required this.arabicText,
    required this.description,
    required this.example,
    required this.options,
  });

  // Factory method to create from JSON data
  factory TajwidRule.fromJson(Map<String, dynamic> json) {
    return TajwidRule(
      name: json['name'] as String,
      type: json['type'] as String,
      arabicText: json['arabicText'] as String,
      description: json['description'] as String,
      example: json['example'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  // Convert object to JSON for storage
  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    'arabicText': arabicText,
    'description': description,
    'example': example,
    'options': options,
  };
}
