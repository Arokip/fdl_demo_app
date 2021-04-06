import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/policy/custom_policy.dart';
import 'package:flutter/material.dart';

mixin MyComponentPolicy implements ComponentPolicy, CustomStatePolicy {
  onComponentTap(String componentId) {
    hideAllHighlights();

    bool connected = connectComponents(selectedComponentId, componentId);
    if (connected) {
      print('connected');
      selectedComponentId = null;
    } else {
      selectedComponentId = componentId;

      highlightComponent(componentId);
    }
  }

  Offset lastFocalPoint;

  onComponentScaleStart(componentId, details) {
    lastFocalPoint = details.localFocalPoint;

    canvasWriter.model.hideAllLinkDeleteIcons();
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

    String linkId = canvasWriter.model.connectTwoComponents(
      sourceComponentId: sourceComponentId,
      targetComponentId: targetComponentId,
      linkStyle: LinkStyle(
        arrowType: ArrowType.pointedArrow,
        width: 1.5,
      ),
    );

    var link = canvasReader.model.getLink(linkId);
    link.startLabel = linkId.substring(0, 5);
    link.endLabel = linkId.substring(0, 5);

    return true;
  }
}
