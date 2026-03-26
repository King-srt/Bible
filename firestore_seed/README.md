# Content Workflow

Gunakan file ini sebagai acuan saat mengisi data cerita dan karakter.

## File Utama

- `firestore_seed/stories.json`
  Tulis data story final yang akan di-seed ke Firestore.
- `firestore_seed/characters.json`
  Tulis data character final yang akan di-seed ke Firestore.

## File Template

- `firestore_seed/stories.template.jsonc`
  Template story dengan komentar `//` penjelasan setiap field.
- `firestore_seed/characters.template.jsonc`
  Template character dengan komentar `//` penjelasan setiap field.

## Cara Kerja Yang Disarankan

1. Tulis story dulu di `stories.template.jsonc`, lalu pindahkan versi finalnya ke `stories.json`.
2. Dari setiap story, catat semua `character_ids` yang benar-benar muncul.
3. Lengkapi data tokoh itu di `characters.template.jsonc`, lalu pindahkan versi finalnya ke `characters.json`.
4. Pastikan `id` konsisten di story, character, Firestore doc id, dan nama file gambar.

## Aturan Id

- Story: `story_<nama>`
- Character: `char_<nama>`

Contoh:

- `story_daniel_lions`
- `char_daniel`

## Aturan Gambar

- Story image: `pictures/<storyId>.jpeg`
- Character image: `pictures/<characterId>.jpeg`

Contoh:

- `pictures/story_daniel_lions.jpeg`
- `pictures/char_daniel.jpeg`

## Catatan Penting

- File `.json` tidak mendukung komentar `//`.
- Karena itu, komentar penjelasan hanya ditaruh di file `.jsonc` template.
- File yang dipakai untuk seed tetap harus valid JSON tanpa komentar.


## Content Meta

- `firestore_seed/content_meta.json`
  Simpan versi konten untuk `stories` dan `characters`.
- Gunakan format versi seperti `v1.0.0`.
- Saat isi `stories` berubah, naikkan `content_meta/stories.version`.
- Saat isi `characters` berubah, naikkan `content_meta/characters.version`.

Contoh:

```json
[
  { "id": "stories", "version": "v1.0.0" },
  { "id": "characters", "version": "v1.0.0" }
]
```
