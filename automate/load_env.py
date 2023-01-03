import os
import sys

# Read .env file
filepath = ".env"
with open(filepath, mode="r", encoding="utf8") as file:
    env_items = file.readlines()
env_items = [x.strip().split("=", 1) for x in env_items if "=" in x]

# Make a copy of the current environment and insert .env items to it
environment_variables = dict(os.environ)
for env_key, env_value in env_items:
    os.environ[env_key] = env_value

# Remove Python file from arguments
arguments = list(sys.argv)
for index, argument in enumerate(arguments):
    if ".py" in argument:
        arguments = arguments[index + 1 :]
        break

# Run arguments passed in
os.system(" ".join(arguments))
