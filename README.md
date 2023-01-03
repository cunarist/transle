# Project Structure

This software is a combination of Flutter and Rust. Flutter is used to build cross-platform user interface and Rust is used for the internal logic.

This repository is a fork of `cunarist/app-template` repository on GitHub, which is based on default Flutter app template with some additional packages and modifications applied to make sure everything is super-ready. Because this repository is basically a fork, it can receive latest updates applied to `cunarist/app-template` via Git.

This repository currently has Cunarist App Template version 20230103.

# Platform Support

Flutter and Rust support a variety of platforms: Windows, Linux, macOS, Android, iOS and web. However, Cunarist App Template is not yet mature enough to support all of those, though it has enough potential to do so in the future.

Currently supported platforms in Cunarist App Template are:

- Windows

# System Preparation

Flutter and Rust are required for building the app itself. Git and Python should be installed on your system to automate complicated procedures.

You can use an IDE of your choice. However, [Visual Studio Code](https://code.visualstudio.com/) is recommended because it has extensive support from Flutter and Rust communities. Above all, automation scripts in Cunarist App Template only support Visual Studio Code.

## Preparing Git

Go to the [official downloads page](https://git-scm.com/downloads)

## Preparing Python

Go to the [official downloads page](https://www.python.org/downloads/) if your system doesn't provide a pre-installed version. Make sure Python installation is incldued in `PATH` environment variable.

## Preparing Rust

Refer to the [official documentation](https://doc.rust-lang.org/book/).

## Preparing Flutter

View the [online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.

There are also many useful official resources to read:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

## System Verification

You can make sure if your system is ready for development in the terminal.

```
git --version
python --version
rustc --version
flutter doctor
```

# Flutter-Rust Bridge Preparation

Flutter-Rust Bridge is a code generator for communication between Flutter and Rust.

After your system is ready, you will need to install dependencies for Flutter-Rust Bridge. Refer to the [official docs](https://cjycode.com/flutter_rust_bridge/integrate/deps.html).

# Command Line Scripts

All of these assume that your terminal's working directory is set to the project's root folder.

Set the app name and domain.

```
python ./automate/set_name_and_domain.py
```

Download external source files described in `.external_zip_url` to `./.external`.

```
python ./automate/download_external_source.py
```

Make your debug tools work as expected with proper environment variables from `.env`.

```
python ./automate/configure_launch.py
```

Install Flutter packages written in `./pubspec.yaml` from [Pub](https://pub.dev/).

```
flutter pub get
```

Convert product icon in `./static` to be available in multiple platforms with [Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons).

```
flutter pub run flutter_launcher_icons
```

Check if Rust crates in `./native` have any compilation error.

```
python ./automate/load_env.py cargo check --manifest-path ./native/Cargo.toml
```

Generate code that enables your Flutter functions call Rust functions with [Flutter Rust Bridge](https://cjycode.com/flutter_rust_bridge/).

```
python ./automate/generate_bridge.py
```

Run the app in debug mode.

```
python ./automate/load_env.py flutter run
```

> Run button in UI of Visual Studio code doesn't take launch configuration into account. Use `Run and Debug` panel if possible.

Build the app in release mode.

```
python ./automate/load_env.py flutter build
```

# Rules

Be careful all the time! You should not cross the line to reach somewhere sensitive code lies in.

## Allowed Modification

You shouldn't be editing any file without enough knowledge on how it works.

These are the top-level files and folders that are allowed to edit during app development:

- `native`: Rust crates.
- `lib`: Dart modules for Flutter.
- `pubspec.yaml`: Flutter settings and dependencies.
- `.env`: Environment variables that will be loaded before compilation. This is useful when some dependency requires the location of external source files such as C++ libraries to be informed through an environment variable.
- `.external_zip_url`: URLs of external libraries that should be downloaded through an automated Python script.

## Division of Functions

Flutter should only be used for user interface and Rust should handle all other logics such as file handling, event handling, timer repetition, calculation, network communication, etc. There can be an exception though if Rust or Flutter has trouble dealing with multiple platforms on one's side.

If the characteristic of a Rust API is totally different from others, it should be separated into a separate Rust crate. All crates should provide a clean API with descriptive function names.

## Python Automation Scripts

Due to limitations of dependencies and tools, Cunarist App Template relies heavily on Python scripts in `./automate` for automation. Although Python automation is convenient, if there comes a situation where dependencies get updated and therefore specialized automation is not needed anymore in some areas, it's best to switch to out-of-the-box features of those dependencies.

Type hints should be provided for the maintainability of the code. Turn on strict type checking in whatever IDE you are using. If some third-party packages doesn't support type checking very well, then you can write `# type: ignore` to suppress the warning.

[Black](https://black.readthedocs.io/en/stable/) formatter should be used for maintaining quality code.

Third-party Python packages shouldn't be used. The point of Cunarist App Template is an building an app with Flutter and Rust.

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
- `static`: A place for static files which are not executed or compiled directly.

There are also temporary folders related to the build process. These should not be version-controlled.

- `build`: Where the final executable is saved.
- `.external`: Where external sources go into. Inside can be a C or C++ library which will be dealt with FFI, Dart library, or any third-party source that eventually gets compiled but cannot be included in the project simply with `pubspec.yaml` or `Cargo.toml`. If an external source should be added, don't forget to enable automatic download by modifying `.external_zip_url`.

In addition, there might be some other folders generated by tools or IDE you are using.
