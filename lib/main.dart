import 'package:diagram_editor_apps/complex_example/complex_editor.dart';
import 'package:diagram_editor_apps/grid_example/grid_editor.dart';
import 'package:diagram_editor_apps/hierarchical_example/hierarchical_editor.dart';
import 'package:diagram_editor_apps/ports_example/ports_editor.dart';
import 'package:diagram_editor_apps/pub_example/pub_editor.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/editor.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // showPerformanceOverlay: !kIsWeb,
      showPerformanceOverlay: false,
      title: 'Diagram editor',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/editor': (context) => const SimpleDemo(),
        '/pub_example': (context) => const PubDemo(),
        '/ports': (context) => const PortDemo(),
        '/hierarchical': (context) => const HierarchicalDemo(),
        '/complex': (context) => const ComplexDemo(),
        '/grid': (context) => const GridDemo(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.tryParse(urlString);
    if (url == null) return;
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Examples of usage of Flutter diagram_editor library.'),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                ),
                child: const Text('library GitHub'),
                onPressed: () async {
                  await _launchUrl('https://github.com/Arokip/flutter_diagram_editor');
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                ),
                child: const Text('library'),
                onPressed: () async {
                  await _launchUrl('https://pub.dev/packages/diagram_editor');
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                ),
                child: const Text('Simple editor'),
                onPressed: () {
                  Navigator.pushNamed(context, '/editor');
                },
              ),
              const SizedBox(height: 40),
              const Text('More examples:'),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                ),
                child: const Text('pub.dev example'),
                onPressed: () {
                  Navigator.pushNamed(context, '/pub_example');
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                ),
                child: const Text('port example'),
                onPressed: () {
                  Navigator.pushNamed(context, '/ports');
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                ),
                child: const Text('hierarchical components example'),
                onPressed: () {
                  Navigator.pushNamed(context, '/hierarchical');
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                ),
                child: const Text('complex widget components'),
                onPressed: () {
                  Navigator.pushNamed(context, '/complex');
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                ),
                child: const Text('grid snapping example'),
                onPressed: () {
                  Navigator.pushNamed(context, '/grid');
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
  const SimpleDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: SimpleDemoEditor(),
      ),
    );
  }
}

class PubDemo extends StatelessWidget {
  const PubDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: PubDiagramEditor(),
      ),
    );
  }
}

class PortDemo extends StatelessWidget {
  const PortDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: PortsDiagramEditor(),
      ),
    );
  }
}

class HierarchicalDemo extends StatelessWidget {
  const HierarchicalDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: HierarchicalDiagramEditor(),
      ),
    );
  }
}

class ComplexDemo extends StatelessWidget {
  const ComplexDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: ComplexDiagramEditor(),
      ),
    );
  }
}

class GridDemo extends StatelessWidget {
  const GridDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: GridDiagramEditor(),
      ),
    );
  }
}
