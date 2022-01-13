import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Flutter Demo');
    setWindowMinSize(const Size(400, 300));
    setWindowMaxSize(Size.infinite);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
                style: Theme.of(context).textTheme.headline4,
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
    Key? key,
    required this.child,
    required this.onIncrementTriggered,
    required this.onDecrementTriggered,
  }) : super(key: key);

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
