import 'dart:math' as math;

import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/complex_example/components/rainbow.dart';
import 'package:diagram_editor_apps/complex_example/components/random.dart';
import 'package:flutter/material.dart';

class ComplexDiagramEditor extends StatefulWidget {
  const ComplexDiagramEditor({super.key});

  @override
  ComplexDiagramEditorState createState() => ComplexDiagramEditorState();
}

class ComplexDiagramEditorState extends State<ComplexDiagramEditor> {
  late DiagramController<MyComponentData, void> controller;

  String? selectedComponentId;
  late Offset lastFocalPoint;

  @override
  void initState() {
    controller = DiagramController<MyComponentData, void>(
      linkEndpointAligner: _getLinkEndpointAlignment,
    );
    super.initState();
  }

  Alignment _getLinkEndpointAlignment(
    ComponentData componentData,
    Offset targetPoint,
  ) {
    Offset pointPosition = targetPoint -
        (componentData.position + componentData.size.center(Offset.zero));
    pointPosition = Offset(
      pointPosition.dx / componentData.size.width,
      pointPosition.dy / componentData.size.height,
    );

    switch (componentData.type) {
      case 'random':
        return Alignment.center;

      case 'flutter':
        return const Alignment(-0.54, 0);

      default:
        Offset pointAlignment;
        if (pointPosition.dx.abs() >= pointPosition.dy.abs()) {
          pointAlignment = Offset(
            pointPosition.dx / pointPosition.dx.abs(),
            pointPosition.dy / pointPosition.dx.abs(),
          );
        } else {
          pointAlignment = Offset(
            pointPosition.dx / pointPosition.dy.abs(),
            pointPosition.dy / pointPosition.dy.abs(),
          );
        }
        return Alignment(pointAlignment.dx, pointAlignment.dy);
    }
  }

  Widget _componentBuilder(BuildContext context, ComponentData<MyComponentData> componentData) {
    switch (componentData.type) {
      case 'rainbow':
        return ComplexRainbowComponent(componentData: componentData);
      case 'random':
        return RandomComponent(componentData: componentData);
      case 'flutter':
        return Container(
          color: componentData.data?.isHighlightVisible == true
              ? Colors.transparent
              : Colors.limeAccent,
          child: componentData.data?.isHighlightVisible == true
              ? const FlutterLogo(style: FlutterLogoStyle.horizontal)
              : const FlutterLogo(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _onCanvasTapUp(TapUpDetails details) {
    _hideComponentHighlight(selectedComponentId);
    selectedComponentId = null;
    controller.hideAllLinkJoints();

    controller.addComponent(
      ComponentData(
        size: const Size(400, 300),
        position: controller.fromCanvasCoordinates(details.localPosition),
        data: MyComponentData(),
        type: ['rainbow', 'random', 'flutter'][math.Random().nextInt(3)],
      ),
    );
  }

  void _onComponentTap(String componentId) {
    _hideComponentHighlight(selectedComponentId);
    controller.hideAllLinkJoints();

    bool connected = _connectComponents(selectedComponentId, componentId);
    if (connected) {
      selectedComponentId = null;
    } else {
      selectedComponentId = componentId;
      _highlightComponent(componentId);
    }
  }

  void _onComponentLongPress(String componentId) {
    _hideComponentHighlight(selectedComponentId);
    selectedComponentId = null;
    controller.hideAllLinkJoints();
    controller.removeComponent(componentId);
  }

  void _onComponentScaleStart(String componentId, ScaleStartDetails details) {
    lastFocalPoint = details.localFocalPoint;
  }

  void _onComponentScaleUpdate(String componentId, ScaleUpdateDetails details) {
    Offset positionDelta = details.localFocalPoint - lastFocalPoint;
    controller.moveComponent(componentId, positionDelta);
    lastFocalPoint = details.localFocalPoint;
  }

  bool _connectComponents(
      String? sourceComponentId, String? targetComponentId) {
    if (sourceComponentId == null || targetComponentId == null) {
      return false;
    }
    if (sourceComponentId == targetComponentId) {
      return false;
    }
    // test if the connection between two components already exists (one way)
    if (controller
        .getComponent(sourceComponentId)
        .connections
        .any((connection) =>
            (connection is OutgoingConnection) &&
            (connection.otherComponentId == targetComponentId))) {
      return false;
    }

    controller.connect(
      sourceComponentId: sourceComponentId,
      targetComponentId: targetComponentId,
      linkStyle: const LinkStyle(
        arrowType: ArrowType.arrow,
        lineWidth: 8,
        backArrowType: ArrowType.centerCircle,
        color: Colors.green,
        arrowSize: 15,
        backArrowSize: 10,
        lineType: LineType.dashed,
      ),
    );

    return true;
  }

  void _highlightComponent(String componentId) {
    controller.getComponent(componentId).data?.showHighlight();
    controller.getComponent(componentId).updateComponent();
  }

  void _hideComponentHighlight(String? componentId) {
    if (selectedComponentId != null && componentId != null) {
      controller.getComponent(componentId).data?.hideHighlight();
      controller.getComponent(componentId).updateComponent();
    }
  }

  void _deleteAllComponents() {
    selectedComponentId = null;
    controller.removeAllComponents();
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
                child: DiagramEditor(
                  controller: controller,
                  componentBuilder: _componentBuilder,
                  onCanvasTapUp: _onCanvasTapUp,
                  onComponentTap: _onComponentTap,
                  onComponentLongPress: _onComponentLongPress,
                  onComponentScaleStart: _onComponentScaleStart,
                  onComponentScaleUpdate: _onComponentScaleUpdate,
                ),
              ),
              GestureDetector(
                onTap: () => _deleteAllComponents(),
                child: Container(
                  width: 80,
                  height: 32,
                  color: Colors.red,
                  child: const Center(child: Text('delete all')),
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

// Custom component Data

class MyComponentData {
  bool isHighlightVisible;
  Color color = Color.fromARGB(
    255,
    math.Random().nextInt(256),
    math.Random().nextInt(256),
    math.Random().nextInt(256),
  );

  MyComponentData({
    this.isHighlightVisible = false,
  });

  void switchHighlight() {
    isHighlightVisible = !isHighlightVisible;
  }

  void showHighlight() {
    isHighlightVisible = true;
  }

  void hideHighlight() {
    isHighlightVisible = false;
  }
}
