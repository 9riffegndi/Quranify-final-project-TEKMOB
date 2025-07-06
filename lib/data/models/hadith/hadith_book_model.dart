class HadithBook {
  final String name;
  final String id;
  final int available;

  HadithBook({required this.name, required this.id, required this.available});

  factory HadithBook.fromJson(Map<String, dynamic> json) {
    return HadithBook(
      name: json['name'],
      id: json['id'],
      available: json['available'],
    );
  }
}

class HadithBookListResponse {
  final int code;
  final String message;
  final List<HadithBook> data;
  final bool error;

  HadithBookListResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.error,
  });

  factory HadithBookListResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'];
    return HadithBookListResponse(
      code: json['code'],
      message: json['message'],
      data: dataList.map((e) => HadithBook.fromJson(e)).toList(),
      error: json['error'],
    );
  }
}
