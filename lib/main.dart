import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'app_state.dart';
import 'bridge/first_crate/ffi.dart' as first_crate;
import 'bridge/second_crate/ffi.dart' as second_crate;
import 'dart:io';

const appTitle = 'Some App Name';
const primaryColor = Color.fromARGB(255, 0, 156, 122);
const secondaryColor = Color.fromARGB(255, 0, 239, 187);
const minimumSize = Size(400, 400);
const initialSize = Size(600, 600);

void main() {
  if (kDebugMode) {
    Map<String, String> env = Platform.environment;
    env.forEach((k, v) => debugPrint("Key=$k Value=$v"));
  }

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: const MyApp(),
    ),
  );

  doWhenWindowReady(() {
    appWindow.title = appTitle;
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
      home: const MyHomePage(),
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
            const Text('Current value is '),
            Consumer<MyAppState>(
              builder: (context, appState, child) => Text(
                '${appState.tester.counterValue}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
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
