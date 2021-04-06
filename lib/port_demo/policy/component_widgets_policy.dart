import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/port_demo/policy/custom_policy.dart';
import 'package:flutter/material.dart';

mixin MyComponentWidgetsPolicy
    implements ComponentWidgetsPolicy, CustomStatePolicy {
  @override
  Widget showCustomWidgetWithComponentDataOver(
      BuildContext context, ComponentData componentData) {
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
  Widget showCustomWidgetWithComponentData(
      BuildContext context, ComponentData componentData) {
    switch (componentData.type) {
      case 'rect':
        return Visibility(
          visible: componentData.data.isHighlightVisible,
          child: Stack(
            children: [
              Positioned(
                left: canvasReader.state
                    .toCanvasCoordinates(componentData.position +
                        componentData.size.bottomRight(Offset.zero))
                    .dx,
                top: canvasReader.state
                    .toCanvasCoordinates(componentData.position +
                        componentData.size.bottomRight(Offset.zero))
                    .dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    canvasWriter.model.resizeComponent(componentData.id,
                        details.delta / canvasReader.state.scale);
                    canvasWriter.model.updateComponentLinks(componentData.id);
                  },
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
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
}
