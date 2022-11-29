import 'package:facecam/tensorflow.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _notifier,
      builder: (_, mode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(),
          themeMode: mode,
          home: Scaffold(
            appBar: AppBar(
              leading: Icon(
                Icons.flutter_dash,
                color: Colors.orange,
                size: 30.0,
              ),
              title: Text(
                "Emotion Detection",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: Tensorflow(),
          ),
        );
      },
    );
  }
}
