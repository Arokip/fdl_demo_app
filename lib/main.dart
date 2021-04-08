import 'package:diagram_editor_apps/port_demo/editor.dart';
import 'package:diagram_editor_apps/simple_demo/widget/editor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // showPerformanceOverlay: !kIsWeb,
      showPerformanceOverlay: false,
      navigatorKey: navigatorKey,
      title: 'Diagram editor',
      initialRoute: '/simple_demo',
      routes: {
        '/': (context) => HomeScreen(),
        '/simple_demo': (context) => SimpleDemo(),
        '/port_demo': (context) => PortDemo(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Examples of usage of Flutter diagram_editor library.'),
              SizedBox(height: 16),
              SelectableText('https://github.com/Arokip/fdl'),
              SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: Text('Simple demo editor'),
                onPressed: () {
                  Navigator.pushNamed(context, '/simple_demo');
                },
              ),
              SizedBox(height: 8),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: Text('Port demo editor'),
                onPressed: () {
                  Navigator.pushNamed(context, '/port_demo');
                },
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SimpleDemoEditor(),
      ),
    );
  }
}

class PortDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PortDemoEditor(),
      ),
    );
  }
}
