class OcrResult {
  final String? sum;
  final DateTime? date;
  final String? storeName;
  final String? fullText;

  OcrResult({this.sum, this.date, this.storeName, this.fullText});

  @override
  String toString() =>
      'OcrResult(sum: $sum, date: $date, storeName: $storeName)';

  OcrResult copyWith({String? sum, DateTime? date, String? storeName}) =>
      OcrResult(
        sum: sum ?? this.sum,
        date: date ?? this.date,
        storeName: storeName ?? this.storeName,
      );
}
