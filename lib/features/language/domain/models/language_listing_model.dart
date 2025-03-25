import 'dart:convert';

LanguageListResponseModel languageListResponseModelFromJson(String str) =>
    LanguageListResponseModel.fromJson(json.decode(str));

class LanguageListResponseModel {
  bool success;
  String message;
  List<LanguageList> data;

  LanguageListResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LanguageListResponseModel.fromJson(Map<String, dynamic> json) {
    return LanguageListResponseModel(
      success: json["success"],
      message: json["message"],
      data: List<LanguageList>.from(
          json["data"]['data'].map((x) => LanguageList.fromJson(x))),
    );
  }
}

class LanguageList {
  String lang;
  String name;
  String flag;

  LanguageList({
    required this.lang,
    required this.name,
    required this.flag,
  });

  factory LanguageList.fromJson(Map<String, dynamic> json) => LanguageList(
        lang: json["lang"],
        name: json["name"],
          flag: json["flag"]??'',
      );
}

class LocaleLanguageList {
  String lang;
  String name;
  String flag;

  LocaleLanguageList({
    required this.lang,
    required this.name,
     required this.flag,
  });

  factory LocaleLanguageList.fromJson(Map<String, dynamic> json) =>
      LocaleLanguageList(
        lang: json["lang"] ?? '',
        name: json["name"] ?? '',
         flag: json["flag"] ?? '',
      );
}
