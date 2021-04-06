import 'dart:math' as math;

import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/custom_data.dart';
import 'package:diagram_editor_apps/simple_demo/edit_dialog.dart';
import 'package:diagram_editor_apps/simple_demo/policy/custom_policy.dart';
import 'package:diagram_editor_apps/simple_demo/widget/option_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

mixin MyComponentWidgetsPolicy
    implements ComponentWidgetsPolicy, CustomStatePolicy {
  @override
  Widget showCustomWidgetWithComponentDataOver(
      BuildContext context, ComponentData componentData) {
    return Visibility(
      visible: componentData.data.isHighlightVisible,
      child: Stack(
        children: [
          componentTopOptions(componentData, context),
          componentBottomOptions(componentData),
          highlight(componentData),
          resizeCorner(componentData),
        ],
      ),
    );
  }

  Widget componentTopOptions(ComponentData componentData, context) {
    Offset componentPosition =
        canvasReader.state.toCanvasCoordinates(componentData.position);
    return Positioned(
      left: componentPosition.dx - 24,
      top: componentPosition.dy - 48,
      child: Row(
        children: [
          OptionWidget(
            color: Colors.red,
            iconData: Icons.delete_forever,
            tooltip: 'delete',
            size: 40,
            onPressed: () {
              canvasWriter.model.removeComponentWithChildren(componentData.id);
              selectedComponentId = null;
            },
          ),
          SizedBox(width: 12),
          OptionWidget(
            color: Colors.yellow,
            iconData: Icons.copy,
            tooltip: 'duplicate',
            size: 40,
            onPressed: () {
              var cd = ComponentData(
                type: componentData.type,
                size: componentData.size,
                minSize: componentData.minSize,
                data: CustomData.copy(componentData.data),
                position: componentData.position + Offset(20, 20),
              );
              String id = canvasWriter.model.addComponent(cd);
              canvasWriter.model.moveComponentToTheFront(id);
            },
          ),
          SizedBox(width: 12),
          OptionWidget(
            color: Colors.lightGreen,
            iconData: Icons.color_lens,
            tooltip: 'random color',
            size: 40,
            onPressed: () {
              componentData.data.color =
                  Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                      .withOpacity(1.0);
              componentData.updateComponent();
            },
          ),
          SizedBox(width: 12),
          OptionWidget(
            color: Colors.greenAccent,
            iconData: Icons.link_off,
            tooltip: 'remove links',
            size: 40,
            onPressed: () =>
                canvasWriter.model.removeComponentConnections(componentData.id),
          ),
          SizedBox(width: 12),
          OptionWidget(
            color: Colors.blueGrey,
            iconData: Icons.edit,
            tooltip: 'edit',
            size: 40,
            onPressed: () => showEditComponentDialog(context, componentData),
          ),
        ],
      ),
    );
  }

  Widget componentBottomOptions(ComponentData componentData) {
    Offset componentBottomLeftCorner = canvasReader.state.toCanvasCoordinates(
        componentData.position + componentData.size.bottomLeft(Offset.zero));
    return Positioned(
      left: componentBottomLeftCorner.dx - 16,
      top: componentBottomLeftCorner.dy + 8,
      child: Row(
        children: [
          OptionWidget(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.arrow_upward,
            tooltip: 'bring to front',
            size: 24,
            shape: BoxShape.rectangle,
            onPressed: () =>
                canvasWriter.model.moveComponentToTheBack(componentData.id),
          ),
          SizedBox(width: 12),
          OptionWidget(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.arrow_downward,
            tooltip: 'move to back',
            size: 24,
            shape: BoxShape.rectangle,
            onPressed: () =>
                canvasWriter.model.moveComponentToTheBack(componentData.id),
          ),
        ],
      ),
    );
  }

  Widget highlight(ComponentData componentData) {
    return Positioned(
      left: canvasReader.state.toCanvasCoordinates(componentData.position).dx,
      top: canvasReader.state.toCanvasCoordinates(componentData.position).dy,
      child: CustomPaint(
        painter: ComponentHighlightPainter(
          width: componentData.size.width * canvasReader.state.scale,
          height: componentData.size.height * canvasReader.state.scale,
        ),
      ),
    );
  }

  resizeCorner(ComponentData componentData) {
    Offset componentBottomRightCorner = canvasReader.state.toCanvasCoordinates(
        componentData.position + componentData.size.bottomRight(Offset.zero));
    return Positioned(
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
    );
  }
}