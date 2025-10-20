#!/usr/bin/env python3
import argparse
import csv
import json
import os
import re
import shutil
import sys


def normalize_key(name: str) -> str:
    if name is None:
        return ""
    # Lowercase, strip, remove non-alphanumeric
    key = name.strip().lower()
    key = re.sub(r"[^a-z0-9]+", "", key)
    return key


# Tokens to drop when building a base compare key
DESCRIPTOR_TOKENS = set(
    [
        'tablet', 'tablets', 'tab', 'tabs', 'capsule', 'capsules', 'cap', 'caps',
        'solution', 'suspension', 'elixir', 'syrup', 'pellets', 'powder', 'granules',
        'chewable', 'disintegrating', 'odt', 'orodispersible', 'sprinkle', 'oral',
        'liquid', 'liquidfilled', 'liquid-filled', 'gelcap', 'softgel', 'packet', 'packets',
        'dr', 'er', 'xr', 'sr', 'cr', 'xl', 'ir', 'delayed', 'extended', 'release', 'released',
        'enteric', 'coated', 'film', 'coated', 'immediate', 'microcapsules',
        'mg', 'mcg', 'g', 'iu'
    ]
)


def tokenize_base(s: str):
    if not s:
        return []
    # remove parentheses and non-alphanumerics -> spaces
    s2 = re.sub(r"\([^\)]*\)", " ", s.lower())
    s2 = re.sub(r"[^a-z0-9]+", " ", s2)
    tokens = [t for t in s2.split() if t and t not in DESCRIPTOR_TOKENS]
    return tokens


def base_key(s: str) -> str:
    tokens = tokenize_base(s)
    return "".join(tokens)


def find_header_indices(header_row):
    # Normalize header cells for matching
    norm = [c.strip().lower() for c in header_row]

    def idx_of(substrs):
        for i, cell in enumerate(norm):
            for s in substrs:
                if s in cell:
                    return i
        return -1

    indices = {
        "drug": idx_of(["drug"]),
        "dose_form": idx_of(["dose form", "dosage form", "doseform"]),
        "comment": idx_of(["comment", "notes", "alteration", "instruction"]),
        "reference_col": idx_of(["reference", "ref"]),
        "available": idx_of(["available in liquid form", "suspension available", "available in liquid"]),
        "g_recommend": idx_of(["gastric feeding tube (recommendation)", "gastric", "gtube"]),
        "g_mix": idx_of(["volume to mix", "gastric volume to mix"]),
        "g_time": idx_of(["time (minutes)", "gastric time"]),
        "g_rinse": idx_of(["volume to rinse", "gastric volume to rinse"]),
        "j_recommend": idx_of(["jejunal feeding tube (recommendation)", "jejunal", "jtube"]),
        "j_mix": -1,
        "j_time": -1,
        "j_rinse": -1,
    }

    # Find the second set of mix/time/rinse for jejunal if present
    # Approach: after j_recommend, the next three labels are for J-tube
    if indices["j_recommend"] != -1:
        start = indices["j_recommend"] + 1
        # Find next three meaningful columns after j_recommend
        picks = []
        for i in range(start, len(norm)):
            label = norm[i]
            if not label:
                continue
            picks.append(i)
            if len(picks) == 3:
                break
        if len(picks) == 3:
            indices["j_mix"], indices["j_time"], indices["j_rinse"] = picks

    return indices


def value_at(row, idx):
    if idx < 0 or idx >= len(row):
        return ""
    return (row[idx] or "").strip()


def clean_value(v: str) -> str:
    if v is None:
        return ""
    v = v.strip()
    if v in {"-", "--"}:
        return ""
    return v


def parse_csv(csv_path: str):
    rows = []
    with open(csv_path, "r", encoding="utf-8-sig", newline="") as f:
        reader = csv.reader(f, delimiter=';')
        header_found = False
        indices = None
        for row in reader:
            if not row:
                continue
            # Skip possible title like "Bảng 1"
            if not header_found:
                if any("drug" in (c or "").strip().lower() for c in row):
                    indices = find_header_indices(row)
                    if indices["drug"] == -1:
                        raise RuntimeError("Cannot locate 'Drug' column in header")
                    header_found = True
                continue

            drug = clean_value(value_at(row, indices["drug"]))
            if not drug:
                continue

            available = clean_value(value_at(row, indices["available"]))
            dose_form = clean_value(value_at(row, indices.get("dose_form", -1)))
            comment = clean_value(value_at(row, indices.get("comment", -1)))
            reference = clean_value(value_at(row, indices.get("reference_col", -1)))
            g_rec = clean_value(value_at(row, indices["g_recommend"]))
            g_mix = clean_value(value_at(row, indices["g_mix"]))
            g_time = clean_value(value_at(row, indices["g_time"]))
            g_rinse = clean_value(value_at(row, indices["g_rinse"]))
            j_rec = clean_value(value_at(row, indices["j_recommend"]))
            j_mix = clean_value(value_at(row, indices["j_mix"]))
            j_time = clean_value(value_at(row, indices["j_time"]))
            j_rinse = clean_value(value_at(row, indices["j_rinse"]))

            entry = {
                "csvName": drug,
                "doseForm": dose_form,
                "comment": comment,
                "reference": reference,
                "availableLiquidForm": available,
                "tubeFeeding": {
                    "gastric": {
                        "recommend": g_rec,
                        "volumeToMix": g_mix,
                        "timeMinutes": g_time,
                        "volumeToRinse": g_rinse,
                        "notes": [],
                    },
                    "jejunal": {
                        "recommend": j_rec,
                        "volumeToMix": j_mix,
                        "timeMinutes": j_time,
                        "volumeToRinse": j_rinse,
                        "notes": [],
                    },
                },
            }

            # Only keep if at least one meaningful field exists
            has_content = any(
                bool(entry["tubeFeeding"][tube][field])
                for tube in ("gastric", "jejunal")
                for field in ("recommend", "volumeToMix", "timeMinutes", "volumeToRinse")
            )
            if has_content:
                rows.append((drug, entry))

    # Build mapping by normalized key
    mapping = {normalize_key(name): data for name, data in rows}
    return mapping


def load_json(json_path: str):
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    # Support either list or {"medications": [...]}
    if isinstance(data, dict) and "medications" in data:
        return data, data["medications"], True
    elif isinstance(data, list):
        return data, data, False
    else:
        raise RuntimeError("Unsupported JSON format: expected array or {medications: [...]} object")


def merge(mapping, json_data_list):
    matched = 0
    # helper to strip parentheses content for more flexible matching
    def strip_parens(s: str) -> str:
        # remove parenthetical substrings like " (Lansoprazole)"
        return re.sub(r"\([^\)]*\)", "", s or "").strip()

    consumed_keys = set()
    for med in json_data_list:
        candidates = []
        for key in ("name", "genericName", "generic_name"):
            v = med.get(key)
            if isinstance(v, str) and v.strip():
                candidates.append(v)
        # Try to match any candidate
        found = None
        for candidate in candidates:
            nk = normalize_key(candidate)
            nk2 = normalize_key(strip_parens(candidate))
            bk = base_key(candidate)
            # direct exact match
            if nk in mapping:
                found = mapping[nk]
                consumed_keys.add(nk)
                break
            if nk2 and nk2 in mapping:
                found = mapping[nk2]
                consumed_keys.add(nk2)
                break
            # fuzzy contains match over mapping keys
            for mk, mval in mapping.items():
                if mk and (mk in nk or nk in mk or mk in nk2 or nk2 in mk or (bk and (mk in bk or bk in mk))):
                    found = mval
                    consumed_keys.add(mk)
                    break
            if found:
                break
            # token-based similarity
            toks_csv = set(tokenize_base(candidate))
            if not toks_csv:
                continue
            for mk, mval in mapping.items():
                # recover an approximate original from mapping key by inserting spaces between tokens
                # and compute tokens as well
                toks_map = set(re.findall(r"[a-z]+", mk))
                if not toks_map:
                    continue
                inter = toks_csv & toks_map
                jacc = len(inter) / max(1, len(toks_csv | toks_map))
                if jacc >= 0.6 or toks_csv.issubset(toks_map) or toks_map.issubset(toks_csv):
                    found = mval
                    consumed_keys.add(mk)
                    break
            if found:
                break
        if found:
            # Merge/overwrite tubeFeeding
            med["tubeFeeding"] = found["tubeFeeding"]
            # Optionally include availability info at top-level if useful
            if found.get("availableLiquidForm"):
                med["availableLiquidForm"] = found["availableLiquidForm"]
            matched += 1

    # Add new medications for any mapping entries not consumed
    # Determine next numeric id
    max_id = 0
    for m in json_data_list:
        try:
            mid = int(str(m.get("id", "0")).strip())
            if mid > max_id:
                max_id = mid
        except Exception:
            continue

    added = 0
    for mk, mval in mapping.items():
        if mk in consumed_keys:
            continue
        max_id += 1
        csv_name = mval.get("csvName") or ""
        dose_form = mval.get("doseForm") or ""
        comment = mval.get("comment") or ""
        reference = mval.get("reference") or ""

        new_med = {
            "id": str(max_id),
            "name": csv_name,
            "genericName": csv_name,
            "category": "Medication",
            "description": "Available in 1 dosage form(s)",
            "dosage": "As prescribed",
            "sideEffects": [],
            "contraindications": [],
            "manufacturer": "Various",
            "dosageForms": [
                {
                    "form": dose_form or "",
                    "alteration": comment or "",
                    "reference": reference or "",
                }
            ],
            "form": dose_form or "",
            "alteration": comment or "",
            "reference": reference or "",
            "tubeFeeding": mval.get("tubeFeeding", {}),
            "availableLiquidForm": mval.get("availableLiquidForm", ""),
        }
        json_data_list.append(new_med)
        added += 1

    return matched, added


def main():
    parser = argparse.ArgumentParser(description="Merge tubes feeding CSV into medications JSON")
    parser.add_argument("--csv", required=True, help="Path to MediCrush2025new.csv")
    parser.add_argument("--json", required=True, help="Path to medications_flutter_format.json")
    parser.add_argument("--output", help="Optional output path; default is in-place overwrite of --json")
    parser.add_argument("--backup", action="store_true", help="Create a .bak backup before writing")
    args = parser.parse_args()

    csv_path = os.path.abspath(args.csv)
    json_path = os.path.abspath(args.json)
    out_path = os.path.abspath(args.output) if args.output else json_path

    if not os.path.exists(csv_path):
        print(f"CSV not found: {csv_path}", file=sys.stderr)
        sys.exit(1)
    if not os.path.exists(json_path):
        print(f"JSON not found: {json_path}", file=sys.stderr)
        sys.exit(1)

    mapping = parse_csv(csv_path)
    data, med_list, wrapped = load_json(json_path)
    matched, added = merge(mapping, med_list)

    if args.backup and out_path == json_path:
        backup_path = json_path + ".bak"
        shutil.copyfile(json_path, backup_path)
        print(f"Backup created: {backup_path}")

    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print(f"Merged tubes feeding into {matched} existing entries, added {added} new entries. Written to: {out_path}")


if __name__ == "__main__":
    main()


