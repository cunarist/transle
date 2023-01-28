# Project Structure

This software is a combination of Flutter and Rust. Flutter creates cross-platform user interface using Dart. Rust handles the internal logic.

This repository is a fork of `cunarist/app-template` repository on GitHub, which is based on default Flutter template with some additional packages and modifications applied to make sure everything is super-ready. Because this repository is basically a fork, it can receive latest updates applied to `cunarist/app-template` via Git.

Extra features from this template that are not included in original Flutter template are:

- Convenient app naming and icon generation
- Convenient environment variable management
- Rust integration with ability to use multiple library crates
- Localization

# Platform Support

Dart and Rust support a variety of platforms: Windows, Linux, macOS, Android, iOS and web. However, Cunarist App Template is not yet mature enough to support all of those, though it has enough potential to do so in the future.

Currently supported platforms in Cunarist App Template are:

- Windows
- Linux

# System Preparation

Flutter and Rust are required for building the app itself. Python is needed to automate complicated procedures.

You can use an IDE of your choice. However, [Visual Studio Code](https://code.visualstudio.com/) is recommended because it has extensive support from Flutter and Rust communities.

## Preparing Python

Go to the [official downloads page](https://www.python.org/downloads/) if your system doesn't provide a pre-installed version. Make sure Python installation is incldued in `PATH` environment variable.

## Preparing Rust

Refer to the [official docs](https://doc.rust-lang.org/book/ch01-01-installation.html).

## Preparing Flutter

Refer to the [official docs](https://docs.flutter.dev/get-started/install).

Flutter docs also offer tutorials, samples, guidance on mobile development, and a full API reference. There are also many useful resources to read.

## System Verification

You can make sure if your system is ready for development in the terminal.

```
python --version
rustc --version
flutter doctor
```

# Bridge Generator

This template uses Dart and Rust. Using multiple programming languages means that we need to establish a bridge between them. [Flutter Rust Bridge](https://pub.dev/packages/flutter_rust_bridge) is a tool dedicated for this purpose.

You need to install extra dependencies for Flutter Rust Bridge. Refer to the [official docs](https://cjycode.com/flutter_rust_bridge/integrate/deps.html).

# Environment Variables

Before you proceed, you need to prepare files for environment variables.

This terminal command will generate environment variable files or update them from template files if they already exist.

```
python ./automate/update_dev_config.py
```

Files for environment variables are not version-controlled. You might be wondering why there are multiple files for managing environment variables. It's basically because this template combines multiple programming languages.

- File `./.env` includes environment variables for Dart. You might need them to control user interface during development. If you change the content, it will be automatically loaded on app restart.
- File `./native/.cargo/config.toml` includes environment variables loaded in Rust. You might need them to locate external C++ library paths through environment variables for compilation.

You should change values of environment variables inside these files during development to suit your needs. Environment variable files are only used in production and not included in the final release.

# Setting Up

Install Dart packages written in `./pubspec.yaml` from [Pub](https://pub.dev/).

```
flutter pub get
```

Install Python packages written in `./requirements.txt` from [PyPI](https://pypi.org/).

```
pip install -r requirements.txt
```

Set the app name and domain.

> This only works once. You cannot revert this.

```
python ./automate/set_name_and_domain.py
```

Convert product icon in `./assets` to make available in multiple platforms with [Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons).

```
flutter pub run flutter_launcher_icons
```

# Actual Development

You might need to dive into this section quite often.

Check if Rust crates in `./native` have any compilation error.

```
cargo check --manifest-path ./native/Cargo.toml
```

Generate code that enables your Dart functions call Rust functions with [Flutter Rust Bridge](https://cjycode.com/flutter_rust_bridge/).

> You must run this command after making any modification to Rust code in `./native`. If you don't, Dart cannot properly access Rust code and intellisense will not work. This makes additional `.rs` files in `./native` and `.dart` files in `./lib/bridge`. These generated files are not version-controlled.

```
python ./automate/generate_bridge.py
```

Run the app in debug mode.

```
flutter run
```

Build the app in release mode.

```
flutter build (platform) --release
```

# Rules

Be careful all the time! You should not cross the line to reach somewhere sensitive code lies in.

## Allowed Modification

You shouldn't be editing any file without enough knowledge on how it works.

These are the top-level files and folders that are allowed to edit during app development:

### Dart Related

- `lib`: Dart modules.
- `pubspec.yaml`: Dart settings and dependencies.
- `.env.template`: Template of `.env` file. Includes environment variables that will be loaded in Dart.

### Rust Related

- `native`: Rust crates. The name of the library crate folder should be exactly the same as that of library crate's name. `config.toml.template` file is also okay to be modified if it needed for the project.

## User Interface Texts

Always write user interface texts in `./assets/translations`.

When an app gains popularity, there comes a need to support multiple languages. However, manually replacing thousands of text widgets in the user interface is not a trivial task. Therefore it is a must to write texts that will be presented to normal users in translation files.

Refer to [Easy Localization](https://pub.dev/packages/easy_localization) docs for more details.

## Division of Functions

Dart should only be used for user interface and Rust should handle all other logics such as file handling, event handling, timer repetition, calculation, network communication, etc. There can be an exception though if Rust or Dart has trouble dealing with multiple platforms on one's side.

If the characteristic of a specific Rust API is totally different from other Rust APIs, it should be detached into a separate Rust crate. All crates should provide a clean API with descriptive function names.

## Python Automation Scripts

Due to limitations of dependencies and tools, Cunarist App Template relies heavily on Python scripts in `./automate` for automation.

Although Python automation is convenient, if there comes a situation where dependencies get updated and therefore specialized automation is not needed anymore in some areas, it's best to switch to out-of-the-box features of those dependencies.

Type hints should be provided for the maintainability of the code. Turn on strict type checking in whatever IDE you are using. If some third-party packages doesn't support type checking very well, then you can write `# type: ignore` to suppress the warning.

[Black](https://black.readthedocs.io/en/stable/) formatter should be used for maintaining quality code.

# Folder Structure

Most of the top-level folders comes from default Flutter template.

- `windows`: Platform-specific files
- `linux`: Platform-specific files
- `macos`: Platform-specific files
- `android`: Platform-specific files
- `ios`: Platform-specific files
- `web`: Platform-specific files
- `lib`: Dart modules empowering the Flutter application.

However, there are some extra folders created in Cunarist App Template in order to integrate other elements into development.

- `automate`: Python scripts for automating development process. These scripts have nothing to do with actual build and doesn't get included in the app release. Only for developers.
- `native`: A workspace Rust crate that includes many other Rust crates. Each crate inside this folder gets compiled into a library file(`.dll`/`.so`). That means if there are 10 crates inside this folder, then there would be 10 library file next to the executable after compilation, each with a file name corresponding to their original crate.
- `assets`: A place for asset files such as images.

In addition, there might be some other temporary folders generated by tools or IDE you are using. Those should not be version-controlled.
