import os
import sys

# Qusestion
app_name = input("\nEnter the app name. For example, 'My App'.\n")
domain = input("\nEnter domain name. For example, 'com.mycompany'.\n")
confirm = input("\nAre you sure? You cannot change this later. (y/n)\n")

# Check confirmation
if confirm != "y":
    sys.exit()

# Set the app name
lowercase_app_name = app_name.lower().replace(" ","")
for path, subdirs, files in os.walk("./"):
    for name in files:
        if ".py" in name:
            continue
        filepath = os.path.join(path, name)
        try:
            with open(filepath, mode="r", encoding="utf8") as file:
                content = file.read()
            modified = content
            modified = modified.replace("someappname", lowercase_app_name)
            modified = modified.replace("SomeAppName", app_name)
            modified = modified.replace("com.example", domain)
            if modified != content:
                with open(filepath, mode="w", encoding="utf8") as file:
                    file.write(modified)
        except UnicodeDecodeError:
            pass
