import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/ports_example/policy/policy_set.dart';
import 'package:flutter/material.dart';

class PortsDiagramEditor extends StatefulWidget {
  @override
  _PortsDiagramEditorState createState() => _PortsDiagramEditorState();
}

class _PortsDiagramEditorState extends State<PortsDiagramEditor> {
  MyPolicySet myPolicySet = MyPolicySet();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(color: Colors.grey),
              Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  color: Colors.green,
                  child: DiagramEditor(
                    diagramEditorContext: DiagramEditorContext(
                      policySet: myPolicySet,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: GestureDetector(
                  onTap: () => myPolicySet.deleteAllComponents(),
                  child: Container(
                    width: 64,
                    height: 32,
                    color: Colors.red,
                    child: Center(child: Text('delete all')),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 100,
                child: GestureDetector(
                  onTap: () => myPolicySet.switchPortsVisibility(),
                  child: Container(
                    width: 120,
                    height: 32,
                    color: Colors.amber,
                    child: Center(child: Text('show/hide ports')),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back, size: 16),
                      SizedBox(width: 8),
                      Text('BACK TO MENU'),
                    ],
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
