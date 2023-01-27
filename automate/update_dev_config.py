import os
from typing import Any
import toml  # type:ignore


def merge_dicts(d1: dict[Any, Any], d2: dict[Any, Any]) -> dict[Any, Any]:
    new: dict[Any, Any] = dict()
    for k in d2.keys():
        if k in d1.keys():
            if isinstance(d1[k], dict) and isinstance(d2[k], dict):
                new[k] = merge_dicts(d1[k], d2[k])
            else:
                new[k] = d1[k]
        else:
            new[k] = d2[k]
    return new


# Scan .env file
filepath = "./.env"
written_pairs = {}
if os.path.isfile(filepath):
    with open(filepath, mode="r", encoding="utf8") as file:
        lines = file.read().splitlines()
    lines = [x.strip().split("=", 1) for x in lines if "=" in x]
    written_pairs = dict(lines)

# Update .env file
filepath = "./.env.template"
with open(filepath, mode="r", encoding="utf8") as file:
    lines = file.read().splitlines()
for turn, line in enumerate(lines):
    if "=" not in line:
        continue
    item_key = line.strip().split("=", 1)[0]
    if item_key in written_pairs.keys():
        item_value = written_pairs[item_key]
        lines[turn] = f"{item_key}={item_value}"
text = "\n".join(lines)
filepath = ".env"
with open(filepath, mode="w", encoding="utf8") as file:
    file.write(text)
print("\nUpdated .env file from .env.template file in ./ folder")

# Scan config.toml file
filepath = "./native/.cargo/config.toml"
original_tree = {}
if os.path.isfile(filepath):
    with open(filepath, mode="r", encoding="utf8") as file:
        original_tree = toml.load(file)

# Update config.toml file
filepath = "./native/.cargo/config.toml.template"
with open(filepath, mode="r", encoding="utf8") as file:
    template_tree = toml.load(file)
final_tree = merge_dicts(original_tree, template_tree)
filepath = "./native/.cargo/config.toml"
with open(filepath, mode="w", encoding="utf8") as file:
    toml.dump(final_tree, file)
text = "\nUpdated config.toml file from config.toml.template file"
text += " in ./native/.cargo folder"
print(text)
