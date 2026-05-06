import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    const windowOptions = WindowOptions(
      title: 'Flutter Demo',
      minimumSize: Size(400, 300),
      maximumSize: Size.infinite,
      size: Size(400, 300),
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TooltipVisibility(
      visible: false,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(
          title: 'Flutter Demo Home Page',
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyBinding(
      onIncrementTriggered: _incrementCounter,
      onDecrementTriggered: _decrementCounter,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: _decrementCounter,
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}

final incrementKeys = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.equal,
);

final decrementKeys = LogicalKeySet(
  Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
  LogicalKeyboardKey.minus,
);

class IncrementIntent extends Intent {}

class DecrementIntent extends Intent {}

class KeyBinding extends StatelessWidget {
  const KeyBinding({
    super.key,
    required this.child,
    required this.onIncrementTriggered,
    required this.onDecrementTriggered,
  });

  final Widget child;
  final VoidCallback? onIncrementTriggered;
  final VoidCallback? onDecrementTriggered;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      autofocus: true,
      shortcuts: {
        incrementKeys: IncrementIntent(),
        decrementKeys: DecrementIntent(),
      },
      actions: {
        IncrementIntent: CallbackAction(
          onInvoke: (e) => onIncrementTriggered?.call(),
        ),
        DecrementIntent: CallbackAction(
          onInvoke: (e) => onDecrementTriggered?.call(),
        ),
      },
      child: child,
    );
  }
}
