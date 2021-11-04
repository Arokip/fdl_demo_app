import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/ports_example/policy/custom_policy.dart';
import 'package:flutter/material.dart';

mixin MyComponentPolicy implements ComponentPolicy, CustomPolicy {
  late Offset lastFocalPoint;

  @override
  onComponentTap(String componentId) {
    canvasWriter.model.hideAllLinkJoints();

    var component = canvasReader.model.getComponent(componentId);

    if (component.type == 'port') {
      bool connected = connectComponents(selectedPortId, componentId);
      deselectAllPorts();
      if (!connected) {
        selectPort(componentId);
      }
    }
  }

  @override
  onComponentLongPress(String componentId) {
    var component = canvasReader.model.getComponent(componentId);
    if (component.type == 'component') {
      canvasWriter.model.hideAllLinkJoints();
      canvasWriter.model.removeComponentWithChildren(componentId);
    }
  }

  @override
  onComponentScaleStart(componentId, details) {
    lastFocalPoint = details.localFocalPoint;
  }

  @override
  onComponentScaleUpdate(componentId, details) {
    Offset positionDelta = details.localFocalPoint - lastFocalPoint;

    var component = canvasReader.model.getComponent(componentId);

    if (component.type == 'component') {
      canvasWriter.model.moveComponentWithChildren(componentId, positionDelta);
    } else if (component.type == 'port') {
      if (component.parentId != null) {
        canvasWriter.model
            .moveComponentWithChildren(component.parentId!, positionDelta);
      }
    }

    lastFocalPoint = details.localFocalPoint;
  }

  bool connectComponents(String? sourceComponentId, String? targetComponentId) {
    if (!canConnectThesePorts(sourceComponentId, targetComponentId)) {
      return false;
    }

    canvasWriter.model.connectTwoComponents(
      sourceComponentId: sourceComponentId!,
      targetComponentId: targetComponentId!,
      linkStyle: LinkStyle(
        arrowType: ArrowType.pointedArrow,
        lineWidth: 1.5,
      ),
    );

    return true;
  }
}
