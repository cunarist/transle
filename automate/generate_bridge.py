import os
import glob
import shutil
import tomllib

# Analyze existing crates
folderpath = "./native"
crate_names: list[str] = []
ignore_folders = ["target", ".cargo"]
for folder_name in os.listdir(folderpath):
    crate_path = os.path.join(folderpath, folder_name)
    if not os.path.isdir(crate_path) or folder_name in ignore_folders:
        continue
    cargo_toml_path = os.path.join(crate_path, "Cargo.toml")
    with open(cargo_toml_path, mode="rb") as file:
        cargo_toml = tomllib.load(file)
    crate_name = cargo_toml["package"]["name"]
    if crate_name != folder_name:
        text = f"The library crate '{crate_name}'"
        text += f" has different folder name '{folder_name}'."
        raise ValueError(text)
    crate_names.append(crate_name)

# Clear bridge folder
folderpath = f"./lib/bridge"
items = glob.glob(f"{folderpath}/*")
for item in items:
    shutil.rmtree(item)

# Generate ffi.dart and bridge_generated.dart file for each crate
for crate_name in crate_names:
    print("")

    os.makedirs(f"./lib/bridge/{crate_name}", exist_ok=True)

    filepath = "./automate/template/ffi_dart.txt"
    with open(filepath, mode="r", encoding="utf8") as file:
        template_text = file.read()

    output_text = template_text
    output_text = output_text.replace("[[CRATE]]", crate_name)
    class_name = crate_name.replace("_", " ").title().replace(" ", "")
    output_text = output_text.replace("[[CLASS]]", class_name)

    filepath = f"./lib/bridge/{crate_name}/ffi.dart"
    with open(filepath, mode="w", encoding="utf8") as file:
        file.write(output_text)

    command = "flutter_rust_bridge_codegen"
    command += f" -r ./native/{crate_name}/src/api.rs"
    command += f" -d ./lib/bridge/{crate_name}/bridge_generated.dart"
    os.system(command)
