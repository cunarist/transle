import os
import json

# Generate launch configuration file for Visual Studio Code
filepath = ".env"
with open(filepath, mode="r", encoding="utf8") as file:
    items = file.readlines()
items = [x.strip().split("=", 1) for x in items if "=" in x]
block_text = json.dumps(dict(items))

filepath = "./automate/template/vscode_launch_json.txt"
with open(filepath, mode="r", encoding="utf8") as file:
    template_text = file.read()

output_text = template_text.replace("[[ENV]]", block_text)
output_text = json.dumps(json.loads(output_text), indent=2)

os.makedirs(f"./.vscode", exist_ok=True)

filepath = "./.vscode/launch.json"
with open(filepath, mode="w", encoding="utf8") as file:
    file.write(output_text)
