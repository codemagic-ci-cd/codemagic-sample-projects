import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

void main() {
  runApp(const MaterialApp(home: HomePage()));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home page"),
      ),
      body: Center(
          child: OutlinedButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (cnt) => const UnityDemoScreen())),
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text("Open Unity game"))),
    );
  }
}

class UnityDemoScreen extends StatefulWidget {
  const UnityDemoScreen({super.key});

  @override
  _UnityDemoScreenState createState() => _UnityDemoScreenState();
}

class _UnityDemoScreenState extends State<UnityDemoScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  late UnityWidgetController _unityWidgetController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Card(
          margin: const EdgeInsets.all(8),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: [
              UnityWidget(
                onUnityCreated: onUnityCreated,
                onUnityMessage: onUnityMessage,
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        OutlinedButton.icon(
                            onPressed: () => changeCurrentLevel("Level1"),
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text("Level 1")),
                        OutlinedButton.icon(
                            onPressed: () => changeCurrentLevel("Level2"),
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: const Text("Level 2")),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }

  void onUnityMessage(message) {
    print('Received message from unity: ${message.toString()}');
  }

  changeCurrentLevel(String value) {
    _unityWidgetController.postMessage(
      'LevelController',
      'ChangeCurrentLevel',
      value,
    );
  }
}
