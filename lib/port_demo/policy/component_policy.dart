import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/port_demo/policy/custom_policy.dart';
import 'package:flutter/material.dart';

mixin MyComponentPolicy implements ComponentPolicy, CustomStatePolicy {
  onComponentTap(String componentId) {
    hideAllHighlights();

    // TODO: continue here
    // port HL
    // todo better

    bool connected = connectComponents(selectedComponentId, componentId);
    if (connected) {
      print('connected');
      selectedComponentId = null;
    } else {
      selectedComponentId = componentId;
      canvasWriter.model.moveComponentToTheFrontWithChildren(componentId);

      if (canvasReader.model.getComponent(componentId).type == 'rect') {
        canvasReader.model.getComponent(componentId).data.showHighlight();
      }
    }

    canvasWriter.model.hideAllLinkJoints();
    canvasWriter.model.hideAllTapLinkWidgets();
  }

  Offset lastFocalPoint;

  onComponentScaleStart(componentId, details) {
    lastFocalPoint = details.localFocalPoint;

    canvasWriter.model.hideAllTapLinkWidgets();
  }

  onComponentScaleUpdate(componentId, details) {
    if (canvasReader.model.getComponent(componentId).parentId == null) {
      canvasWriter.model.moveComponentWithChildren(
          componentId, details.localFocalPoint - lastFocalPoint);
      lastFocalPoint = details.localFocalPoint;
    }
  }

  bool connectComponents(String sourceComponentId, String targetComponentId) {
    if (sourceComponentId == null) {
      return false;
    }
    if (sourceComponentId == targetComponentId) {
      return false;
    }
    if (canvasReader.model.getComponent(sourceComponentId).connections.any(
        (connection) => connection.otherComponentId == targetComponentId)) {
      return false;
    }

    // TODO type

    canvasWriter.model.connectTwoComponents(
      sourceComponentId: sourceComponentId,
      targetComponentId: targetComponentId,
      linkStyle: LinkStyle(
        arrowType: ArrowType.pointedArrow,
        lineWidth: 1.5,
      ),
    );
    return true;
  }
}
