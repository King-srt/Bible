import json
import os

# ===== CONFIG =====
CHAR_PATH = os.path.join("firestore_seed", "characters.json")
LIFESPAN_PATH = "temp_char.json"
OUTPUT_PATH = os.path.join("firestore_seed", "characters_merged.json")

STRICT_MODE = False  # optional

# ===== LOAD DATA =====
with open(CHAR_PATH, "r", encoding="utf-8") as f:
    characters = json.load(f)

with open(LIFESPAN_PATH, "r", encoding="utf-8") as f:
    lifespans = json.load(f)

# ===== VALIDATION =====
assert isinstance(characters, list)
assert isinstance(lifespans, list)

for l in lifespans:
    assert "id" in l
    assert "life_span" in l
    assert "en" in l["life_span"]
    assert "id" in l["life_span"]

# ===== BUILD MAP =====
lifespan_map = {l["id"]: l["life_span"] for l in lifespans}

# ===== HELPER =====
def is_unknown(life_span):
    en = life_span.get("en", "").strip().lower()
    id_ = life_span.get("id", "").strip().lower()

    return (
        en in ["unknown", ""] or
        id_ in ["tidak diketahui", ""]
    )

# ===== MERGE =====
missing = []
injected = 0
skipped_existing = 0
skipped_unknown = 0

for char in characters:
    char_id = char.get("id")

    if not char_id:
        print("⚠️ Skipping character without ID")
        continue

    if char_id in lifespan_map:
        life_span = lifespan_map[char_id]

        if is_unknown(life_span):
            skipped_unknown += 1
            continue

        if "life_span" not in char:
            char["life_span"] = life_span
            injected += 1
        else:
            skipped_existing += 1
    else:
        missing.append(char_id)

# ===== SAVE OUTPUT =====
with open(OUTPUT_PATH, "w", encoding="utf-8") as f:
    json.dump(characters, f, indent=2, ensure_ascii=False)

# ===== REPORT =====
print("=== MERGE RESULT ===")
print(f"Injected: {injected}")
print(f"Skipped (unknown): {skipped_unknown}")
print(f"Skipped (already exists): {skipped_existing}")
print(f"Missing lifespan: {len(missing)}")

if missing:
    print("\nMissing IDs:")
    for m in missing:
        print("-", m)

    if STRICT_MODE:
        raise ValueError("Missing lifespan data detected")

print("\nOutput saved to:", OUTPUT_PATH)