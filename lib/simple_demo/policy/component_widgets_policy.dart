import 'dart:math' as math;

import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/custom_data.dart';
import 'package:diagram_editor_apps/simple_demo/edit_dialog.dart';
import 'package:diagram_editor_apps/simple_demo/policy/custom_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

mixin MyComponentWidgetsPolicy
    implements ComponentWidgetsPolicy, CustomStatePolicy {
  @override
  Widget showCustomWidgetWithComponentDataOver(ComponentData componentData) {
    return Visibility(
      visible: componentData.data.isHighlightVisible,
      child: Stack(
        children: [
          componentTopOptions(componentData),
          componentBottomOptions(componentData),
          highlight(componentData),
          resizeCorner(componentData),
        ],
      ),
    );
  }

  Widget componentTopOptions(ComponentData componentData) {
    Offset componentPosition =
        canvasReader.state.toCanvasCoordinates(componentData.position);
    return Positioned(
      left: componentPosition.dx - 24,
      top: componentPosition.dy - 48,
      child: Row(
        children: [
          option(
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
          option(
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
          option(
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
          option(
            color: Colors.greenAccent,
            iconData: Icons.link_off,
            tooltip: 'remove links',
            size: 40,
            onPressed: () =>
                canvasWriter.model.removeComponentConnections(componentData.id),
          ),
          SizedBox(width: 12),
          EditOptionWithContext(componentData: componentData),
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
          option(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.arrow_upward,
            tooltip: 'bring to front',
            size: 24,
            shape: BoxShape.rectangle,
            onPressed: () =>
                canvasWriter.model.moveComponentToTheBack(componentData.id),
          ),
          SizedBox(width: 12),
          option(
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

  Widget option({
    Color color = Colors.grey,
    double size = 40,
    BoxShape shape = BoxShape.circle,
    String tooltip,
    IconData iconData,
    Color iconColor = Colors.black,
    double iconSize = 20,
    Function onPressed,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: shape,
      ),
      child: IconButton(
        tooltip: tooltip,
        onPressed: () {
          if (onPressed != null) {
            onPressed();
          }
        },
        padding: EdgeInsets.all(0),
        icon: Icon(
          iconData,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}

class EditOptionWithContext extends StatelessWidget {
  final ComponentData componentData;

  const EditOptionWithContext({
    Key key,
    this.componentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        tooltip: 'edit',
        onPressed: () {
          showEditComponentDialog(context, componentData);
        },
        icon: Icon(Icons.edit, color: Colors.black),
      ),
    );
  }
}
