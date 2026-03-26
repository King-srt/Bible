import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

const _scopes = <String>[
  'https://www.googleapis.com/auth/datastore',
  'https://www.googleapis.com/auth/cloud-platform',
];

Future<void> main(List<String> args) async {
  final config = _parseArgs(args);

  if (config == null) {
    _printUsage();
    exitCode = 64;
    return;
  }

  final serviceAccountFile = File(config.serviceAccountPath);
  if (!serviceAccountFile.existsSync()) {
    stderr.writeln('Service account file not found: ${config.serviceAccountPath}');
    exitCode = 66;
    return;
  }

  final storiesFile = File(config.storiesPath);
  final charactersFile = File(config.charactersPath);
  final contentMetaFile = File(config.contentMetaPath);

  if (!storiesFile.existsSync() || !charactersFile.existsSync() || !contentMetaFile.existsSync()) {
    stderr.writeln('Seed files not found.');
    stderr.writeln(
      'Expected: ${storiesFile.path}, ${charactersFile.path}, and ${contentMetaFile.path}',
    );
    exitCode = 66;
    return;
  }

  final credentials = ServiceAccountCredentials.fromJson(
    jsonDecode(await serviceAccountFile.readAsString()) as Map<String, dynamic>,
  );

  final stories = _decodeSeedArray(await storiesFile.readAsString());
  final characters = _decodeSeedArray(await charactersFile.readAsString());
  final contentMeta = _decodeSeedArray(await contentMetaFile.readAsString());

  final client = await clientViaServiceAccount(credentials, _scopes);

  try {
    stdout.writeln('Seeding stories...');
    await _uploadCollection(
      client: client,
      projectId: config.projectId,
      collection: 'stories',
      items: stories,
    );

    stdout.writeln('Seeding characters...');
    await _uploadCollection(
      client: client,
      projectId: config.projectId,
      collection: 'characters',
      items: characters,
    );

    stdout.writeln('Seeding content_meta...');
    await _uploadCollection(
      client: client,
      projectId: config.projectId,
      collection: 'content_meta',
      items: contentMeta,
    );

    stdout.writeln('Done. Firestore seed completed successfully.');
  } finally {
    client.close();
  }
}

Future<void> _uploadCollection({
  required http.Client client,
  required String projectId,
  required String collection,
  required List<Map<String, dynamic>> items,
}) async {
  for (final item in items) {
    final id = item['id'] as String?;
    if (id == null || id.isEmpty) {
      throw StateError('Missing non-empty id for collection $collection');
    }

    final uri = Uri.parse(
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$collection/$id',
    );

    final body = jsonEncode({
      'fields': _encodeMap(item),
    });

    final response = await client.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'Failed to upload $collection/$id (${response.statusCode}): ${response.body}',
      );
    }

    stdout.writeln('Uploaded $collection/$id');
  }
}

List<Map<String, dynamic>> _decodeSeedArray(String raw) {
  final decoded = jsonDecode(raw);
  if (decoded is! List) {
    throw const FormatException('Seed file must contain a top-level JSON array.');
  }

  return decoded.map((item) {
    if (item is! Map<String, dynamic>) {
      throw const FormatException('Each seed item must be a JSON object.');
    }
    return item;
  }).toList();
}

Map<String, dynamic> _encodeMap(Map<String, dynamic> value) {
  final result = <String, dynamic>{};
  value.forEach((key, mapValue) {
    result[key] = _encodeValue(mapValue);
  });
  return result;
}

Map<String, dynamic> _encodeValue(dynamic value) {
  if (value == null) {
    return {'nullValue': null};
  }
  if (value is String) {
    return {'stringValue': value};
  }
  if (value is bool) {
    return {'booleanValue': value};
  }
  if (value is int) {
    return {'integerValue': value.toString()};
  }
  if (value is double) {
    return {'doubleValue': value};
  }
  if (value is List) {
    return {
      'arrayValue': {
        'values': value.map(_encodeValue).toList(),
      },
    };
  }
  if (value is Map<String, dynamic>) {
    return {
      'mapValue': {
        'fields': _encodeMap(value),
      },
    };
  }
  throw UnsupportedError('Unsupported Firestore seed value type: ${value.runtimeType}');
}

_SeedConfig? _parseArgs(List<String> args) {
  String? projectId;
  String? serviceAccountPath;
  var storiesPath = 'firestore_seed/stories.json';
  var charactersPath = 'firestore_seed/characters.json';
  var contentMetaPath = 'firestore_seed/content_meta.json';

  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--project-id':
        projectId = _readValue(args, ++i, '--project-id');
        break;
      case '--service-account':
        serviceAccountPath = _readValue(args, ++i, '--service-account');
        break;
      case '--stories':
        storiesPath = _readValue(args, ++i, '--stories') ?? storiesPath;
        break;
      case '--characters':
        charactersPath = _readValue(args, ++i, '--characters') ?? charactersPath;
        break;
      case '--content-meta':
        contentMetaPath = _readValue(args, ++i, '--content-meta') ?? contentMetaPath;
        break;
      case '--help':
      case '-h':
        return null;
      default:
        stderr.writeln('Unknown argument: ${args[i]}');
        return null;
    }
  }

  projectId ??= Platform.environment['FIREBASE_PROJECT_ID'];
  serviceAccountPath ??= Platform.environment['GOOGLE_APPLICATION_CREDENTIALS'];

  if (projectId == null || serviceAccountPath == null) {
    return null;
  }

  return _SeedConfig(
    projectId: projectId,
    serviceAccountPath: serviceAccountPath,
    storiesPath: storiesPath,
    charactersPath: charactersPath,
    contentMetaPath: contentMetaPath,
  );
}

String? _readValue(List<String> args, int index, String flag) {
  if (index >= args.length) {
    stderr.writeln('Missing value for $flag');
    return null;
  }
  return args[index];
}

void _printUsage() {
  stdout.writeln('Usage: dart run tool/seed_firestore.dart --project-id <projectId> --service-account <path>');
  stdout.writeln('Optional: --stories <path> --characters <path> --content-meta <path>');
  stdout.writeln('You may also set FIREBASE_PROJECT_ID and GOOGLE_APPLICATION_CREDENTIALS.');
}

class _SeedConfig {
  const _SeedConfig({
    required this.projectId,
    required this.serviceAccountPath,
    required this.storiesPath,
    required this.charactersPath,
    required this.contentMetaPath,
  });

  final String projectId;
  final String serviceAccountPath;
  final String storiesPath;
  final String charactersPath;
  final String contentMetaPath;
}
