import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'state.dart';
import 'app.dart';
import 'value.dart';

void main() async {
  // Debug mode code
  assert(() {
    // assert statement gets removed in release mode
    debugPrint('CWD ${Directory.current.path}');
    dotenv.testLoad(fileInput: File('.env').readAsStringSync());
    dotenv.env.forEach((k, v) => debugPrint('ENV $k $v'));
    return true;
  }());

  // Initialization of packages
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Run everything
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ko', 'KR'),
        ],
        path: 'assets/translations',
        assetLoader: YamlAssetLoader(),
        fallbackLocale: const Locale('en', 'US'),
        child: const App(),
      ),
    ),
  );

  // Set desktop window shape
  doWhenWindowReady(() {
    appWindow.title = 'appTitle'.tr();
    appWindow.minSize = minimumSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = ThemeMode.system;

    assert(() {
      // assert statement gets removed in release mode
      String debugLocale = dotenv.env["DEBUG_LOCALE"] ?? "";
      switch (debugLocale) {
        case "":
          break;
        default:
          List splitted = debugLocale.split("-");
          context.setLocale(Locale(splitted[0], splitted[1]));
      }
      String darkMode = dotenv.env["DARK_MODE"] ?? "";
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
      home: const HomePage(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<AppState>(
              builder: (context, appState, child) => Text(
                  "counter.informationText".tr(namedArgs: {
                "theValue": appState.tester.counterValue.toString()
              })),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AppState>().setState((AppState s) async {
            int original = s.tester.counterValue;
            int calculated = original;
            calculated = await api.addThree(before: calculated);
            s.tester.counterValue = calculated;
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
