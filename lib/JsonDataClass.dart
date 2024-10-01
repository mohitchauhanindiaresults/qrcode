
class ExamResult {
  String? backgroundImageUrl;
  String? studentImagePath;
  String? signatureUrl;
  String? base64ImageQRCode;
  String? base64Image;
  Map<String, String?> values = {};

  // Constructor
  ExamResult({
    this.backgroundImageUrl,
    this.studentImagePath,
    this.signatureUrl,
    this.base64ImageQRCode,
    this.base64Image,
  });

  // Factory constructor for JSON deserialization
  factory ExamResult.fromJson(Map<String, dynamic> json) {
    ExamResult result = ExamResult(
      backgroundImageUrl: json['BackgroundImageUrl'],
      studentImagePath: json['StudentImagePath'],
      signatureUrl: json['SignatureUrl'],
      base64ImageQRCode: json['Base64ImageQRCode'],
      base64Image: json['Base64Image'],
    );

    // Dynamically add all "C" properties to the values map
    for (int i = 1; i <= 245; i++) {
      result.values['C$i'] = json['C$i']?.toString();
    }

    return result;
  }
}

class JsonDataClass {
  ExamResult? examResult;
  String? base64ofStudentImage;

  // Constructor
  JsonDataClass({this.examResult, this.base64ofStudentImage});

  // Factory constructor for JSON deserialization
  factory JsonDataClass.fromJson(Map<String, dynamic> json) {
    return JsonDataClass(
      examResult: json['examResult'] != null ? ExamResult.fromJson(json['examResult']) : null,
      base64ofStudentImage: json['Base64ofStudentImage'],
    );
  }
}
