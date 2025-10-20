#!/usr/bin/env python3
import json
import sys


def load_names(path):
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    meds = data['medications'] if isinstance(data, dict) and 'medications' in data else (data if isinstance(data, list) else [])
    names = []
    for m in meds:
        name = m.get('name') or m.get('genericName') or ''
        if name:
            names.append(name)
    return names


def main():
    if len(sys.argv) < 3:
        print('Usage: list_new_added.py <old_json> <new_json>')
        sys.exit(1)
    old_path = sys.argv[1]
    new_path = sys.argv[2]
    old_names = set(load_names(old_path))
    new_names = load_names(new_path)
    added = [n for n in new_names if n not in old_names]
    print(len(added))
    for n in added:
        print(n)


if __name__ == '__main__':
    main()


