import 'dart:math' as math;

import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/custom_data.dart';
import 'package:diagram_editor_apps/simple_demo/policy/custom_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

mixin MyComponentWidgetsPolicy
    implements ComponentWidgetsPolicy, CustomStatePolicy {
  @override
  Widget showCustomWidgetWithComponentDataOver(ComponentData componentData) {
    Offset componentPosition =
        canvasReader.state.toCanvasCoordinates(componentData.position);
    Offset componentBottomLeftCorner = canvasReader.state.toCanvasCoordinates(
        componentData.position + componentData.size.bottomLeft(Offset.zero));
    return Visibility(
      visible: componentData.data.isHighlightVisible,
      child: Stack(
        children: [
          Positioned(
            left: componentPosition.dx - 24,
            top: componentPosition.dy - 48,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    tooltip: 'delete',
                    onPressed: () {
                      canvasWriter.model
                          .removeComponentWithChildren(componentData.id);
                      selectedComponentId = null;
                    },
                    icon: Icon(Icons.delete_forever, color: Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    tooltip: 'duplicate',
                    onPressed: () {
                      var cd = ComponentData(
                        type: componentData.type,
                        size: componentData.size,
                        data: CustomData.copy(componentData.data),
                        position: componentData.position + Offset(20, 20),
                      );
                      String id = canvasWriter.model.addComponent(cd);
                      canvasWriter.model.moveComponentToTheFront(id);
                    },
                    icon: Icon(Icons.copy, color: Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    tooltip: 'random color',
                    onPressed: () {
                      componentData.data.color =
                          Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                              .withOpacity(1.0);
                      componentData.updateComponent();
                    },
                    icon: Icon(Icons.color_lens, color: Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    tooltip: 'remove links',
                    onPressed: () {
                      canvasWriter.model
                          .removeComponentConnections(componentData.id);
                    },
                    icon: Icon(Icons.link_off, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: componentBottomLeftCorner.dx - 24,
            top: componentBottomLeftCorner.dy + 8,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    tooltip: 'move to back',
                    onPressed: () {
                      canvasWriter.model
                          .moveComponentToTheBack(componentData.id);
                    },
                    icon: Icon(Icons.arrow_downward, color: Colors.black),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    tooltip: 'move to front',
                    onPressed: () {
                      canvasWriter.model
                          .moveComponentToTheFront(componentData.id);
                    },
                    icon: Icon(Icons.arrow_upward, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: canvasReader.state
                .toCanvasCoordinates(componentData.position)
                .dx,
            top: canvasReader.state
                .toCanvasCoordinates(componentData.position)
                .dy,
            child: CustomPaint(
              painter: ComponentHighlightPainter(
                width: componentData.size.width * canvasReader.state.scale,
                height: componentData.size.height * canvasReader.state.scale,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget showCustomWidgetWithComponentData(ComponentData componentData) {
    Offset componentBottomRightCorner = canvasReader.state.toCanvasCoordinates(
        componentData.position + componentData.size.bottomRight(Offset.zero));
    canvasReader.state.toCanvasCoordinates(componentData.position);
    return Visibility(
      visible: componentData.data.isHighlightVisible,
      child: Stack(
        children: [
          Positioned(
            left: componentBottomRightCorner.dx - 12,
            top: componentBottomRightCorner.dy - 12,
            child: GestureDetector(
              onPanUpdate: (details) {
                canvasWriter.model.resizeComponent(
                    componentData.id, details.delta / canvasReader.state.scale);
                canvasWriter.model.updateComponentLinks(componentData.id);
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeDownRight,
                child: Container(
                  width: 24,
                  height: 24,
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.grey[200]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
