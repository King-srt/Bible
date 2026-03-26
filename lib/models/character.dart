import 'package:cloud_firestore/cloud_firestore.dart';

import 'localized_text.dart';
import 'testament.dart';

class BibleCharacter {
  const BibleCharacter({
    required this.id,
    required this.name,
    required this.testament,
    required this.summary,
    required this.strengths,
    required this.weaknesses,
    required this.relatedCharacterIds,
    required this.identity,
    required this.lifeSpan,
  });

  final String id;
  final LocalizedText name;
  final Testament testament;
  final LocalizedText summary;
  final LocalizedStringList strengths;
  final LocalizedStringList weaknesses;
  final List<String> relatedCharacterIds;
  final LocalizedText identity;
  final LocalizedText lifeSpan;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name.toMap(),
        'testament': testament.value,
        'summary': summary.toMap(),
        'strengths': strengths.toMap(),
        'weaknesses': weaknesses.toMap(),
        'related_character_ids': relatedCharacterIds,
        'identity': identity.toMap(),
        'life_span': lifeSpan.toMap(),
      };

  factory BibleCharacter.fromMap(Map<String, dynamic> data, {String? fallbackId}) {
    return BibleCharacter(
      id: (data['id'] as String?) ?? fallbackId ?? '',
      name: LocalizedText.fromMap(
        (data['name'] as Map<String, dynamic>? ?? {}),
      ),
      testament: TestamentX.fromString((data['testament'] as String? ?? 'old')),
      summary: LocalizedText.fromMap(
        (data['summary'] as Map<String, dynamic>? ?? {}),
      ),
      strengths: LocalizedStringList.fromMap(
        (data['strengths'] as Map<String, dynamic>? ?? {}),
      ),
      weaknesses: LocalizedStringList.fromMap(
        (data['weaknesses'] as Map<String, dynamic>? ?? {}),
      ),
      relatedCharacterIds:
          (data['related_character_ids'] as List<dynamic>? ?? []).cast<String>(),
      identity: LocalizedText.fromMap(
        (data['identity'] as Map<String, dynamic>? ?? {}),
      ),
      lifeSpan: LocalizedText.fromMap(
        (data['life_span'] as Map<String, dynamic>? ?? {}),
      ),
    );
  }

  factory BibleCharacter.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return BibleCharacter.fromMap(data, fallbackId: doc.id);
  }
}
