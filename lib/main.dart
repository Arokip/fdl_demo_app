import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/policy/minimap_policy.dart';
import 'package:diagram_editor_apps/policy/my_policy_set.dart';
import 'package:diagram_editor_apps/widget/rect_widget_body.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ArchitectureEditor());
}

class ArchitectureEditor extends StatefulWidget {
  @override
  _ArchitectureEditorState createState() => _ArchitectureEditorState();
}

class _ArchitectureEditorState extends State<ArchitectureEditor> {
  DiagramEditorContext diagramEditorContext;
  DiagramEditorContext diagramEditorContextMiniMap;

  MyPolicySet defaultPolicySet = MyPolicySet();
  MiniMapPolicySet miniMapPolicySet = MiniMapPolicySet();

  @override
  void initState() {
    diagramEditorContext = DiagramEditorContext(
      policySet: defaultPolicySet,
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
              Container(color: Colors.red),
              Positioned(
                // width: 600,
                // height: 400,
                // top: 10,
                // left: 10,
                child: DiagramEditor(
                  diagramEditorContext: diagramEditorContext,
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
                    defaultPolicySet.resetView();
                  },
                ),
              ),
              Container(
                color: Colors.red,
                width: 24,
                height: 24,
                child: GestureDetector(
                  onTap: () {
                    defaultPolicySet.removeAll();
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
            ],
          ),
        ),
      ),
    );
  }
}
