import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/policy/default_custom_policy.dart';
import 'package:diagram_editor_apps/widget/rect_widget_body.dart';
import 'package:flutter/material.dart';

mixin DefaultCanvasWidgetsPolicy
    implements CanvasWidgetsPolicy, CustomStatePolicy {
  @override
  Widget showCustomWidgetWithComponentDataOver(ComponentData componentData) {
    switch (componentData.type) {
      case 'rect':
        return Visibility(
          visible: componentData.data.isHighlightVisible,
          child: Positioned(
            left: canvasReader.state
                    .toCanvasCoordinates(componentData.position)
                    .dx -
                50,
            top: canvasReader.state
                    .toCanvasCoordinates(componentData.position)
                    .dy -
                50,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                color: Colors.blue,
                onPressed: () {
                  canvasWriter.model
                      .removeComponentWithChildren(componentData.id);
                  selectedComponentId = null;
                },
                icon: Icon(Icons.delete_forever, color: Colors.white),
              ),
            ),
          ),
        );
        break;
      case 'port':
        return SizedBox.shrink();
        break;
      default:
        return SizedBox.shrink();
        break;
    }
  }

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
        type: 'rect',
      ),
    );

    addPort(componentId, Colors.orange, Alignment.centerLeft, Size(16, 16));
    addPort(
        componentId, Colors.deepOrange, Alignment.centerRight, Size(16, 16));

    canvasWriter.model.moveComponentToTheFrontWithChildren(componentId);
  }
}
