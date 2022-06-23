import 'dart:convert';

class GenerateUrlResponse {
  GenerateUrlResponse({
    required this.codError,
    required this.message,
  });

  int codError;
  String message;

  factory GenerateUrlResponse.fromJson(String str) => GenerateUrlResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GenerateUrlResponse.fromMap(Map<String, dynamic> json) => GenerateUrlResponse(
    codError: json["codError"],
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "codError": codError,
    "message": message,
  };
}


class GenerateUrlResponse2 {
  GenerateUrlResponse2({
    required this.fileUrl,
    required this.uploadUrl,
  });

  String fileUrl;
  String uploadUrl;

  factory GenerateUrlResponse2.fromJson(String str) => GenerateUrlResponse2.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GenerateUrlResponse2.fromMap(Map<String, dynamic> json) => GenerateUrlResponse2(
    fileUrl: json["fileUrl"],
    uploadUrl: json["uploadUrl"],
  );

  Map<String, dynamic> toMap() => {
    "fileUrl": fileUrl,
    "uploadUrl": uploadUrl,
  };
}
