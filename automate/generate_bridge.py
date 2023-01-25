import os
import glob
import shutil

# Analyze existing crates
folderpath = "./native"
crate_names: list[str] = []
for item_name in os.listdir(folderpath):
    item_path = os.path.join(folderpath, item_name)
    if os.path.isdir(item_path) and item_name != "target":
        crate_names.append(item_name)

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
