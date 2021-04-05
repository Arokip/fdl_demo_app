import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/port_demo/policy/minimap_policy.dart';
import 'package:diagram_editor_apps/port_demo/policy/my_policy_set.dart';
import 'package:diagram_editor_apps/port_demo/widget/rect_widget_body.dart';
import 'package:flutter/material.dart';

class PortDemoEditor extends StatefulWidget {
  @override
  _PortDemoEditorState createState() => _PortDemoEditorState();
}

class _PortDemoEditorState extends State<PortDemoEditor> {
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
              Positioned(
                left: 16,
                bottom: 16,
                width: 80,
                height: 80,
                child: Container(
                  color: Colors.pink,
                  child: Draggable<ComponentData>(
                    affinity: Axis.horizontal,
                    ignoringFeedbackSemantics: true,
                    data: ComponentData(
                      size: Size(80, 80),
                      data: RectCustomData(
                        color: Colors.blue,
                        text: 'custom text',
                      ),
                    ),
                    childWhenDragging: Container(
                      color: Colors.black,
                      width: 40,
                      height: 40,
                    ),
                    feedback: Material(
                      color: Colors.transparent,
                      child: Container(
                        color: Colors.blue,
                        width: 40,
                        height: 40,
                      ),
                    ),
                    child: Container(
                      color: Colors.blue,
                      width: 40,
                      height: 40,
                    ),
                  ),
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
