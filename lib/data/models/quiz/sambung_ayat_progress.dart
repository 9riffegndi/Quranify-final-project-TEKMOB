class SambungAyatProgress {
  final int level;
  final int stars; // 0-3 stars based on performance
  final bool unlocked;

  SambungAyatProgress({
    required this.level,
    this.stars = 0,
    this.unlocked = false,
  });

  SambungAyatProgress.initial(int level)
    : level = level,
      stars = 0,
      unlocked = level == 0; // Level 0 is unlocked by default

  SambungAyatProgress copyWith({int? stars, bool? unlocked}) {
    return SambungAyatProgress(
      level: this.level,
      stars: stars ?? this.stars,
      unlocked: unlocked ?? this.unlocked,
    );
  }

  Map<String, dynamic> toJson() {
    return {'level': level, 'stars': stars, 'unlocked': unlocked};
  }

  factory SambungAyatProgress.fromJson(Map<String, dynamic> json) {
    return SambungAyatProgress(
      level: json['level'],
      stars: json['stars'],
      unlocked: json['unlocked'],
    );
  }
}
