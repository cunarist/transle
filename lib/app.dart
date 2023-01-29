import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'state.dart';
import 'bridge/first_crate/ffi.dart' as first_crate;
import 'bridge/second_crate/ffi.dart' as second_crate;
import 'value.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = ThemeMode.system;

    // Debug mode code (assert statement gets removed in release mode)
    assert(() {
      String debugLocale = dotenv.env['DEBUG_LOCALE'] ?? '';
      switch (debugLocale) {
        case '':
          break;
        default:
          List splitted = debugLocale.split('-');
          context.setLocale(Locale(splitted[0], splitted[1]));
      }
      String darkMode = dotenv.env['DARK_MODE'] ?? '';
      switch (darkMode) {
        case 'true':
          themeMode = ThemeMode.dark;
          break;
        case 'false':
          themeMode = ThemeMode.light;
          break;
      }
      return true;
    }());

    // Set function that will be run before closing the window on desktop
    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      debugPrint('App closing');
      return true;
    });

    // Return the actual app structure
    return MaterialApp(
      title: 'appTitle'.tr(),
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
                  'counter.informationText'.tr(namedArgs: {
                'theValue': appState.tester.counterValue.toString()
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
