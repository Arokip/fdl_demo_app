import 'dart:math' as math;

import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/grid_example/widget/basic_component.dart';
import 'package:diagram_editor_apps/grid_example/widget/snap_switch.dart';
import 'package:flutter/material.dart';

void main() => runApp(const GridDiagramEditor());

enum Movement { topLeft, topRight, bottomLeft, bottomRight }

class GridDiagramEditor extends StatefulWidget {
  const GridDiagramEditor({super.key});

  @override
  GridDiagramEditorState createState() => GridDiagramEditorState();
}

class GridDiagramEditorState extends State<GridDiagramEditor> {
  final DiagramController<void, void> controller =
      DiagramController<void, void>();

  // Grid state
  double gridGap = 80;
  double snapSize = 20;
  bool isSnappingEnabled = true;

  // Movement tracking
  late Offset startFocalPosition;
  late Offset startComponentPosition;
  Offset lastPositionChange = Offset.zero;
  Movement movement = Movement.topLeft;

  void switchIsSnappingEnabled() {
    setState(() {
      isSnappingEnabled = !isSnappingEnabled;
    });
  }

  void deleteAllComponents() {
    controller.removeAllComponents();
  }

  void _onCanvasTapUp(TapUpDetails details) {
    controller.addComponent(
      ComponentData(
        size: Size(
          math.Random().nextInt(160) + 80.0,
          math.Random().nextInt(160) + 80.0,
        ),
        position: controller.fromCanvasCoordinates(details.localPosition),
      ),
    );
  }

  void _onComponentLongPress(String componentId) {
    controller.removeComponent(componentId);
  }

  void _onComponentScaleStart(String componentId, ScaleStartDetails details) {
    startFocalPosition = details.localFocalPoint;
    startComponentPosition = controller.getComponent(componentId).position;
  }

  void _onComponentScaleUpdate(String componentId, ScaleUpdateDetails details) {
    Offset positionChange = details.localFocalPoint - startFocalPosition;
    Offset newPosition =
        startComponentPosition + positionChange / controller.canvasScale;
    controller.setComponentPosition(componentId, newPosition);

    if (isSnappingEnabled) {
      var component = controller.getComponent(componentId);
      double finalPosX = newPosition.dx;
      double finalPosY = newPosition.dy;

      bool isCloser(double position, [double size = 0]) {
        if (size == 0) {
          return (position) % gridGap < snapSize;
        } else {
          return (position + size + snapSize) % gridGap < snapSize;
        }
      }

      Offset delta = lastPositionChange - positionChange;

      if (delta.dx > 0 && delta.dy > 0) {
        movement = Movement.topLeft;
      } else if (delta.dx < 0 && delta.dy > 0) {
        movement = Movement.topRight;
      } else if (delta.dx > 0 && delta.dy < 0) {
        movement = Movement.bottomLeft;
      } else if (delta.dx < 0 && delta.dy < 0) {
        movement = Movement.bottomRight;
      } else if (delta.dx == 0 && delta.dy > 0) {
        if (movement != Movement.topRight) movement = Movement.topLeft;
      } else if (delta.dx == 0 && delta.dy < 0) {
        if (movement != Movement.bottomRight) movement = Movement.bottomLeft;
      } else if (delta.dy == 0 && delta.dx > 0) {
        if (movement != Movement.bottomLeft) movement = Movement.topLeft;
      } else if (delta.dy == 0 && delta.dx < 0) {
        if (movement != Movement.bottomRight) movement = Movement.topRight;
      }

      switch (movement) {
        case Movement.topLeft:
          if (isCloser(newPosition.dx)) {
            finalPosX = newPosition.dx - newPosition.dx % gridGap;
          }
          if (isCloser(newPosition.dy)) {
            finalPosY = newPosition.dy - newPosition.dy % gridGap;
          }
          break;
        case Movement.topRight:
          if (isCloser(newPosition.dx, component.size.width)) {
            finalPosX = newPosition.dx +
                snapSize -
                (newPosition.dx + component.size.width + snapSize) % gridGap;
          }
          if (isCloser(newPosition.dy)) {
            finalPosY = newPosition.dy - newPosition.dy % gridGap;
          }
          break;
        case Movement.bottomLeft:
          if (isCloser(newPosition.dx)) {
            finalPosX = newPosition.dx - newPosition.dx % gridGap;
          }
          if (isCloser(newPosition.dy, component.size.height)) {
            finalPosY = newPosition.dy +
                snapSize -
                (newPosition.dy + component.size.height + snapSize) % gridGap;
          }
          break;
        case Movement.bottomRight:
          if (isCloser(newPosition.dx, component.size.width)) {
            finalPosX = newPosition.dx +
                snapSize -
                (newPosition.dx + component.size.width + snapSize) % gridGap;
          }
          if (isCloser(newPosition.dy, component.size.height)) {
            finalPosY = newPosition.dy +
                snapSize -
                (newPosition.dy + component.size.height + snapSize) % gridGap;
          }
          break;
      }

      controller.setComponentPosition(
          componentId, Offset(finalPosX, finalPosY));
    }

    lastPositionChange = positionChange;
  }

  void _onComponentScaleEnd(String componentId, ScaleEndDetails details) {
    lastPositionChange = Offset.zero;
  }

  List<Widget> _backgroundBuilder(BuildContext context) {
    return [
      CustomPaint(
        size: Size.infinite,
        painter: GridPainter(
          horizontalGap: gridGap,
          verticalGap: gridGap,
          offset: controller.canvasPosition / controller.canvasScale,
          scale: controller.canvasScale,
          lineWidth:
              (controller.canvasScale < 1.0) ? controller.canvasScale : 1.0,
          matchParentSize: false,
          lineColor: const Color(0xFF0D47A1),
        ),
      ),
    ];
  }

  Widget _componentBuilder(BuildContext context, ComponentData<void> componentData) {
    return const BasicComponent();
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
                  backgroundBuilder: _backgroundBuilder,
                  componentBuilder: _componentBuilder,
                  onCanvasTapUp: _onCanvasTapUp,
                  onComponentLongPress: _onComponentLongPress,
                  onComponentScaleStart: _onComponentScaleStart,
                  onComponentScaleUpdate: _onComponentScaleUpdate,
                  onComponentScaleEnd: _onComponentScaleEnd,
                ),
              ),
              GestureDetector(
                onTap: () => deleteAllComponents(),
                child: Container(
                  width: 80,
                  height: 32,
                  color: Colors.red,
                  child: const Center(child: Text('delete all')),
                ),
              ),
              SnapSwitch(
                isSnappingEnabled: isSnappingEnabled,
                onToggle: switchIsSnappingEnabled,
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
