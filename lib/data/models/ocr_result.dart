class OcrResult {
  final String? sum;
  final DateTime? date;
  final String? storeName;
  final String? fullText;

  OcrResult({this.sum, this.date, this.storeName, this.fullText});

  OcrResult copyWith({String? sum, DateTime? date, String? storeName}) {
    return OcrResult(
      sum: sum ?? this.sum,
      date: date ?? this.date,
      storeName: storeName ?? this.storeName,
    );
  }
}