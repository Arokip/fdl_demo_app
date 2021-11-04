import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/hierarchical_example/option_icon.dart';
import 'package:diagram_editor_apps/hierarchical_example/policy/custom_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

mixin MyComponentWidgetsPolicy implements ComponentWidgetsPolicy, CustomPolicy {
  @override
  Widget showCustomWidgetWithComponentDataOver(
      BuildContext context, ComponentData componentData) {
    return Visibility(
      visible: componentData.data.isHighlightVisible,
      child: Stack(
        children: [
          componentTopOptions(componentData, context),
          componentBottomOptions(componentData),
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
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.delete_forever,
            tooltip: 'delete',
            size: 40,
            onPressed: () {
              canvasWriter.model.removeComponent(componentData.id);
              selectedComponentId = null;
            },
          ),
          SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.person_add,
            tooltip: 'add parent',
            size: 40,
            onPressed: () {
              isReadyToAddParent = true;
              componentData.updateComponent();
            },
          ),
          SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.person_remove,
            tooltip: 'remove parent',
            size: 40,
            onPressed: () {
              canvasWriter.model.removeComponentParent(componentData.id);
              componentData.updateComponent();
            },
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
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.arrow_upward,
            tooltip: 'bring to front',
            size: 24,
            shape: BoxShape.rectangle,
            onPressed: () =>
                canvasWriter.model.moveComponentToTheFront(componentData.id),
          ),
          SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.arrow_downward,
            tooltip: 'move to back',
            size: 24,
            shape: BoxShape.rectangle,
            onPressed: () =>
                canvasWriter.model.moveComponentToTheBack(componentData.id),
          ),
          SizedBox(width: 40),
        ],
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
                  border: Border.all(color: Colors.grey[200]!),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
