import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/menu.dart';
import 'package:diagram_editor_apps/simple_demo/policy/minimap_policy.dart';
import 'package:diagram_editor_apps/simple_demo/policy/my_policy_set.dart';
import 'package:flutter/material.dart';

class SimpleDemoEditor extends StatefulWidget {
  @override
  _SimpleDemoEditorState createState() => _SimpleDemoEditorState();
}

class _SimpleDemoEditorState extends State<SimpleDemoEditor> {
  DiagramEditorContext diagramEditorContext;
  DiagramEditorContext diagramEditorContextMiniMap;

  MyPolicySet myPolicySet = MyPolicySet();
  MiniMapPolicySet miniMapPolicySet = MiniMapPolicySet();

  @override
  void initState() {
    diagramEditorContext = DiagramEditorContext(
      policySet: myPolicySet,
    );
    diagramEditorContextMiniMap = DiagramEditorContext.withSharedModel(
        diagramEditorContext,
        policySet: miniMapPolicySet);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // showPerformanceOverlay: !kIsWeb,
      showPerformanceOverlay: false,
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(color: Colors.grey),
              Positioned(
                // width: 600,
                // height: 400,
                // top: 10,
                // left: 10,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: DiagramEditor(
                    diagramEditorContext: diagramEditorContext,
                  ),
                ),
              ),
              Positioned(
                right: 16,
                top: 16,
                width: 320,
                height: 240,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black,
                    width: 2,
                  )),
                  child: DiagramEditor(
                    diagramEditorContext: diagramEditorContextMiniMap,
                  ),
                ),
              ),
              Container(
                color: Colors.yellow,
                width: 48,
                height: 24,
                child: GestureDetector(
                  onTap: () {
                    myPolicySet.resetView();
                  },
                ),
              ),
              Container(
                color: Colors.red,
                width: 24,
                height: 24,
                child: GestureDetector(
                  onTap: () {
                    myPolicySet.removeAll();
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  color: Colors.grey.withOpacity(0.5),
                  width: 120,
                  height: 320,
                  child: DraggableMenu(myPolicySet: myPolicySet),
                ),
              ),
              Positioned(
                top: 40,
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
