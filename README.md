# Bible Story App

Bible Story App is a Flutter mobile application for reading Bible stories, exploring characters, and saving personal bookmarks with bilingual support.

## Overview

This project is built with Flutter and Firebase and is currently structured as a content-first reading app with local-first caching.

Core ideas:
- read Bible stories in English and Indonesian
- explore Bible characters and their details
- save bookmarks per user session
- keep story content available offline after it has been cached
- sync content updates from Firestore when a newer version is available

## Current Features

- Home screen with featured story and quick explore actions
- Story list for Old Testament and New Testament
- Story detail with:
  - full content
  - scripture references
  - related characters
  - bookmark action
- Character list and character detail with:
  - summary
  - strengths
  - weaknesses
  - identity
  - life span
  - related stories
- Genealogy of Jesus screen with a minimal Matthew 1 lineage flow
- Search for stories and characters
- Local-first content loading with Firestore sync by semantic version
- Anonymous Firebase Authentication
- Per-user bookmark sync with Firestore
- English / Indonesian localization

## Tech Stack

- Flutter
- Riverpod
- GoRouter
- Firebase Authentication
- Cloud Firestore
- SharedPreferences

## Content Architecture

The app uses a local-first content approach:

1. bundled JSON is included in the app as seed content
2. content is cached locally on device
3. Firestore acts as the remote source of truth
4. app checks `content_meta` versions such as `v1.0.0`
5. local content is refreshed only when remote content is newer

This keeps the app responsive while still allowing content updates without changing app code.

## Project Structure

```text
lib/
  core/
  data/
  l10n/
  models/
  services/
  state/
  ui/
firestore_seed/
  stories.json
  characters.json
  genealogies.json
  content_meta.json
tool/
  seed_firestore.dart
docs/
  privacy-policy.md
  release-checklist.md
```

## Seed Content

Main seed files:
- `firestore_seed/stories.json`
- `firestore_seed/characters.json`
- `firestore_seed/genealogies.json`
- `firestore_seed/content_meta.json`

Template files with comments:
- `firestore_seed/stories.template.jsonc`
- `firestore_seed/characters.template.jsonc`
- `firestore_seed/genealogies.template.jsonc`

## Run Locally

```powershell
flutter pub get
flutter gen-l10n
flutter run
```

## Seed Firestore

Use the provided seed tool to upload content to Firestore.

```powershell
dart run tool/seed_firestore.dart --project-id <your-project-id> --service-account <path-to-service-account-json>
```

This uploads:
- `stories`
- `characters`
- `content_meta`

## Content Versioning

Content sync uses semantic versions stored in `content_meta`, for example:

```json
[
  { "id": "stories", "version": "v1.0.0" },
  { "id": "characters", "version": "v1.0.0" }
]
```

When content changes:
- update the relevant JSON file
- bump the relevant version
- seed Firestore again

## Notes

- Local images can be excluded from Git if needed.
- Firebase admin service account files must never be committed.
- Privacy and release preparation notes are in `docs/privacy-policy.md` and `docs/release-checklist.md`.

## Status

Current status: beta foundation / content-driven MVP.

The app is suitable for continued content production, internal testing, and further product refinement.
