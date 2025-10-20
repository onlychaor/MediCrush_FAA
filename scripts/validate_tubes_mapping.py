#!/usr/bin/env python3
import argparse
import csv
import json
import os
import re
from collections import defaultdict


def normalize_key(name: str) -> str:
    if name is None:
        return ""
    key = name.strip().lower()
    key = re.sub(r"\([^\)]*\)", "", key)  # strip parentheses content
    key = re.sub(r"[^a-z0-9]+", "", key)
    return key


def load_csv_keys(csv_path: str):
    keys = []
    with open(csv_path, "r", encoding="utf-8-sig", newline="") as f:
        reader = csv.reader(f, delimiter=';')
        header_found = False
        drug_idx = -1
        for row in reader:
            if not header_found:
                # find header row
                if any("drug" in (c or "").strip().lower() for c in row):
                    drug_idx = next((i for i, c in enumerate(row) if (c or "").strip().lower().startswith("drug")), -1)
                    header_found = True
                continue
            if drug_idx == -1:
                continue
            drug = (row[drug_idx] or "").strip()
            if not drug:
                continue
            keys.append((drug, normalize_key(drug)))
    return keys


def tokenize_base(s: str):
    if not s:
        return []
    s2 = re.sub(r"\([^\)]*\)", " ", s.lower())
    s2 = re.sub(r"[^a-z0-9]+", " ", s2)
    return [t for t in s2.split() if t]


def load_json_keys(json_path: str):
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    meds = data["medications"] if isinstance(data, dict) and "medications" in data else (data if isinstance(data, list) else [])
    keys = []
    for med in meds:
        cand = []
        for k in ("name", "genericName", "generic_name"):
            v = med.get(k)
            if isinstance(v, str) and v.strip():
                cand.append(v)
        best = None
        for c in cand:
            nk = normalize_key(c)
            if nk:
                best = nk
                break
        keys.append((med, best, " ".join(tokenize_base(cand[0])) if cand else ""))
    return meds, keys


def main():
    parser = argparse.ArgumentParser(description="Validate which CSV drugs did not map into JSON")
    parser.add_argument("--csv", required=True)
    parser.add_argument("--json", required=True)
    args = parser.parse_args()

    csv_keys = load_csv_keys(args.csv)
    meds, json_keys = load_json_keys(args.json)

    json_key_set = set(k for _, k, _ in json_keys if k)

    unmatched = []
    fuzzy_candidates = defaultdict(list)
    for original, key in csv_keys:
        if not key:
            unmatched.append((original, "empty_key"))
            continue
        if key in json_key_set:
            continue
        # try fuzzy contains (normalized)
        matched = False
        for _, jk, _ in json_keys:
            if not jk:
                continue
            if key in jk or jk in key:
                fuzzy_candidates[original].append(jk)
                matched = True
        if not matched:
            # try token-based similarity against JSON token strings
            toks_csv = set(tokenize_base(original))
            best = None
            best_jacc = 0.0
            for _, jk, tok in json_keys:
                if not tok:
                    continue
                toks_json = set(tok.split())
                inter = toks_csv & toks_json
                jacc = len(inter) / max(1, len(toks_csv | toks_json))
                if jacc > best_jacc:
                    best_jacc = jacc
                    best = tok
            if best_jacc >= 0.6:
                fuzzy_candidates[original].append(best)
            else:
                unmatched.append((original, key))

    print(f"Total CSV entries: {len(csv_keys)}")
    print(f"Exact-or-normalized matches in JSON: {len(csv_keys) - len(unmatched)}")
    print(f"Likely unmatched: {len(unmatched)}")

    if unmatched:
        print("\nUnmatched examples (up to 50):")
        for i, (orig, key) in enumerate(unmatched[:50], 1):
            sugg = ", suggestions: " + ", ".join(fuzzy_candidates.get(orig, [])[:5]) if fuzzy_candidates.get(orig) else ""
            print(f"{i:02d}. {orig} -> {key}{sugg}")


if __name__ == "__main__":
    main()


