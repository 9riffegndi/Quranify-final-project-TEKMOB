class Hadith {
  final int number;
  final String arab;
  final String id;

  Hadith({required this.number, required this.arab, required this.id});

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(number: json['number'], arab: json['arab'], id: json['id']);
  }
}

class HadithResponse {
  final int code;
  final String message;
  final HadithData data;
  final bool error;

  HadithResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.error,
  });

  factory HadithResponse.fromJson(Map<String, dynamic> json) {
    return HadithResponse(
      code: json['code'],
      message: json['message'],
      data: HadithData.fromJson(json['data']),
      error: json['error'] ?? false,
    );
  }
}

class HadithData {
  final String name;
  final String id;
  final int available;
  final int? requested;
  final List<Hadith>? hadiths;
  final HadithContent? contents;

  HadithData({
    required this.name,
    required this.id,
    required this.available,
    this.requested,
    this.hadiths,
    this.contents,
  });

  factory HadithData.fromJson(Map<String, dynamic> json) {
    List<Hadith>? hadithsList;
    if (json.containsKey('hadiths')) {
      final List<dynamic> hadithsJson = json['hadiths'];
      hadithsList = hadithsJson.map((e) => Hadith.fromJson(e)).toList();
    }

    HadithContent? hadithContent;
    if (json.containsKey('contents')) {
      hadithContent = HadithContent.fromJson(json['contents']);
    }

    return HadithData(
      name: json['name'],
      id: json['id'],
      available: json['available'],
      requested: json['requested'],
      hadiths: hadithsList,
      contents: hadithContent,
    );
  }
}

class HadithContent {
  final int number;
  final String arab;
  final String id;

  HadithContent({required this.number, required this.arab, required this.id});

  factory HadithContent.fromJson(Map<String, dynamic> json) {
    return HadithContent(
      number: json['number'],
      arab: json['arab'],
      id: json['id'],
    );
  }
}
