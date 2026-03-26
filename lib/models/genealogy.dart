import 'localized_text.dart';

class GenealogyEntry {
  const GenealogyEntry({
    required this.label,
    this.characterId,
  });

  final LocalizedText label;
  final String? characterId;

  Map<String, dynamic> toMap() => {
        'label': label.toMap(),
        'character_id': characterId,
      };

  factory GenealogyEntry.fromMap(Map<String, dynamic> data) {
    return GenealogyEntry(
      label: LocalizedText.fromMap(
        (data['label'] as Map<String, dynamic>? ?? {}),
      ),
      characterId: data['character_id'] as String?,
    );
  }
}

class Genealogy {
  const Genealogy({
    required this.id,
    required this.title,
    required this.description,
    required this.rootCharacterId,
    required this.entries,
  });

  final String id;
  final LocalizedText title;
  final LocalizedText description;
  final String rootCharacterId;
  final List<GenealogyEntry> entries;

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title.toMap(),
        'description': description.toMap(),
        'root_character_id': rootCharacterId,
        'entries': entries.map((entry) => entry.toMap()).toList(),
      };

  factory Genealogy.fromMap(Map<String, dynamic> data) {
    return Genealogy(
      id: data['id'] as String? ?? '',
      title: LocalizedText.fromMap(
        (data['title'] as Map<String, dynamic>? ?? {}),
      ),
      description: LocalizedText.fromMap(
        (data['description'] as Map<String, dynamic>? ?? {}),
      ),
      rootCharacterId: data['root_character_id'] as String? ?? '',
      entries: (data['entries'] as List<dynamic>? ?? [])
          .map((item) => GenealogyEntry.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList(),
    );
  }
}
