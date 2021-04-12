import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/port_demo_old/widget/port_body_widget.dart';
import 'package:flutter/material.dart';

mixin CustomStatePolicy implements PolicySet {
  int custom = 0;
  String selectedComponentId;

  String selectedLinkId;

  hideAllHighlights() {
    canvasReader.model.getAllComponents().values.forEach((component) {
      if (component.type == 'rect' && component.data.isHighlightVisible) {
        component.data.hideHighlight();
        canvasWriter.model.updateComponent(component.id);
      }
    });
  }

  addPort(String componentId, Color color, Alignment alignment, Size size) {
    String portId = canvasWriter.model.addComponent(
      ComponentData(
        position: canvasReader.model.getComponent(componentId).position +
            canvasReader.model
                .getComponent(componentId)
                .getPointOnComponent(alignment) -
            (size.bottomRight(Offset.zero) / 2),
        data: PortData(color: color),
        size: size,
        type: 'port',
      ),
    );
    canvasWriter.model.setComponentParent(portId, componentId);
  }
}

mixin CustomBehaviourPolicy implements PolicySet, CustomStatePolicy {
  removeAll() {
    print('custom butt: ${custom++}');
    canvasWriter.model.removeAllComponents();
  }

  resetView() {
    print('custom butt: ${custom++}');
    canvasWriter.state.resetCanvasView();
  }
}
