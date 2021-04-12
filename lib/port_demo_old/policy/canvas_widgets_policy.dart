import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/port_demo_old/policy/custom_policy.dart';
import 'package:diagram_editor_apps/port_demo_old/widget/rect_widget_body.dart';
import 'package:flutter/material.dart';

mixin MyCanvasWidgetsPolicy implements CanvasWidgetsPolicy, CustomStatePolicy {
  @override
  List<Widget> showCustomWidgetsOnCanvasBackground(BuildContext context) {
    return [
      CustomPaint(
        size: Size.infinite,
        painter: GridPainter(
          offset: canvasReader.state.position / canvasReader.state.scale,
          scale: canvasReader.state.scale,
          lineWidth:
              (canvasReader.state.scale < 1.0) ? canvasReader.state.scale : 1.0,
          matchParentSize: false,
          lineColor: Colors.blue[900],
        ),
      ),
      DragTarget<ComponentData>(
        builder: (_, __, ___) => null,
        onWillAccept: (ComponentData data) => true,
        onAcceptWithDetails: (DragTargetDetails<ComponentData> details) =>
            _onAcceptWithDetails(details, context),
      ),
    ];
  }

  _onAcceptWithDetails(
    DragTargetDetails details,
    BuildContext context,
  ) {
    final RenderBox renderBox = context.findRenderObject();
    final Offset localOffset = renderBox.globalToLocal(details.offset);
    ComponentData componentData = details.data;
    Offset componentPosition =
        canvasReader.state.fromCanvasCoordinates(localOffset);
    String componentId = canvasWriter.model.addComponent(
      ComponentData(
        position: componentPosition,
        data: RectCustomData.copy(componentData.data),
        size: componentData.size,
        minSize: componentData.minSize,
        type: 'rect',
      ),
    );

    addPort(componentId, Colors.orange, Alignment.centerLeft, Size(16, 16));
    addPort(
        componentId, Colors.deepOrange, Alignment.centerRight, Size(16, 16));

    canvasWriter.model.moveComponentToTheFrontWithChildren(componentId);
  }
}
