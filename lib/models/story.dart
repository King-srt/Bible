import 'package:cloud_firestore/cloud_firestore.dart';

import 'localized_text.dart';
import 'testament.dart';

class Story {
  const Story({
    required this.id,
    required this.title,
    required this.content,
    required this.testament,
    required this.characterIds,
    required this.tags,
    required this.scriptureReferences,
  });

  final String id;
  final LocalizedText title;
  final LocalizedText content;
  final Testament testament;
  final List<String> characterIds;
  final List<String> tags;
  final LocalizedStringList scriptureReferences;

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title.toMap(),
        'content': content.toMap(),
        'testament': testament.value,
        'character_ids': characterIds,
        'tags': tags,
        'scripture_references': scriptureReferences.toMap(),
      };

  factory Story.fromMap(Map<String, dynamic> data, {String? fallbackId}) {
    return Story(
      id: (data['id'] as String?) ?? fallbackId ?? '',
      title: LocalizedText.fromMap(
        (data['title'] as Map<String, dynamic>? ?? {}),
      ),
      content: LocalizedText.fromMap(
        (data['content'] as Map<String, dynamic>? ?? {}),
      ),
      testament: TestamentX.fromString((data['testament'] as String? ?? 'old')),
      characterIds: (data['character_ids'] as List<dynamic>? ?? []).cast<String>(),
      tags: (data['tags'] as List<dynamic>? ?? []).cast<String>(),
      scriptureReferences: LocalizedStringList.fromMap(
        (data['scripture_references'] as Map<String, dynamic>? ?? {}),
      ),
    );
  }

  factory Story.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Story.fromMap(data, fallbackId: doc.id);
  }
}
