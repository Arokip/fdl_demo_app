import 'package:diagram_editor_apps/complex_example/complex_editor.dart';
import 'package:diagram_editor_apps/port_demo_old/editor.dart';
import 'package:diagram_editor_apps/ports_example/ports_editor.dart';
import 'package:diagram_editor_apps/pub_example/pub_editor.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/editor.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // showPerformanceOverlay: !kIsWeb,
      showPerformanceOverlay: false,
      title: 'Diagram editor',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/editor': (context) => SimpleDemo(),
        '/pub_example': (context) => PubDemo(),
        '/ports': (context) => PortDemo(),
        '/hierarchical': (context) => HierarchicalDemo(),
        '/complex': (context) => ComplexDemo(),
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
              SelectableText('https://pub.dev/packages/diagram_editor'),
              SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: Text('Simple editor'),
                onPressed: () {
                  Navigator.pushNamed(context, '/editor');
                },
              ),
              SizedBox(height: 32),
              Text('More examples:'),
              SizedBox(height: 8),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: Text('pub.dev example'),
                onPressed: () {
                  Navigator.pushNamed(context, '/pub_example');
                },
              ),
              SizedBox(height: 8),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: Text('port example'),
                onPressed: () {
                  Navigator.pushNamed(context, '/ports');
                },
              ),
              SizedBox(height: 8),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: Text('hierarchical components example'),
                onPressed: () {
                  Navigator.pushNamed(context, '/hierarchical');
                },
              ),
              SizedBox(height: 8),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: Text('complex widget components'),
                onPressed: () {
                  Navigator.pushNamed(context, '/complex');
                },
              ),
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

class PubDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PubDiagramEditor(),
      ),
    );
  }
}

class PortDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PortsDiagramEditor(),
      ),
    );
  }
}

class HierarchicalDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PubDiagramEditor(),
      ),
    );
  }
}

class ComplexDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ComplexDiagramEditor(),
      ),
    );
  }
}
