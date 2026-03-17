import 'dart:math' as math;

import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

void main() => runApp(const PubDiagramEditor());

class PubDiagramEditor extends StatefulWidget {
  const PubDiagramEditor({super.key});

  @override
  PubDiagramEditorState createState() => PubDiagramEditorState();
}

class PubDiagramEditorState extends State<PubDiagramEditor> {
  late final DiagramController<MyComponentData, void> controller;

  String? selectedComponentId;
  String serializedDiagram = '{"components": [], "links": []}';
  Offset lastFocalPoint = Offset.zero;

  @override
  void initState() {
    super.initState();
    controller = DiagramController<MyComponentData, void>(
      canvasConfig: CanvasConfig(backgroundColor: Colors.grey[300]!),
      componentDataCodec: JsonCodec<MyComponentData>(
        decode: (json) => MyComponentData.fromJson(json),
        encode: (data) => data.toJson(),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void highlightComponent(String componentId) {
    controller.getComponent(componentId).data?.showHighlight();
    controller.getComponent(componentId).updateComponent();
    selectedComponentId = componentId;
  }

  void hideComponentHighlight(String? componentId) {
    if (componentId != null) {
      controller.getComponent(componentId).data?.hideHighlight();
      controller.getComponent(componentId).updateComponent();
      selectedComponentId = null;
    }
  }

  bool connectComponents(String? sourceComponentId, String? targetComponentId) {
    if (sourceComponentId == null || targetComponentId == null) return false;
    if (sourceComponentId == targetComponentId) return false;
    if (controller
        .getComponent(sourceComponentId)
        .connections
        .any((connection) =>
            connection is OutgoingConnection &&
            connection.otherComponentId == targetComponentId)) {
      return false;
    }
    controller.connect(
      sourceComponentId: sourceComponentId,
      targetComponentId: targetComponentId,
      linkStyle: const LinkStyle(
        arrowType: ArrowType.pointedArrow,
        lineWidth: 1.5,
        backArrowType: ArrowType.centerCircle,
      ),
    );
    return true;
  }

  void deleteAllComponents() {
    selectedComponentId = null;
    controller.removeAllComponents();
  }

  void serialize() {
    serializedDiagram = controller.serialize();
  }

  void deserialize() {
    controller.removeAllComponents();
    controller.deserialize(serializedDiagram);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(color: Colors.grey),
              Padding(
                padding: const EdgeInsets.all(16),
                child: DiagramEditor<MyComponentData, void>(
                  controller: controller,
                  componentBuilder:
                      (BuildContext context, ComponentData<MyComponentData> component) {
                    return Container(
                      decoration: BoxDecoration(
                        color: component.data?.color,
                        border: Border.all(
                          width: 2,
                          color: (component.data?.isHighlightVisible ?? false)
                              ? Colors.pink
                              : Colors.black,
                        ),
                      ),
                      child: const Center(child: Text('component')),
                    );
                  },
                  onCanvasTapUp: (TapUpDetails details) {
                    controller.hideAllLinkJoints();
                    if (selectedComponentId != null) {
                      hideComponentHighlight(selectedComponentId);
                    } else {
                      controller.addComponent(
                        ComponentData<MyComponentData>(
                          size: const Size(96, 72),
                          position: controller
                              .fromCanvasCoordinates(details.localPosition),
                          data: MyComponentData(),
                        ),
                      );
                    }
                  },
                  onComponentTap: (String componentId) {
                    controller.hideAllLinkJoints();
                    bool connected =
                        connectComponents(selectedComponentId, componentId);
                    hideComponentHighlight(selectedComponentId);
                    if (!connected) {
                      highlightComponent(componentId);
                    }
                  },
                  onComponentLongPress: (String componentId) {
                    hideComponentHighlight(selectedComponentId);
                    controller.hideAllLinkJoints();
                    controller.removeComponent(componentId);
                  },
                  onComponentScaleStart: (String componentId,
                      ScaleStartDetails details) {
                    lastFocalPoint = details.localFocalPoint;
                  },
                  onComponentScaleUpdate: (String componentId,
                      ScaleUpdateDetails details) {
                    Offset positionDelta =
                        details.localFocalPoint - lastFocalPoint;
                    controller.moveComponent(componentId, positionDelta);
                    lastFocalPoint = details.localFocalPoint;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => deleteAllComponents(),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red),
                      child: const Text('delete all'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => serialize(),
                      child: const Text('serialize'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => deserialize(),
                      child: const Text('deserialize'),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blue),
                  ),
                  child: const Row(
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

class MyComponentData {
  MyComponentData();

  bool isHighlightVisible = false;
  Color color = Color.fromARGB(
    255,
    math.Random().nextInt(256),
    math.Random().nextInt(256),
    math.Random().nextInt(256),
  );

  void showHighlight() {
    isHighlightVisible = true;
  }

  void hideHighlight() {
    isHighlightVisible = false;
  }

  MyComponentData.fromJson(Map<String, dynamic> json)
      : isHighlightVisible = json['highlight'],
        color = Color(int.parse(json['color'], radix: 16));

  Map<String, dynamic> toJson() => {
        'highlight': isHighlightVisible,
        'color': color.toARGB32().toRadixString(16),
      };
}
