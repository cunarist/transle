import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:path/path.dart' as path;
import 'app_state.dart';
import 'bridge/first_crate/ffi.dart' as first_crate;
import 'bridge/second_crate/ffi.dart' as second_crate;

const appTitle = 'Some App Name';
const primaryColor = Color.fromARGB(255, 0, 156, 122);
const secondaryColor = Color.fromARGB(255, 0, 239, 187);
const minimumSize = Size(400, 400);
const initialSize = Size(600, 600);

void main() async {
  assert(() {
    // assert statement gets removed in release mode
    String dotEnvPath = path.join(Directory.current.path, ".env");
    File dotEnvFile = File(dotEnvPath);
    String dotEnvContent = dotEnvFile.readAsStringSync();
    dotenv.testLoad(fileInput: dotEnvContent);
    dotenv.env.forEach((k, v) => debugPrint("ENV $k $v"));
    return true;
  }());

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('ko'),
        ],
        path: 'assets/translations',
        assetLoader: YamlAssetLoader(),
        fallbackLocale: const Locale('en'),
        child: const MyApp(),
      ),
    ),
  );

  doWhenWindowReady(() {
    appWindow.title = "appTitle".tr();
    appWindow.minSize = minimumSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = ThemeMode.system;

    assert(() {
      // assert statement gets removed in release mode
      debugPrint('CWD ${Directory.current.path}}');
      String? debugLocale = dotenv.env["DEBUG_LOCALE"];
      switch (debugLocale) {
        case null:
          break;
        case "":
          break;
        default:
          context.setLocale(Locale(debugLocale ?? ""));
      }
      String? darkMode = dotenv.env["DARK_MODE"];
      switch (darkMode) {
        case "true":
          themeMode = ThemeMode.dark;
          break;
        case "false":
          themeMode = ThemeMode.light;
          break;
      }
      return true;
    }());

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: primaryColor,
          secondary: secondaryColor,
        ),
      ),
      themeMode: themeMode,
      home: const MyHomePage(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<MyAppState>(
              builder: (context, appState, child) =>
                  const Text("counter.informationText").tr(namedArgs: {
                "theValue": appState.tester.counterValue.toString()
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<MyAppState>().setState((MyAppState s) async {
            int original = s.tester.counterValue;
            int calculated = original;
            calculated = await second_crate.api.multiplyTwo(before: calculated);
            calculated = await first_crate.api.addOne(before: calculated);
            s.tester.counterValue = calculated;
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
