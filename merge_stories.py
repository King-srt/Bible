import json

# load data
with open(r"firestore_seed\stories.json", "r", encoding="utf-8") as f:
    stories = json.load(f)

with open("temp.json", "r", encoding="utf-8") as f:
    refs = json.load(f)

# mapping id → references
ref_map = {r["id"]: r["scripture_references"] for r in refs}

missing_refs = []
injected_count = 0

for story in stories:
    story_id = story["id"]

    if story_id in ref_map:
        # inject hanya kalau belum ada
        if "scripture_references" not in story:
            story["scripture_references"] = ref_map[story_id]
            injected_count += 1
    else:
        missing_refs.append(story_id)

# save hasil
with open(r"firestore_seed\stories.json", "w", encoding="utf-8") as f:
    json.dump(stories, f, indent=2, ensure_ascii=False)

# report
print(f"Injected: {injected_count}")
print(f"Missing references: {len(missing_refs)}")

if missing_refs:
    print("List missing:")
    for m in missing_refs:
        print("-", m)