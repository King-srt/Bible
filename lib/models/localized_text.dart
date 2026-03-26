import 'package:flutter/widgets.dart';

class LocalizedText {
  const LocalizedText({required this.en, required this.id});

  final String en;
  final String id;

  String forLocale(Locale locale) => locale.languageCode == 'id' ? id : en;

  Map<String, dynamic> toMap() => {
        'en': en,
        'id': id,
      };

  factory LocalizedText.fromMap(Map<String, dynamic> map) {
    return LocalizedText(
      en: map['en'] as String? ?? '',
      id: map['id'] as String? ?? '',
    );
  }
}

class LocalizedStringList {
  const LocalizedStringList({required this.en, required this.id});

  final List<String> en;
  final List<String> id;

  List<String> forLocale(Locale locale) => locale.languageCode == 'id' ? id : en;

  Map<String, dynamic> toMap() => {
        'en': en,
        'id': id,
      };

  factory LocalizedStringList.fromMap(Map<String, dynamic> map) {
    final enList = (map['en'] as List<dynamic>? ?? []).cast<String>();
    final idList = (map['id'] as List<dynamic>? ?? []).cast<String>();
    return LocalizedStringList(en: enList, id: idList);
  }
}
